import 'package:url_launcher/url_launcher.dart';

class SimpleAsgardeoAuth {
  static const String baseUrl = 'https://api.asgardeo.io/t/altitude';
  static const String clientId = '66ZUtg2HAyLbfmnZJROFhDVE3Woa';
  static const String redirectUri = 'https://bledsoetech.com/';
  static const String scope = 'openid profile';
  
  Future<bool> signIn() async {
    final authUrl = Uri.parse('$baseUrl/oauth2/authorize').replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scope,
      },
    );
    
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }
}