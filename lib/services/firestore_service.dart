import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';
import '../models/session_model.dart';
import '../models/attendee_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -------- USER METHODS --------
  Future<UserModel> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }


  // -------- SESSION METHODS --------
  Future<SessionModel> saveSession(SessionModel session) async {
    await _db
        .collection('sessions')
        .doc(session.sessionId)
        .set(session.toMap());
    return session;
  }

  Future<void> updateSession(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('sessions').doc(sessionId).update(data);
  }

  Future<SessionModel?> getSession(String sessionId) async {
    final doc = await _db.collection('sessions').doc(sessionId).get();
    if (doc.exists) return SessionModel.fromFirestore(doc);
    return null;
  }

  Stream<SessionModel?> sessionStream(String sessionId) {
    return _db
        .collection('sessions')
        .doc(sessionId)
        .snapshots()
        .map((doc) => doc.exists ? SessionModel.fromFirestore(doc) : null);
  }

  // -------- ATTENDEE METHODS (subcollection) --------

  /// Add or update an attendee in a session
  Future<void> addOrUpdateAttendee(
    String sessionId,
    String uid,
    String name,
  ) async {
    final attendee = AttendeeModel(
      uid: uid,
      name: name,
      points: 0,
      status: 'inLesson',
      joinedAt: DateTime.now(),
    );

    await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .set(attendee.toMap(), SetOptions(merge: true));
  }

  /// Mark attendee as left
  Future<void> removeAttendee(String sessionId, String uid) async {
    await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .update({'status': 'left'});
  }

  /// Award points to an attendee
  Future<void> awardPoints(String sessionId, String uid, int points) async {
    await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .update({'points': FieldValue.increment(points)});
  }

  /// Stream all attendees live
  Stream<List<AttendeeModel>> attendeesStream(String sessionId) {
    return _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        // .orderBy('joinedAt', descending: true)
        .where('status', isEqualTo: 'inLesson')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AttendeeModel.fromFirestore(doc))
              .toList(),
        );
  }
}
