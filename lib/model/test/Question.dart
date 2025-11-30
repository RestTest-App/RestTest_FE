class Question {
  final double? answerRate;
  final String seciton;
  final String description;
  final String? descriptionImage;
  final Map<String, dynamic> options;

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
      options: json['options'] as Map<String, dynamic>,
    );
  }
}
