// Simple local authentication service without Firebase
class AuthService {
  // Simple in-memory user storage (for demo purposes)
  // In production, you might want to use local storage or a backend API
  String? _currentUserEmail;
  String? _currentUserName;

  // Get current user email
  String? get currentUserEmail => _currentUserEmail;

  // Get current user name
  String? get currentUserName => _currentUserName;

  // Check if user is logged in
  bool get isLoggedIn => _currentUserEmail != null;

  // Sign in with email and password
  Future<Map<String, String?>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Simple validation
      if (email.trim().isEmpty || password.isEmpty) {
        throw 'Please enter both email and password.';
      }

      if (!email.contains('@')) {
        throw 'Please enter a valid email address.';
      }

      if (password.length < 6) {
        throw 'Password must be at least 6 characters.';
      }

      // For demo purposes, accept any valid email/password combination
      // In production, you would validate against a backend API or local database
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      _currentUserEmail = email.trim();
      _currentUserName = email.split('@')[0]; // Use email prefix as name

      return {
        'email': _currentUserEmail,
        'name': _currentUserName,
      };
    } catch (e) {
      throw e.toString();
    }
  }

  // Register with email and password
  Future<Map<String, String?>> registerWithEmailAndPassword(
    String email,
    String password,
    {String? displayName}
  ) async {
    try {
      // Simple validation
      if (email.trim().isEmpty || password.isEmpty) {
        throw 'Please enter both email and password.';
      }

      if (!email.contains('@')) {
        throw 'Please enter a valid email address.';
      }

      if (password.length < 6) {
        throw 'Password must be at least 6 characters.';
      }

      // For demo purposes, accept any valid email/password combination
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      _currentUserEmail = email.trim();
      _currentUserName = displayName ?? email.split('@')[0];

      return {
        'email': _currentUserEmail,
        'name': _currentUserName,
      };
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
    _currentUserEmail = null;
    _currentUserName = null;
  }

  // Send password reset email (mock - no actual email sent)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (email.trim().isEmpty) {
        throw 'Please enter your email address.';
      }

      if (!email.contains('@')) {
        throw 'Please enter a valid email address.';
      }

      // Mock implementation - in production, call your backend API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In a real app, you would send an email here
      // For now, just simulate success
    } catch (e) {
      throw e.toString();
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      if (displayName != null && displayName.isNotEmpty) {
        _currentUserName = displayName;
      }
      // In production, you would save this to your backend or local storage
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }
}