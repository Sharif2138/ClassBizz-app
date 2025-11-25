import 'package:classbizz_app/models/review_model.dart';
import 'package:classbizz_app/services/review_service.dart';
import 'package:flutter/foundation.dart';


class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  bool isLoading = false;
  List<ReviewModel?> reviews = [];
  double averageRating = 0.0;

  /// Submit a review for a session
  Future<ReviewModel?> submitReview({
    required String sessionId,
    required String lecturerId,
    required int rating,
    required String description,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final review = await _reviewService.submitReview(
        sessionId,
        lecturerId,
        rating,
        description,
      );
      return review;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch reviews for a session
  Future<void> fetchReviewsBySession(String sessionId) async {
    isLoading = true;
    notifyListeners();
    try {
      reviews = await _reviewService.getReviewsBySession(sessionId);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Calculate average rating for a lecturer
  Stream<double> fetchAverageRating(String lecturerId)  {
    return _reviewService.getAverageRating(lecturerId);
  }

  Stream<List<ReviewModel>> fetchReviewsByLecturerId(String lecturerId)  {
    return _reviewService.getReviewsByLecturerId(lecturerId);
  }
}