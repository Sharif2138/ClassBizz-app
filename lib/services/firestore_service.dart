import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';
import '../models/session_model.dart';

class FirestoreService {
   final FirebaseFirestore _db = FirebaseFirestore.instance;

       //---------User Methods---------//
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


        //---------Session Methods---------//
  Future<SessionModel> saveSession(SessionModel session) async {
    await _db.collection('sessions').doc(session.sessionId).set(session.toMap());
    return session;
  }

  Future<void> updateSession(String sessionId, Map<String, dynamic> data) async {
    await _db.collection('sessions').doc(sessionId).update(data);
  }

  Future<SessionModel?> getSession(String code) async {
    DocumentSnapshot doc = await _db.collection('sessions').doc(code).get();
    if (doc.exists) {
      return SessionModel.fromFirestore(doc);
    }
    return null;
  }

  
}