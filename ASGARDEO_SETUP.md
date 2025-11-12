# WSO2 Asgardeo Integration Setup

This guide will help you configure WSO2 Asgardeo authentication for your IoT Flutter app.

## Prerequisites

1. WSO2 Asgardeo account (sign up at https://console.asgardeo.io)
2. Flutter development environment
3. Android/iOS development setup

## Step 1: Create Asgardeo Application

1. Log in to your Asgardeo Console
2. Go to **Applications** > **New Application**
3. Choose **Single Page Application** or **Mobile Application**
4. Fill in the application details:
   - **Name**: ProHome IoT App
   - **Description**: Smart Home IoT Control System

## Step 2: Configure Application Settings

### General Settings
- **Allowed Grant Types**: Authorization Code with PKCE
- **Public Client**: Enable this option
- **Allowed Origins**: Add your app's domain (for web testing)

### Protocol Settings
- **Redirect URLs**: Add your app's redirect URI
  ```
  com.bledsoetech.iot://oauth/callback
  ```
- **Allowed Origins**: Add your development URLs if testing on web
- **PKCE**: Mandatory (should be enabled by default)

### Advanced Settings
- **Token Endpoint Authentication Method**: None (for public clients)
- **Refresh Token**: Enable
- **ID Token**: Enable

## Step 3: Update App Configuration

1. Open `lib/config/asgardeo_config.dart`
2. Update the following values with your Asgardeo application details:

```dart
class AsgardeoConfig {
  // Replace with your organization's URL
  static const String baseUrl = 'https://api.asgardeo.io/t/YOUR_ORG_NAME';
  
  // Replace with your application's client ID
  static const String clientId = 'YOUR_CLIENT_ID';
  
  // Replace with your app's redirect URI (must match Asgardeo config)
  static const String redirectUri = 'com.bledsoetech.iot
://oauth/callback';
  
  static const String scope = 'openid profile email';
}
```

### Finding Your Configuration Values

- **Organization Name**: Found in your Asgardeo console URL
- **Client ID**: Found in your application's **General** tab
- **Base URL**: `https://api.asgardeo.io/t/YOUR_ORG_NAME`

## Step 4: Configure Deep Linking

### Android Configuration

The Android configuration is already set up in `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="com.bledsoetech.iot" android:host="oauth" />
</intent-filter>
```

### iOS Configuration (if targeting iOS)

Add the following to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.bledsoetech.iot.oauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.bledsoetech.iot</string>
        </array>
    </dict>
</array>
```

## Step 5: Install Dependencies

Run the following command to install required packages:

```bash
flutter pub get
```

## Step 6: Test the Integration

1. Run your Flutter app:
   ```bash
   flutter run
   ```

2. Tap "Sign in with Asgardeo" on the login screen
3. Complete authentication in the browser
4. You should be redirected back to the app

## Troubleshooting

### Common Issues

1. **Configuration Not Found Error**
   - Ensure you've updated `asgardeo_config.dart` with correct values
   - Check that your organization name and client ID are correct

2. **Deep Link Not Working**
   - Verify the redirect URI in Asgardeo matches your app configuration
   - Check Android manifest has the correct intent filter
   - For iOS, ensure Info.plist is properly configured

3. **Authentication Fails**
   - Check your Asgardeo application settings
   - Ensure PKCE is enabled
   - Verify allowed grant types include "Authorization Code"

4. **Token Issues**
   - Check if refresh tokens are enabled in Asgardeo
   - Verify token expiration settings

### Debug Mode

Enable debug logging by adding this to your app:

```dart
import 'package:flutter/foundation.dart';

// Add this in your main() function
if (kDebugMode) {
  print('Debug mode enabled for Asgardeo auth');
}
```

## Security Considerations

1. **Client Secret**: Not required for mobile apps using PKCE
2. **Redirect URI**: Must be registered in Asgardeo console
3. **Token Storage**: Tokens are stored securely using Flutter Secure Storage
4. **HTTPS**: Always use HTTPS in production

## Additional Features

### Custom Scopes

To request additional user information, add scopes in `asgardeo_config.dart`:

```dart
static const List<String> additionalScopes = [
  'groups',
  'roles',
  // Add other scopes as needed
];
```

### User Profile

Access user information after authentication:

```dart
final asgardeoAuth = AsgardeoAuthService();
final userInfo = asgardeoAuth.userInfo;
final email = asgardeoAuth.currentUserEmail;
final name = asgardeoAuth.currentUserName;
```

## Support

For issues related to:
- **Asgardeo Configuration**: Check [Asgardeo Documentation](https://wso2.com/asgardeo/docs/)
- **Flutter Integration**: Review the code in `lib/services/asgardeo_auth_service.dart`
- **Deep Linking**: Check platform-specific configurations

## Next Steps

1. Customize the login UI to match your brand
2. Add user profile management
3. Implement role-based access control
4. Add logout functionality
5. Handle token refresh automatically