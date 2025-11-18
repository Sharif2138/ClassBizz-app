import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String sessionId;
  String lecturerId;
  String name;
  String code;
  List<String> attendees;
  DateTime createdAt;

  SessionModel({required this.sessionId, required this.lecturerId, required this.name, required this.code, required this.attendees, required this.createdAt});

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data()! as Map<String, dynamic>;
    return SessionModel(
      sessionId: map['sessionId'] as String,
      lecturerId: map['lecturerId'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      attendees: List<String>.from(map['attendees'] as List<dynamic>),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'lecturerId': lecturerId,
      'name': name,
      'code': code,
      'attendees': attendees,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  
}