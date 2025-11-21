import 'package:cloud_firestore/cloud_firestore.dart';
class AttendeeModel {
  String uid;
  String name;
  int points;
  String status;
  DateTime joinedAt;

  AttendeeModel({
    required this.uid,
    required this.name,
    this.points = 0,
    this.status = 'inLesson',
    required this.joinedAt,
  });

  factory AttendeeModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return AttendeeModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      points: map['points'] as int? ?? 0,
      status: map['status'] as String? ?? 'inLesson',
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'points': points,
      'status': status,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}