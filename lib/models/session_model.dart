import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String sessionId; // also used as session code
  String lecturerId;
  String name;
  DateTime createdAt;
  String? topic;
  int? durationMinutes;
  String status;

  SessionModel({
    required this.sessionId,
    required this.lecturerId,
    required this.name,
    required this.createdAt,
    this.topic,
    this.durationMinutes,
    this.status = 'active',
  });

  /// Convert Firestore document to SessionModel
  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data()! as Map<String, dynamic>;
    return SessionModel(
      sessionId: map['sessionId'] as String,
      lecturerId: map['lecturerId'] as String,
      name: map['name'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      topic: map['topic'] as String?,
      durationMinutes: map['durationMinutes'] as int?,
      status: map['status'] as String? ?? 'active',
    );
  }

  /// Convert SessionModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'lecturerId': lecturerId,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'topic': topic,
      'durationMinutes': durationMinutes,
      'status': status,
    };
  }
}
