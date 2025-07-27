import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/court_case.dart';
import '../services/device_service.dart';

class CourtCaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DeviceService _deviceService = DeviceService();

  // Get all court cases with realtime subscription
  Stream<List<CourtCase>> watchCourtCases() {
    return _supabase
        .from('court_cases')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => CourtCase.fromJson(json)).toList());
  }

  // Get court cases with search functionality and follow status
  Future<List<CourtCase>> searchCourtCases({
    String? query,
    String? status,
    String? caseType,
  }) async {
    var queryBuilder = _supabase.from('court_cases').select();

    if (query != null && query.isNotEmpty) {
      queryBuilder = queryBuilder.or(
        'case_number.ilike.%$query%,'
        'title.ilike.%$query%,'
        'court_panel.ilike.%$query%,'
        'judge_name.ilike.%$query%',
      );
    }

    if (status != null && status.isNotEmpty) {
      queryBuilder = queryBuilder.eq('status', status);
    }

    if (caseType != null && caseType.isNotEmpty) {
      queryBuilder = queryBuilder.eq('case_type', caseType);
    }

    final response = await queryBuilder.order('created_at', ascending: false);
    return response.map((json) => CourtCase.fromJson(json)).toList();
  }

  // Get single court case by ID
  Future<CourtCase?> getCourtCaseById(String id) async {
    final response = await _supabase
        .from('court_cases')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return CourtCase.fromJson(response);
  }

  // Create new court case
  Future<CourtCase> createCourtCase(CourtCase courtCase) async {
    final response = await _supabase
        .from('court_cases')
        .insert(courtCase.toJson())
        .select()
        .single();

    return CourtCase.fromJson(response);
  }

  // Update court case
  Future<CourtCase> updateCourtCase(CourtCase courtCase) async {
    final updateData = courtCase.toJson();
    updateData['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase
        .from('court_cases')
        .update(updateData)
        .eq('id', courtCase.id)
        .select()
        .single();

    return CourtCase.fromJson(response);
  }

  // Delete court case
  Future<void> deleteCourtCase(String id) async {
    await _supabase.from('court_cases').delete().eq('id', id);
  }

  // Get cases by status with count
  Future<Map<String, int>> getCaseStatusCounts() async {
    final response = await _supabase.from('court_cases').select('status');

    final counts = <String, int>{};
    for (final row in response) {
      final status = row['status'] as String;
      counts[status] = (counts[status] ?? 0) + 1;
    }

    return counts;
  }

  // Get recent court cases (last 30 days)
  Future<List<CourtCase>> getRecentCourtCases() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    final response = await _supabase
        .from('court_cases')
        .select()
        .gte('created_at', thirtyDaysAgo.toIso8601String())
        .order('created_at', ascending: false);

    return response.map((json) => CourtCase.fromJson(json)).toList();
  }

  // Subscribe to realtime changes for a specific case
  Stream<CourtCase?> watchCourtCase(String caseId) {
    return _supabase
        .from('court_cases')
        .stream(primaryKey: ['id'])
        .eq('id', caseId)
        .map((data) => data.isNotEmpty ? CourtCase.fromJson(data.first) : null);
  }

  // Get allowed status values from database constraint
  Future<List<String>> getAllowedStatuses() async {
    try {
      // Query distinct status values from existing court cases
      final response = await _supabase
          .from('court_cases')
          .select('status')
          .not('status', 'is', null);

      final statuses = response
          .map((row) => row['status'] as String)
          .toSet() // Remove duplicates
          .toList();

      statuses.sort(); // Sort alphabetically
      return statuses.isNotEmpty
          ? statuses
          : ['pending', 'active', 'closed', 'appealed'];
    } catch (e) {
      debugPrint('Error fetching statuses: $e');
      // Fallback to default values
      return ['pending', 'active', 'closed', 'appealed'];
    }
  }

  // Get allowed case types from database constraint
  Future<List<String>> getAllowedCaseTypes() async {
    try {
      // Query distinct case types from existing court cases
      final response = await _supabase
          .from('court_cases')
          .select('case_type')
          .not('case_type', 'is', null);

      final caseTypes = response
          .map((row) => row['case_type'] as String)
          .toSet() // Remove duplicates
          .toList();

      caseTypes.sort(); // Sort alphabetically
      return caseTypes.isNotEmpty
          ? caseTypes
          : ['civil', 'criminal', 'family', 'commercial', 'administrative'];
    } catch (e) {
      debugPrint('Error fetching case types: $e');
      // Fallback to default values
      return ['civil', 'criminal', 'family', 'commercial', 'administrative'];
    }
  }

  // Check if a case is followed by current device
  Future<bool> isCaseFollowedByDevice(String caseId) async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      final response = await _supabase
          .from('device_follows_cases')
          .select('id')
          .eq('device_id', deviceId)
          .eq('case_id', caseId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error checking if case is followed: $e');
      return false;
    }
  }

  // Get all cases followed by current device
  Future<List<String>> getFollowedCaseIds() async {
    try {
      final deviceId = await _deviceService.getDeviceId();
      final response = await _supabase
          .from('device_follows_cases')
          .select('case_id')
          .eq('device_id', deviceId);

      return response.map((row) => row['case_id'] as String).toList();
    } catch (e) {
      debugPrint('Error getting followed case IDs: $e');
      return [];
    }
  }

  // Get all followed court cases with full details
  Future<List<CourtCase>> getFollowedCourtCases() async {
    try {
      final deviceId = await _deviceService.getDeviceId();

      // Get followed cases with full court case details using JOIN
      final response = await _supabase
          .from('device_follows_cases')
          .select('''
            case_id,
            court_cases!inner(*)
          ''')
          .eq('device_id', deviceId);

      final cases = response.map((json) {
        final courtCaseData = json['court_cases'] as Map<String, dynamic>;
        return CourtCase.fromJson(courtCaseData);
      }).toList();

      // Sort by court case creation date (most recent first)
      cases.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return cases;
    } catch (e) {
      debugPrint('Error getting followed court cases: $e');
      return [];
    }
  }

  // Toggle follow status for a case
  Future<bool> toggleFollowCase(String caseId) async {
    try {
      final deviceId = await _deviceService.getDeviceId();

      // Check if already following
      final existing = await _supabase
          .from('device_follows_cases')
          .select('id')
          .eq('device_id', deviceId)
          .eq('case_id', caseId)
          .maybeSingle();

      if (existing != null) {
        // Unfollow - delete the record
        await _supabase
            .from('device_follows_cases')
            .delete()
            .eq('device_id', deviceId)
            .eq('case_id', caseId);

        debugPrint('✅ Unfollowed case: $caseId');
        return false; // No longer following
      } else {
        // Get case details to store in the follow record
        final caseDetails = await _supabase
            .from('court_cases')
            .select('case_number, title, case_type')
            .eq('id', caseId)
            .single();

        // Follow - insert new record with case details
        await _supabase.from('device_follows_cases').insert({
          'device_id': deviceId,
          'case_id': caseId,
          'case_number': caseDetails['case_number'],
          'case_title': caseDetails['title'],
          'case_type': caseDetails['case_type'],
        });

        debugPrint('✅ Followed case: $caseId');
        return true; // Now following
      }
    } catch (e) {
      debugPrint('❌ Error toggling follow status: $e');
      throw Exception('Failed to toggle follow status: $e');
    }
  }

  // Get court cases with follow status included
  Future<List<Map<String, dynamic>>> searchCourtCasesWithFollowStatus({
    String? query,
    String? status,
    String? caseType,
  }) async {
    try {
      final deviceId = await _deviceService.getDeviceId();

      // Get cases with follow information using a LEFT JOIN
      var queryBuilder = _supabase.from('court_cases').select('''
            *,
            device_follows_cases!left(device_id)
          ''');

      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder.or(
          'case_number.ilike.%$query%,'
          'title.ilike.%$query%,'
          'court_panel.ilike.%$query%,'
          'judge_name.ilike.%$query%',
        );
      }

      if (status != null && status.isNotEmpty) {
        queryBuilder = queryBuilder.eq('status', status);
      }

      if (caseType != null && caseType.isNotEmpty) {
        queryBuilder = queryBuilder.eq('case_type', caseType);
      }

      final response = await queryBuilder.order('created_at', ascending: false);

      // Process results to include follow status
      return response.map((json) {
        final followData = json['device_follows_cases'] as List?;
        final isFollowed =
            followData?.any((follow) => follow['device_id'] == deviceId) ??
            false;

        return {...json, 'is_followed_by_device': isFollowed};
      }).toList();
    } catch (e) {
      debugPrint('❌ Error searching cases with follow status: $e');
      throw Exception('Failed to search cases: $e');
    }
  }
}
