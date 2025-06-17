class Question {
  final double? answerRate;
  final String seciton;
  final String description;
  final String? descriptionImage;
  final List<String> options;

  Question({
    this.answerRate,
    required this.seciton,
    required this.description,
    this.descriptionImage,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      answerRate: json['answer_rate']?.toDouble(),
      seciton: json['section'],
      description: json['description'],
      descriptionImage: json['description_image'],
      options: List<String>.from(json['options'] ?? []),
    );
  }
}
