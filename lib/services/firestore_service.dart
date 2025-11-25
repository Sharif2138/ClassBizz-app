import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_model.dart';
import '../models/session_model.dart';
import '../models/attendee_model.dart';
import '../models/review_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -------- USER METHODS --------
  Future<UserModel> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }
  
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
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

  Future<List<SessionModel>> getSessionsByLecturerId(String lecturerId) async {
    final querySnapshot = await _db
        .collection('sessions')
        .where('lecturerId', isEqualTo: lecturerId)
        .get();

    return querySnapshot.docs
        .map((doc) => SessionModel.fromFirestore(doc))
        .toList();
  }

  Future<List<SessionModel>> getSessionsByAttendeeId(String attendeeId) async {
    final querySnapshot = await _db
        .collection('sessions')
        .where('attendees.attendeeId', isEqualTo: attendeeId)
        .get();
    return querySnapshot.docs
        .map((doc) => SessionModel.fromFirestore(doc))
        .toList();
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
    int points,
  ) async {
    final attendee = AttendeeModel(
      uid: uid,
      name: name,
      points: points,
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

  Future<AttendeeModel?> getAttendee(
      String sessionId, String uid) async {
    final doc = await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .get();

    if (doc.exists) {
      return AttendeeModel.fromFirestore(doc);
    }
    return null;
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

  Stream<AttendeeModel?> attendeeStreamByUid(String sessionId, String uid) {
    return _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AttendeeModel.fromFirestore(doc) : null);
  }

  //------Review Methods --------//

  Future<ReviewModel?> createAnonymousReview({
    required String sessionId,
    required String lecturerId,
    required int rating,
    required String description,
  }) async {
    
    await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('reviews')
        .add({
          'sessionId': sessionId,
          'lecturerId': lecturerId,
          'rating': rating,
          'description': description,
          'createdAt': Timestamp.now(),
        });

    return ReviewModel(
      sessionId: sessionId,
      lecturerId: lecturerId,
      rating: rating,
      description: description,
      createdAt: DateTime.now(),
    );
  }

  Future<List<ReviewModel?>> getReviewsBySession(String sessionId) async {
    final querySnapshot = await _db
        .collection('sessions')
        .doc(sessionId)
        .collection('reviews')
        .get();

    return querySnapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .toList();
  }

  Future<List<ReviewModel?>> getReviewsByLecturer(String lecturerId) async {
    final querySnapshot = await _db
        .collectionGroup('reviews')
        .where('lecturerId', isEqualTo: lecturerId)
        .get();

    return querySnapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .toList();
  }

  Future<double> getAverageRating(String lecturerId) async {
    final reviews = await getReviewsByLecturer(lecturerId);

    if (reviews.isEmpty) return 0.0;

    final total = reviews.fold<int>(0, (sum, r) => sum + r!.rating);
    return total / reviews.length;
  }
}
