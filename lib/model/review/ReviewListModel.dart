class ReviewListModel {
  final String reviewNoteId;
  final String examId;
  final String name;
  final bool isPassed;
  final String certificate;
  final int readCount;
  final double passRate;

  ReviewListModel({
    required this.reviewNoteId,
    required this.examId,
    required this.name,
    required this.isPassed,
    required this.certificate,
    required this.readCount,
    required this.passRate,
  });

  factory ReviewListModel.fromJson(Map<String, dynamic> json) {
    print('🔍 [ReviewListModel] fromJson 시작 - 전체 JSON: $json');

    final certificate = json['certificate']?.toString() ?? '';
    print('🔍 [ReviewListModel] certificate 파싱: $certificate');

    final result = ReviewListModel(
      reviewNoteId: json['review_note_id'].toString(),
      examId: json['exam_id'].toString(),
      name: json['name'],
      isPassed: json['is_passed'],
      certificate: certificate,
      readCount: json['read_count'],
      passRate: (json['pass_rate'] as num).toDouble(),
    );

    print('🔍 [ReviewListModel] 파싱 완료 - certificate: ${result.certificate}');
    return result;
  }
}
