import 'firestore_service.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirestoreService _firestoreService = FirestoreService();

  /// Submit a review for a session
  Future<ReviewModel?> submitReview(
    String sessionId,
    String lecturerId,
    int rating,
    String description,
  ) async {
     return await _firestoreService.createAnonymousReview(
      sessionId: sessionId,
      lecturerId: lecturerId,
      rating: rating,
      description: description,
    );
  }
  
  Future<List<ReviewModel?>> getReviewsBySession(String sessionId) async {
    return await _firestoreService.getReviewsBySession(sessionId);
  }

  Stream<List<ReviewModel>> getReviewsByLecturerId(String lecturerId)  {
    return  _firestoreService.getReviewsByLecturerId(lecturerId);
  }

  Stream<double> getAverageRating(String lecturerId) {
    return _firestoreService.getAverageRating(lecturerId);
  }

}