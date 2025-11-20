import 'dart:math';
import '../models/session_model.dart';
import '../models/attendee_model.dart';
import 'firestore_service.dart';

class SessionService {
  final FirestoreService _firestoreService = FirestoreService();

  /// Generate a random 6-character session code
  String generateCode() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Create a new session
  Future<SessionModel> createSession({
    required String lecturerId,
    required String name,
    String? topic,
    int? durationMinutes,
  }) async {
    final code = generateCode();
    final session = SessionModel(
      sessionId: code, // sessionId is also the code
      lecturerId: lecturerId,
      name: name,
      createdAt: DateTime.now(),
      topic: topic,
      durationMinutes: durationMinutes,
      status: 'active',
    );

    await _firestoreService.saveSession(session);
    return session;
  }

  /// Student joins a session
  Future<void> joinSession({
    required String sessionId,
    required String uid,
    required String name,
  }) async {
    final session = await _firestoreService.getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    await _firestoreService.addOrUpdateAttendee(sessionId, uid, name);
  }

  /// Student leaves a session
  Future<void> leaveSession({
    required String sessionId,
    required String uid,
  }) async {
    final session = await _firestoreService.getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    await _firestoreService.removeAttendee(sessionId, uid);
  }

  /// End the session (lecturer)
  Future<void> endSession(String sessionId) async {
    final session = await _firestoreService.getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    await _firestoreService.updateSession(sessionId, {'status': 'ended'});
  }

  /// Get a single session
  Future<SessionModel?> getSession(String sessionId) async {
    return await _firestoreService.getSession(sessionId);
  }

  /// Real-time session stream
  Stream<SessionModel?> sessionStream(String sessionId) {
    return _firestoreService.sessionStream(sessionId);
  }

  /// Real-time attendees stream as List
  Stream<List<AttendeeModel>> attendeeStream(String sessionId) {
    return _firestoreService.attendeesStream(sessionId);
  }

  /// Award points to a student
  Future<void> awardPoints({
    required String sessionId,
    required String uid,
    required int points,
  }) async {
    await _firestoreService.awardPoints(sessionId, uid, points);
  }
}
