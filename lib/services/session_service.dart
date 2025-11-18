import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';
import 'firestore_service.dart';
import 'dart:math';

class SessionService {
  final FirestoreService _firestoreService = FirestoreService();

  String generateCode() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();

    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<void> createSession(
    String lecturerId,
    String name,
    String? topic,
    int? durationMinutes,
  ) async {
    String code = generateCode();

    final session = SessionModel(
      sessionId: code, 
      lecturerId: lecturerId,
      name: name,
      code: code,
      topic: topic,
      durationMinutes: durationMinutes,
      status: 'active',
      attendees: [],
      createdAt: DateTime.now(),
    );

    await _firestoreService.saveSession(session);
  }

  Future<void> joinSession(String code, String studentId) async {
    final session = await _firestoreService.getSession(code);

    if (session == null) {
      throw Exception('Session not found');
    }

    if (!session.attendees.contains(studentId)) {
      await _firestoreService.updateSession(code, {
        'attendees': FieldValue.arrayUnion([studentId]),
      });
    }
  }

  Future<void> endSession(String code) async {
    final session = await _firestoreService.getSession(code);

    if (session == null) {
      throw Exception('Session not found');
    }

    await _firestoreService.updateSession(code, {'status': 'ended'});
  }

  Future<void> leaveSession(String code, String studentId) async {
    final session = await _firestoreService.getSession(code);

    if (session == null) {
      throw Exception('Session not found');
    }

    if (session.attendees.contains(studentId)) {
      await _firestoreService.updateSession(code, {
        'attendees': FieldValue.arrayRemove([studentId]),
      });
    }
  }
}
