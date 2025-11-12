import 'dart:convert';
import 'package:http/http.dart' as http;

class AsgardeoService {
  static const String baseUrl = 'https://api.asgardeo.io/t/altitude';
  static const String clientId = '66ZUtg2HAyLbfmnZJROFhDVE3Woa';
  
  String? _accessToken;
  Map<String, dynamic>? _userInfo;
  
  bool get isLoggedIn => _accessToken != null;
  Map<String, dynamic>? get userInfo => _userInfo;
  String? get currentUserEmail => _userInfo?['email'];
  String? get currentUserName => _userInfo?['username'];
  
  Future<bool> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
          'scope': 'openid profile',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        await _fetchUserInfo();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> signUp(String username, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/scim2/Users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode({
          'schemas': ['urn:ietf:params:scim:schemas:core:2.0:User'],
          'userName': username,
          'password': password,
          'emails': [{'primary': true, 'value': email}],
        }),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> _fetchUserInfo() async {
    if (_accessToken == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/oauth2/userinfo'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      
      if (response.statusCode == 200) {
        _userInfo = jsonDecode(response.body);
      }
    } catch (e) {
      // Ignore
    }
  }
  
  Future<void> signOut() async {
    _accessToken = null;
    _userInfo = null;
  }
}