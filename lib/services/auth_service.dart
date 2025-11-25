// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/users_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> createUserWithEmailAndPassword(
    String name,
    String email,
    String password, {
    int? points = 0,
    bool? isStudent,
  }) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // Step 2: Check that user was created
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'User could not be created.',
        );
      }

      // Step 3: Update display name and reload
      await user.updateDisplayName(name);
      await user.reload();

      // Step 4: Send verification email
      await user.sendEmailVerification();

      // Step 5: Validate role selection (service layer should not use BuildContext)
      if (isStudent == null) {
        throw FirebaseAuthException(
          code: 'role-not-selected',
          message: 'Please select a role.',
        );
      }

      // Step 6: Save user data to Firestore
      UserModel userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        points: points ?? 0,
        isStudent: isStudent,
        profilepic: '',
      );
      await FirestoreService().saveUser(userModel);

      // Step 7: Return the user
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'That email is already registered.';
        case 'invalid-email':
          throw 'The email address is invalid.';
        case 'weak-password':
          throw 'The password is too weak.';
        default:
          throw 'Authentication failed: ${e.message}';
      }
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        );
      }
      await user.reload();
      user = _auth.currentUser; // refresh reference

      if (user != null) {
        if (user.emailVerified) {
          return user;
        } else {
          await user.sendEmailVerification();
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'Email not verified. Verification email sent.',
          );
        }
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found after sign-in.',
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw 'Incorrect password.';
        case 'user-not-found':
          throw 'No user found with that email.';
        case 'email-not-verified':
          throw 'Please verify your email before logging in.';
        default:
          throw 'Authentication error: ${e.message}';
      }
    } catch (e) {
      throw 'Unexpected error. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> signInWithGoogle() async {
    
    throw UnimplementedError('Google Sign-In not implemented yet.');
  }

}
