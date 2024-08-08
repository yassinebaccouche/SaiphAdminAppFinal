import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;

  const NotificationModel({
    required this.question,
    required this.possibleAnswers,
    this.correctAnswer,

  });
  NotificationModel.fromJson(Map<String, dynamic> data)
      : question = data['question'] ?? "",
        possibleAnswers = List<String>.from(data['possibleAnswers'] ?? []),
        correctAnswer = data['correctAnswer'] ?? "";

  static NotificationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return NotificationModel(
      question: snapshot["question"] as String? ?? "",
      possibleAnswers: (snapshot["possibleAnswers"] as List<String>?) ?? [],
      correctAnswer: snapshot["correctAnswer"] as String? ?? "",

    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "possibleAnswers": possibleAnswers,
    "correctAnswer": correctAnswer,

  };
}

