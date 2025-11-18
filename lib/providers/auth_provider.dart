import 'package:classbizz_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? user;
  bool isLoading = false;
  String? errorMessage;

  AuthProvider() {
    _service.authStateChanges.listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    bool isStudent,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // debug
      print(
        'AuthProvider.signUp: starting for email=$email isStudent=$isStudent',
      );
      await _service.createUserWithEmailAndPassword(
        name,
        email,
        password,
        isStudent: isStudent,
      );
      print(
        'AuthProvider.signUp: createUserWithEmailAndPassword completed for email=$email',
      );
    } catch (e) {
      print('AuthProvider.signUp: caught error: $e');
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      print('AuthProvider.signIn: starting for email=$email');
      await _service.signInWithEmailAndPassword(email, password);
      print(
        'AuthProvider.signIn: signInWithEmailAndPassword completed for email=$email',
      );
    } catch (e) {
      print('AuthProvider.signIn: caught error: $e');
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    final user = _service.currentUser;
    if (user != null) {
      await user.reload();
      this.user = _service.currentUser;
      notifyListeners();
    }
  }
}
