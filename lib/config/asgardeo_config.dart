class AsgardeoConfig {
  // Asgardeo configuration
  static const String baseUrl = 'https://api.asgardeo.io/t/altitude';
  static const String clientId = '66ZUtg2HAyLbfmnZJROFhDVE3Woa';
  static const String redirectUri = 'https://bledsoetech.com/';
  static const String scope = 'openid profile';
  
  // Optional: Custom scopes if you need additional permissions
  static const List<String> additionalScopes = [
    // Add any additional scopes your app needs
    // 'groups', 'roles', etc.
  ];
  
  // Get complete scope string
  static String get completeScope {
    final scopes = [scope, ...additionalScopes];
    return scopes.join(' ');
  }
  
  // Validation
  static bool get isConfigured {
    return baseUrl != 'https://api.asgardeo.io/t/your-organization' &&
           clientId != 'your-client-id' &&
           redirectUri != 'com.bledsoetech.iot://oauth/callback';
  }
  
  // Configuration instructions
  static const String configurationInstructions = '''
To configure Asgardeo authentication:

1. Go to your Asgardeo Console (https://console.asgardeo.io)
2. Create a new application or use an existing one
3. Configure the following settings:
   - Application Type: Single Page Application (SPA) or Mobile
   - Allowed Grant Types: Authorization Code with PKCE
   - Redirect URLs: Add your app's redirect URI
   - Allowed Origins: Add your app's domain (for web)

4. Update the configuration in lib/config/asgardeo_config.dart:
   - baseUrl: Your organization's API URL
   - clientId: Your application's client ID
   - redirectUri: Your app's redirect URI

5. For mobile apps, configure deep linking:
   - Android: Update android/app/src/main/AndroidManifest.xml
   - iOS: Update ios/Runner/Info.plist
''';
}