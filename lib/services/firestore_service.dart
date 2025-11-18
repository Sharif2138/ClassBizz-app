import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';
import '../models/session_model.dart';

class FirestoreService {
   final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<SessionModel> saveSession(SessionModel session) async {
    await _db.collection('sessions').doc(session.sessionId).set(session.toMap());
    return session;
  }
}