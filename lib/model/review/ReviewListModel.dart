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
    return ReviewListModel(
      reviewNoteId: json['review_note_id'],
      examId: json['exam_id'],
      name: json['name'],
      isPassed: json['is_passed'],
      certificate: json['certificate'],
      readCount: json['read_count'],
      passRate: (json['pass_rate'] as num).toDouble(),
    );
  }
}
