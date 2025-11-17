import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// A simple model representing points earned by a user.
///
/// Stored in Firestore as a map with keys:
/// - `userId` (String)
/// - `points` (int)
/// - `reason` (String, optional)
/// - `source` (String, optional)
/// - `createdAt` (Timestamp)
class PointsModel {
  final String? id; // Firestore document id (optional)
  final String userId;
  final int points;
  final String? reason;
  final String? source;
  final DateTime createdAt;

  PointsModel({
    this.id,
    required this.userId,
    required this.points,
    this.reason,
    this.source,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PointsModel copyWith({
    String? id,
    String? userId,
    int? points,
    String? reason,
    String? source,
    DateTime? createdAt,
  }) {
    return PointsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      reason: reason ?? this.reason,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to a Firestore-friendly map. `createdAt` is converted to [Timestamp].
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'points': points,
      'reason': reason,
      'source': source,
      'createdAt': Timestamp.fromDate(createdAt),
    }..removeWhere((key, value) => value == null);
  }

  /// Create model from a Firestore document snapshot.
  factory PointsModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return PointsModel.fromMap(data).copyWith(id: doc.id);
  }

  /// Create model from a plain map (e.g., from JSON or Firestore map).
  factory PointsModel.fromMap(Map<String, dynamic> map) {
    DateTime parseTimestamp(dynamic ts) {
      if (ts == null) return DateTime.now();
      if (ts is Timestamp) return ts.toDate();
      if (ts is DateTime) return ts;
      if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
      if (ts is String) return DateTime.tryParse(ts) ?? DateTime.now();
      return DateTime.now();
    }

    return PointsModel(
      userId: map['userId'] as String? ?? '',
      points: (map['points'] is int)
          ? map['points'] as int
          : (map['points'] is num ? (map['points'] as num).toInt() : 0),
      reason: map['reason'] as String?,
      source: map['source'] as String?,
      createdAt: parseTimestamp(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PointsModel.fromJson(String source) =>
      PointsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PointsModel(id: $id, userId: $userId, points: $points, reason: $reason, source: $source, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PointsModel &&
        other.id == id &&
        other.userId == userId &&
        other.points == points &&
        other.reason == reason &&
        other.source == source &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, points, reason, source, createdAt);
  }
}
