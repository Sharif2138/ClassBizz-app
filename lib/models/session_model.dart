import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String sessionId; 
  String lecturerId;
  String name;
  String code;
  DateTime createdAt;
  String? topic;
  int? durationMinutes;
  String status;
  List<String> attendees;

  
  SessionModel({
    required this.sessionId,
    required this.lecturerId,
    required this.name,
    required this.code,
    required this.createdAt,
    this.topic,
    this.durationMinutes,
    this.status = 'active',
    List<String>? attendees,
  }) : attendees = attendees ?? []; 

  
  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data()! as Map<String, dynamic>;

    return SessionModel(
      sessionId: map['sessionId'] as String,
      lecturerId: map['lecturerId'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      topic: map['topic'] as String?, 
      durationMinutes: map['durationMinutes'] as int?, 
      status: map['status'] as String? ?? 'active', 
      attendees: List<String>.from(map['attendees'] ?? []), 
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'lecturerId': lecturerId,
      'name': name,
      'code': code,
      'createdAt': Timestamp.fromDate(createdAt),
      'topic': topic,
      'durationMinutes': durationMinutes,
      'status': status,
      'attendees': attendees,
    };
  }
}