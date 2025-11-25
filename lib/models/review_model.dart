import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String sessionId;
  final String lecturerId;
  final int rating;
  final String description;
  final DateTime createdAt;

  ReviewModel({
    required this.sessionId,
    required this.lecturerId,
    required this.rating,
    required this.description,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data()! as Map<String, dynamic>;
    return ReviewModel(
      sessionId: map['sessionId'] as String,
      lecturerId: map['lecturerId'] as String,
      rating: map['rating'] as int,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'lecturerId': lecturerId,
      'rating': rating,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
