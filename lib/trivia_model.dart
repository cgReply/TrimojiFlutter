import 'dart:math';

import 'package:emoji_trivia_app/utils.dart';

class TriviaResponse {
  final int responseCode;
  final List<TriviaQuestion> results;

  TriviaResponse({
    required this.responseCode,
    required this.results,
  });

  factory TriviaResponse.fromJson(Map<String, dynamic> json) {
    return TriviaResponse(
      responseCode: json['response_code'],
      results: List<TriviaQuestion>.from(
        json['results'].map((x) => TriviaQuestion.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'results': List<dynamic>.from(results.map((x) => x.toJson())),
    };
  }
}

class TriviaQuestion {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  TriviaQuestion({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      incorrectAnswers: List<String>.from(json['incorrect_answers'].map((x) => x as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': List<dynamic>.from(incorrectAnswers.map((x) => x)),
    };
  }
}

class Question {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final int correctAnswerIndex;
  final List<String> allAnswers;
  final int? answered;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswerIndex,
    required this.allAnswers,
    required this.answered
  });
}

List<Question> responseToQuestions(List<TriviaQuestion> responses) {
  return responses.map((e) {

    var allAnswers = e.incorrectAnswers.map((e) => decodeHtml(e)).toList();

    var random = Random();
    var index = random.nextInt(allAnswers.length+1);

    allAnswers.insert(index, decodeHtml(e.correctAnswer));

    return Question(type: decodeHtml(e.type), difficulty: decodeHtml(e.difficulty), category: decodeHtml(e.category), question: decodeHtml(e.question), correctAnswerIndex: index, allAnswers: allAnswers, answered: null);
  }).toList();
}