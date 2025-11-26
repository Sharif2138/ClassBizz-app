import 'package:classbizz_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? get currentUser => _service.currentUser;

  User? user;
  bool isLoading = false;
  bool isLoadingGoogle = false;
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
      await _service.createUserWithEmailAndPassword(
        name,
        email,
        password,
        isStudent: isStudent,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    isLoadingGoogle = true;
    notifyListeners();
    try {
      errorMessage = '';
      await _service.signInWithGoogle();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingGoogle = false;
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
      await _service.signInWithEmailAndPassword(email, password);
    } catch (e) {
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
