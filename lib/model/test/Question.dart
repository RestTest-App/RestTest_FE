class Question{
  final double answer_rate;
  final String seciton;
  final String description;
  final String? description_image;
  final List<String> options;

  Question({
    required this.answer_rate,
    required this.seciton,
    required this.description,
    this.description_image,
    required this.options,
});
}