import 'package:classbizz_app/models/session_model.dart';
import 'package:classbizz_app/services/session_service.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  bool isLoading = false;
  SessionModel? session;

  Future<SessionModel?> createSession(
    String lecturerId,
    String name,
    String? topic,
    int? durationMinutes,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.createSession(
        lecturerId,
        name,
        topic,
        durationMinutes,
      );
      return session;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<SessionModel?> joinSession(String code, String studentId) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.joinSession(code, studentId);
      return session;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<SessionModel?> leaveSession(String code, String studentId) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.leaveSession(code, studentId);
      return session;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<SessionModel?> endSession(String code) async {
    isLoading = true;
    notifyListeners();
    try {
      session = await _sessionService.endSession(code);
      return session;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
