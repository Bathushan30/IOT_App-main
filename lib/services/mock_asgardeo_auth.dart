class MockAsgardeoAuth {
  Future<bool> signIn() async {
    // Mock authentication - in real app this would open browser
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}