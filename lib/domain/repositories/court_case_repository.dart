//Not used anymore. we use supabase for this.

// import '../entities/court_case.dart';

// abstract class CourtCaseRepository {
//   /// Search for court cases based on provided criteria
//   ///
//   /// [caseNumber] - The case number to search for
//   /// [year] - The year of the case
//   /// [caseType] - The type of case
//   ///
//   /// Returns a list of court cases matching the criteria
//   Future<List<CourtCase>> searchCourtCases({
//     String? caseNumber,
//     String? year,
//     String? caseType,
//   });

//   /// Get a specific court case by its ID
//   ///
//   /// [id] - The unique identifier of the court case
//   ///
//   /// Returns the court case if found, null otherwise
//   Future<CourtCase?> getCourtCaseById(String id);

//   /// Get all court cases for a user
//   ///
//   /// Returns a list of all court cases
//   Future<List<CourtCase>> getAllCourtCases();

//   /// Follow or unfollow a court case
//   ///
//   /// [caseId] - The ID of the court case
//   /// [isFollowed] - Whether to follow or unfollow
//   ///
//   /// Returns true if successful, false otherwise
//   Future<bool> toggleFollowCase(String caseId, bool isFollowed);

//   /// Mark notifications as read for a court case
//   ///
//   /// [caseId] - The ID of the court case
//   ///
//   /// Returns true if successful, false otherwise
//   Future<bool> markNotificationsAsRead(String caseId);
// }
