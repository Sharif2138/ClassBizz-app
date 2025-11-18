import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';
import 'firestore_service.dart';

class SessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<SessionModel> createSession(SessionModel session) async {
    await _db.collection('sessions').doc(session.sessionId).set(session.toMap());
    return session;
  }
}