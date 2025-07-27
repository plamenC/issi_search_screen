class CourtCase {
  final String id;
  final String caseNumber;
  final String title;
  final String? description;
  final String caseType;
  final String status;
  final String courtPanel;
  final String? judgeName;
  final DateTime filingDate;
  final DateTime? hearingDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  // UI-specific fields
  final bool hasUnreadNotifications;
  final bool isFollowed;

  CourtCase({
    required this.id,
    required this.caseNumber,
    required this.title,
    this.description,
    required this.caseType,
    required this.status,
    required this.courtPanel,
    this.judgeName,
    required this.filingDate,
    this.hearingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.hasUnreadNotifications,
    required this.isFollowed,
  });

  factory CourtCase.fromJson(Map<String, dynamic> json) {
    return CourtCase(
      id: json['id'],
      caseNumber: json['case_number'],
      title: json['title'],
      description: json['description'],
      caseType: json['case_type'],
      status: json['status'],
      courtPanel: json['court_panel'],
      judgeName: json['judge_name'],
      filingDate: DateTime.parse(json['filing_date']),
      hearingDate: json['hearing_date'] != null
          ? DateTime.parse(json['hearing_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      hasUnreadNotifications: json['has_unread_notifications'] ?? false,
      isFollowed: json['is_followed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_number': caseNumber,
      'title': title,
      'description': description,
      'case_type': caseType,
      'status': status,
      'court_panel': courtPanel,
      'judge_name': judgeName,
      'filing_date': filingDate.toIso8601String(),
      'hearing_date': hearingDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'has_unread_notifications': hasUnreadNotifications,
      'is_followed': isFollowed,
    };
  }

  CourtCase copyWith({
    String? id,
    String? caseNumber,
    String? title,
    String? description,
    String? caseType,
    String? status,
    String? courtPanel,
    String? judgeName,
    DateTime? filingDate,
    DateTime? hearingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasUnreadNotifications,
    bool? isFollowed,
  }) {
    return CourtCase(
      id: id ?? this.id,
      caseNumber: caseNumber ?? this.caseNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      caseType: caseType ?? this.caseType,
      status: status ?? this.status,
      courtPanel: courtPanel ?? this.courtPanel,
      judgeName: judgeName ?? this.judgeName,
      filingDate: filingDate ?? this.filingDate,
      hearingDate: hearingDate ?? this.hearingDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasUnreadNotifications:
          hasUnreadNotifications ?? this.hasUnreadNotifications,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
