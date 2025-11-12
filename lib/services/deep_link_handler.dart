import 'dart:async';
import 'package:flutter/services.dart';
import 'package:iot/services/asgardeo_auth_service.dart';

class DeepLinkHandler {
  static const MethodChannel _channel = MethodChannel('deep_link_handler');
  static final AsgardeoAuthService _asgardeoAuth = AsgardeoAuthService();
  
  static StreamController<String>? _linkStreamController;
  static Stream<String>? _linkStream;
  
  // Initialize deep link handling
  static Future<void> initialize() async {
    _linkStreamController = StreamController<String>.broadcast();
    _linkStream = _linkStreamController!.stream;
    
    // Listen for deep links
    _channel.setMethodCallHandler(_handleMethodCall);
    
    // Check for initial link (when app is launched via deep link)
    try {
      final String? initialLink = await _channel.invokeMethod('getInitialLink');
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }
  }
  
  // Handle method calls from native platforms
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDeepLink':
        final String link = call.arguments;
        _handleDeepLink(link);
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }
  
  // Handle deep link
  static void _handleDeepLink(String link) {
    print('Received deep link: $link');
    
    // Check if it's an OAuth callback
    if (link.startsWith('https://bledsoetech.com/')) {
      _handleOAuthCallback(link);
    }
    
    // Broadcast the link to listeners
    _linkStreamController?.add(link);
  }
  
  // Handle OAuth callback
  static Future<void> _handleOAuthCallback(String callbackUrl) async {
    try {
      final success = await _asgardeoAuth.handleAuthCallback(callbackUrl);
      if (success) {
        print('OAuth authentication successful');
        // You can add navigation logic here or emit an event
      }
    } catch (e) {
      print('OAuth callback error: $e');
    }
  }
  
  // Get link stream
  static Stream<String>? get linkStream => _linkStream;
  
  // Dispose resources
  static void dispose() {
    _linkStreamController?.close();
    _linkStreamController = null;
    _linkStream = null;
  }
}