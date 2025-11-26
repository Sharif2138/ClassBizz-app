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

  Stream<List<SessionModel>> getSessionsByLecturerId(String lecturerId) {
    return _db
        .collection('sessions')
        .where('lecturerId', isEqualTo: lecturerId)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => SessionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Future<List<SessionModel>> getSessionsByAttendeeId(String attendeeId) async {
  //   // Fetch all sessions
  //   final querySnapshot = await _db.collection('sessions').get();

  //   final List<SessionModel> sessions = [];

  //   for (var doc in querySnapshot.docs) {
  //     // Check if this attendee exists in the subcollection
  //     final attendeeDoc = await _db
  //         .collection('sessions')
  //         .doc(doc.id)
  //         .collection('attendees')
  //         .doc(attendeeId)
  //         .get();

  //     if (attendeeDoc.exists) {
  //       // Convert session and force status to "ended" so it shows as completed
  //       final session = SessionModel.fromFirestore(doc);
  //       session.status = 'ended';
  //       sessions.add(session);
  //     }
  //   }

  //   return sessions;
  // }

Stream<List<SessionModel>> getSessionsByAttendeeIdStream(String attendeeId) {
  // 1. Query the 'attendees' Collection Group to find all join records for this student.
  // We use .orderBy('joinedAt', descending: true) to make this a composite query
  // and ensure results are consistently ordered.
  return FirebaseFirestore.instance
      .collectionGroup('attendees')
      .where('uid', isEqualTo: attendeeId)
      .orderBy('joinedAt', descending: true) // Requires composite index
      .snapshots() // This sets up the real-time stream
      .asyncMap((attendeeSnapshot) async {
        if (attendeeSnapshot.docs.isEmpty) {
          return [];
        }

        // 2. Extract the parent session IDs from the paths.
        final sessionIds = attendeeSnapshot.docs.map((doc) {
          // doc.reference.parent.parent is the reference to the Session document.
          return doc.reference.parent.parent!.id; 
        }).toList();

        // 3. Fetch the actual SessionModel documents using the extracted IDs (batch fetch).
        final sessionDocs = await FirebaseFirestore.instance
            .collection('sessions')
            .where(FieldPath.documentId, whereIn: sessionIds)
            .get();
        
        // 4. Convert the documents to SessionModel and return.
        return sessionDocs.docs
            .map((doc) => SessionModel.fromFirestore(doc))
            .toList();
      });
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
    final attendeeRef = _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid);

    final doc = await attendeeRef.get();

    if (doc.exists) {
      // Rejoin: keep points, just update status and joinedAt
      await attendeeRef.update({
        'status': 'inLesson',
        'joinedAt': DateTime.now(),
      });
    } else {
      // First join: initialize session points to 0
      await attendeeRef.set({
        'uid': uid,
        'name': name,
        'points': 0,
        'status': 'inLesson',
        'joinedAt': DateTime.now(),
      });
    }
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
    final attendeeRef = _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid);

    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      // Increment session-specific points
      transaction.update(attendeeRef, {'points': FieldValue.increment(points)});

      // Increment total points for the user
      transaction.update(userRef, {'points': FieldValue.increment(points)});
    });
  }

  Future<AttendeeModel?> getAttendee(String sessionId, String uid) async {
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
    await _db.collection('sessions').doc(sessionId).collection('reviews').add({
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

  Stream<List<ReviewModel>> getReviewsByLecturerId(String lecturerId) {
    return FirebaseFirestore.instance
        .collectionGroup('reviews')
        .where('lecturerId', isEqualTo: lecturerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<double> getAverageRating(String lecturerId) {
    return getReviewsByLecturerId(lecturerId).map((reviews) {
      if (reviews.isEmpty) return 0.0;

      final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
      return total / reviews.length;
    });
  }

  //------student methods -----//

  Stream<int> getStudentRanking(String uid) {
    // Changed return type to int
    return _db
        .collection('users')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) {
          final users = snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();
          final index = users.indexWhere((user) => user.uid == uid);

          // If user not found, return 0 (or throw error, depending on desired behavior)
          if (index == -1) return 0;

          // Return the rank (index + 1)
          return index + 1;
        });
  }
  Stream<int> getTotalPoints(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        final user = UserModel.fromFirestore(doc);
        return user.points;
      }
      return 0;
    });
  }

  Stream<int> getTotalAttendedSessions(String uid) {
    return _db
        .collectionGroup('attendees')
        .where('uid', isEqualTo: uid)
        .orderBy('joinedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream <int> getTotalPointsInSession(String sessionId, String uid) {
    return _db
        .collection('sessions')
        .doc(sessionId)
        .collection('attendees')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            final attendee = AttendeeModel.fromFirestore(doc);
            return attendee.points; 
          }
          return 0;
        });
  }
}
