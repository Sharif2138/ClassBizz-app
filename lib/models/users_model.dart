import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool isStudent;
  final int points;
  final String profilepic;

  UserModel({required this.uid, required this.name, required this.email, required this.isStudent,  this.points = 0, required this.profilepic});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data()! as Map<String, dynamic>;
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isStudent: map['isStudent'] as bool,
      points: map['points'] as int? ?? 0,
      profilepic: map['profilepic'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'isStudent': isStudent,
      'points': points,
      'profilepic': profilepic,
    };
  }
}
 