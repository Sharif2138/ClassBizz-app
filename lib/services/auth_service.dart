import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    bool? isStudent,
  }) async {
    try {
      print('AuthService.createUserWithEmailAndPassword: creating $email');
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
        isStudent: isStudent,
        profilepic: '',
      );
      await FirestoreService().saveUser(userModel);

      print(
        'AuthService.createUserWithEmailAndPassword: user saved to Firestore uid=${user.uid}',
      );

      // Step 7: Return the user
      return user;
    } on FirebaseAuthException catch (e) {
      print(
        'AuthService.createUserWithEmailAndPassword: FirebaseAuthException ${e.code} ${e.message}',
      );
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
      print('AuthService.createUserWithEmailAndPassword: unexpected error: $e');
      throw 'Unexpected error: $e';
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      print('AuthService.signInWithEmailAndPassword: signing in $email');
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
          print(
            'AuthService.signInWithEmailAndPassword: email verified for ${user.uid}',
          );
          return user;
        } else {
          await user.sendEmailVerification();
          print(
            'AuthService.signInWithEmailAndPassword: email not verified, sent verification to $email',
          );
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
      print(
        'AuthService.signInWithEmailAndPassword: FirebaseAuthException ${e.code} ${e.message}',
      );
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

  Future<User?> signInWithGoogle({required bool isStudent}) async {
    try {
      print('AuthService.signInWithGoogle: starting');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print('AuthService.signInWithGoogle: user canceled');
        return null; // User canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if user exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          print('AuthService.signInWithGoogle: creating new user in Firestore');
          // Create user in Firestore
          UserModel userModel = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email ?? '',
            isStudent: isStudent,
            profilepic: user.photoURL ?? '',
          );
          await FirestoreService().saveUser(userModel);
        } else {
          print(
            'AuthService.signInWithGoogle: user already exists in Firestore',
          );
        }
      }

      return user;
    } catch (e) {
      print('AuthService.signInWithGoogle error: $e');
      throw 'Google Sign In failed: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getUserdata(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      return UserModel.fromFirestore(documentSnapshot);
    }
    return null;
  }
}
