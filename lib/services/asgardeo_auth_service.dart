import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/asgardeo_config.dart';

class AsgardeoAuthService {
  // Use configuration from config file
  static String get _baseUrl => AsgardeoConfig.baseUrl;
  static String get _clientId => AsgardeoConfig.clientId;
  static String get _redirectUri => AsgardeoConfig.redirectUri;
  static String get _scope => AsgardeoConfig.completeScope;
  
  // Storage keys
  static const String _accessTokenKey = 'asgardeo_access_token';
  static const String _refreshTokenKey = 'asgardeo_refresh_token';
  static const String _idTokenKey = 'asgardeo_id_token';
  static const String _userInfoKey = 'asgardeo_user_info';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // User info
  Map<String, dynamic>? _userInfo;
  String? _accessToken;
  String? _refreshToken;
  String? _idToken;
  
  // Getters
  bool get isLoggedIn => _accessToken != null && !_isTokenExpired(_accessToken!);
  Map<String, dynamic>? get userInfo => _userInfo;
  String? get currentUserEmail => _userInfo?['email'];
  String? get currentUserName => _userInfo?['given_name'] ?? _userInfo?['name'];
  
  // Initialize service and check for existing tokens
  Future<void> initialize() async {
    try {
      _accessToken = await _secureStorage.read(key: _accessTokenKey);
      _refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      _idToken = await _secureStorage.read(key: _idTokenKey);
      
      final userInfoJson = await _secureStorage.read(key: _userInfoKey);
      if (userInfoJson != null) {
        _userInfo = jsonDecode(userInfoJson);
      }
      
      // Check if access token is expired and refresh if needed
      if (_accessToken != null && _isTokenExpired(_accessToken!)) {
        if (_refreshToken != null) {
          await _refreshAccessToken();
        } else {
          await signOut();
        }
      }
    } catch (e) {
      debugPrint('Error initializing Asgardeo auth: $e');
      await signOut(); // Clear any corrupted data
    }
  }
  
  // Generate PKCE challenge
  String _generateCodeVerifier() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(128, (i) => chars[random.nextInt(chars.length)]).join();
  }
  
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
  
  // Start OAuth flow
  Future<bool> signInWithAsgardeo() async {
    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);
      final state = _generateRandomString(32);
      
      // Store PKCE verifier and state for later use
      await _secureStorage.write(key: 'pkce_verifier', value: codeVerifier);
      await _secureStorage.write(key: 'oauth_state', value: state);
      
      final authUrl = Uri.parse('$_baseUrl/oauth2/authorize').replace(
        queryParameters: {
          'response_type': 'code',
          'client_id': _clientId,
          'redirect_uri': _redirectUri,
          'scope': _scope,
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256',
          'state': state,
        },
      );
      
      // Launch browser for authentication
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(
          authUrl,
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        throw 'Could not launch authentication URL';
      }
    } catch (e) {
      debugPrint('Error starting OAuth flow: $e');
      throw 'Failed to start authentication: $e';
    }
  }
  
  // Handle OAuth callback
  Future<bool> handleAuthCallback(String callbackUrl) async {
    try {
      final uri = Uri.parse(callbackUrl);
      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];
      final error = uri.queryParameters['error'];
      
      if (error != null) {
        throw 'Authentication error: $error';
      }
      
      if (code == null || state == null) {
        throw 'Invalid callback parameters';
      }
      
      // Verify state
      final storedState = await _secureStorage.read(key: 'oauth_state');
      if (state != storedState) {
        throw 'Invalid state parameter';
      }
      
      // Exchange code for tokens
      final codeVerifier = await _secureStorage.read(key: 'pkce_verifier');
      if (codeVerifier == null) {
        throw 'Missing PKCE verifier';
      }
      
      await _exchangeCodeForTokens(code, codeVerifier);
      
      // Clean up temporary storage
      await _secureStorage.delete(key: 'pkce_verifier');
      await _secureStorage.delete(key: 'oauth_state');
      
      return true;
    } catch (e) {
      debugPrint('Error handling auth callback: $e');
      throw 'Authentication failed: $e';
    }
  }
  
  // Exchange authorization code for tokens
  Future<void> _exchangeCodeForTokens(String code, String codeVerifier) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'code': code,
          'redirect_uri': _redirectUri,
          'code_verifier': codeVerifier,
        },
      );
      
      if (response.statusCode == 200) {
        final tokenData = jsonDecode(response.body);
        
        _accessToken = tokenData['access_token'];
        _refreshToken = tokenData['refresh_token'];
        _idToken = tokenData['id_token'];
        
        // Store tokens securely
        await _secureStorage.write(key: _accessTokenKey, value: _accessToken);
        if (_refreshToken != null) {
          await _secureStorage.write(key: _refreshTokenKey, value: _refreshToken);
        }
        if (_idToken != null) {
          await _secureStorage.write(key: _idTokenKey, value: _idToken);
        }
        
        // Get user info
        await _fetchUserInfo();
      } else {
        throw 'Token exchange failed: ${response.body}';
      }
    } catch (e) {
      debugPrint('Error exchanging code for tokens: $e');
      throw 'Failed to complete authentication: $e';
    }
  }
  
  // Fetch user information
  Future<void> _fetchUserInfo() async {
    if (_accessToken == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/oauth2/userinfo'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );
      
      if (response.statusCode == 200) {
        _userInfo = jsonDecode(response.body);
        await _secureStorage.write(
          key: _userInfoKey,
          value: jsonEncode(_userInfo),
        );
      } else {
        debugPrint('Failed to fetch user info: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }
  
  // Refresh access token
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      await signOut();
      return;
    }
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'refresh_token': _refreshToken!,
        },
      );
      
      if (response.statusCode == 200) {
        final tokenData = jsonDecode(response.body);
        
        _accessToken = tokenData['access_token'];
        if (tokenData['refresh_token'] != null) {
          _refreshToken = tokenData['refresh_token'];
        }
        
        // Update stored tokens
        await _secureStorage.write(key: _accessTokenKey, value: _accessToken);
        if (_refreshToken != null) {
          await _secureStorage.write(key: _refreshTokenKey, value: _refreshToken);
        }
        
        // Refresh user info
        await _fetchUserInfo();
      } else {
        debugPrint('Token refresh failed: ${response.body}');
        await signOut();
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      await signOut();
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      // Revoke tokens if possible
      if (_accessToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/oauth2/revoke'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'client_id': _clientId,
            'token': _accessToken!,
            'token_type_hint': 'access_token',
          },
        );
      }
    } catch (e) {
      debugPrint('Error revoking token: $e');
    }
    
    // Clear all stored data
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _idTokenKey);
    await _secureStorage.delete(key: _userInfoKey);
    
    _accessToken = null;
    _refreshToken = null;
    _idToken = null;
    _userInfo = null;
  }
  
  // Check if token is expired
  bool _isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // Assume expired if we can't decode
    }
  }
  
  // Generate random string
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (i) => chars[random.nextInt(chars.length)]).join();
  }
  
  // Get access token for API calls
  Future<String?> getAccessToken() async {
    if (_accessToken != null && !_isTokenExpired(_accessToken!)) {
      return _accessToken;
    }
    
    if (_refreshToken != null) {
      await _refreshAccessToken();
      return _accessToken;
    }
    
    return null;
  }
}