class ReviewListModel {
  final String review_note_id;
  final String exam_id;
  final String name;
  final bool is_passed;
  final String certificate;
  final int read_count;
  final double pass_rate;

  ReviewListModel({
    required this.review_note_id,
    required this.exam_id,
    required this.name,
    required this.is_passed,
    required this.certificate,
    required this.read_count,
    required this.pass_rate,
  });
}