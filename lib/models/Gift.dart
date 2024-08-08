import 'package:cloud_firestore/cloud_firestore.dart';

class GiftModel {
  final int code;
  final String card;
  final bool isUsed;
  final String points;

  GiftModel({
    required this.code,
    required this.card,
    required this.isUsed,
    required this.points,
  });

  static GiftModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return GiftModel(
      code: snapshot["code"],
      card: snapshot["card"],
      isUsed: snapshot["isUsed"],
      points: snapshot["points"],

    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "card": card,
    "isUsed": isUsed,
    "points":points,
  };
}
