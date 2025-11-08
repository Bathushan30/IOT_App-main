import 'dart:async';

class AuthService {
  Future<Map<String, dynamic>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Demo login logic
    if (email == "demo@bledsoeTech.com" && password == "demo123") {
      return {
        'uid': 'demo-user-id',
        'email': email,
        'name': 'Demo User',
      };
    }
    
    throw 'Invalid email or password';
  }

  Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email,
    String password, {
    String? displayName,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'uid': 'new-user-id',
      'email': email,
      'name': displayName ?? 'New User',
    };
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (!email.contains('@')) {
      throw 'Invalid email address';
    }
  }
}