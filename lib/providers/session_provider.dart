import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/attendee_model.dart';
import '../services/session_service.dart';

class SessionProvider extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  bool isLoading = false;
  SessionModel? session;

  /// Create a new session
  Future<SessionModel?> createSession({
    required String lecturerId,
    required String name,
    String? topic,
    int? durationMinutes,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.createSession(
        lecturerId: lecturerId,
        name: name,
        topic: topic,
        durationMinutes: durationMinutes,
      );
      return session;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Student joins a session
  Future<void> joinSession({
    required String sessionId,
    required String uid,
    required String name,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await _sessionService.joinSession(
        sessionId: sessionId,
        uid: uid,
        name: name,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSession(String sessionId) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.getSession(sessionId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Student leaves a session
  Future<void> leaveSession({
    required String sessionId,
    required String uid,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await _sessionService.leaveSession(sessionId: sessionId, uid: uid);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// End the session (lecturer)
  Future<void> endSession(String sessionId) async {
    isLoading = true;
    notifyListeners();
    try {
      await _sessionService.endSession(sessionId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Real-time session info
  Stream<SessionModel?> sessionStream(String sessionId) {
    return _sessionService.sessionStream(sessionId);
  }

  /// Real-time attendees
  Stream<List<AttendeeModel>> attendeeStream(String sessionId) {
    return _sessionService.attendeeStream(sessionId);
  }

  /// Award points to a student
  Future<void> awardPoints({
    required String sessionId,
    required String uid,
    required int points,
  }) async {
    await _sessionService.awardPoints(
      sessionId: sessionId,
      uid: uid,
      points: points,
    );
    notifyListeners();
  }
}
