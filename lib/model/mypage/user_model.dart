class UserInfoResponse {
  final String? profileImage;
  final String nickname;
  final DateTime createdAt;
  final int totalStudyDays;
  final List<int> monthlyStudyDate;
  final bool isStudyToday;

  UserInfoResponse({
    required this.profileImage,
    required this.nickname,
    required this.createdAt,
    required this.totalStudyDays,
    required this.monthlyStudyDate,
    required this.isStudyToday,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      profileImage: json['profile_image'],
      nickname: json['nickname'],
      createdAt: DateTime.parse(json['created_at']),
      totalStudyDays: json['total_study_days'],
      monthlyStudyDate: List<int>.from(json['monthly_study_date']),
      isStudyToday: json['is_study_today'],
    );
  }
}
