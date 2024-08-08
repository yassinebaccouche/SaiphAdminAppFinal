import 'dart:typed_data';

import 'package:saiphadminfinal/models/Gift.dart';
import 'package:saiphadminfinal/models/QuizArticle.dart';
import 'package:saiphadminfinal/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:saiphadminfinal/models/post.dart';
import 'package:saiphadminfinal/models/Notif.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String pseudo, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        pseudo: pseudo,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }


  Future<String> createNotification(NotificationModel notification) async {
    String res = "Some error occurred";
    try {
      String notificationId = const Uuid().v1();
      Map<String, dynamic> notificationData = {
        'question': notification.question,
        'possibleAnswers': notification.possibleAnswers,
        'correctAnswer': notification.correctAnswer,
        'notificationId': notificationId,
        'dateCreated': DateTime.now(),
      };

      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .set(notificationData);
      res = 'success';
    } catch (err, stackTrace) {
      print('Error creating notification: $err');
      print(stackTrace);
      res = 'Error creating notification';
    }
    return res;
  }






  Future<List<NotificationModel>> fetchAllNotifications() async {
        try {
          QuerySnapshot querySnapshot =
          await _firestore.collection('notifications').get();

          List<NotificationModel> notifications = querySnapshot.docs
              .where((doc) => doc.data() != null)
              .map((doc) => NotificationModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return notifications;
        } catch (err, stackTrace) {
          print('Error fetching notifications: $err');
          print(stackTrace);
          return [];
        }
      }
  Future<String> deleteNotification(String? question, String? correctAnswer) async {
    String res = "Some error occurred";
    try {
      // Assuming 'question' and 'correctAnswer' together form a unique identifier
      if (question != null && correctAnswer != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('notifications')
            .where('question', isEqualTo: question)
            .where('correctAnswer', isEqualTo: correctAnswer)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await _firestore.collection('notifications').doc(querySnapshot.docs.first.id).delete();
          res = 'success';
        } else {
          res = 'Notification not found';
        }
      } else {
        res = 'Invalid parameters: question or correctAnswer is null';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> createGift(GiftModel gift) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('gifts').doc(gift.code.toString()).set(gift.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<List<GiftModel>> getAllGifts() async {
    List<GiftModel> gifts = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('gifts').get();

      gifts = querySnapshot.docs.map((doc) => GiftModel.fromSnap(doc)).toList();
    } catch (err) {
      print("Error fetching gifts: $err");
      // You might want to handle errors here, such as logging or returning an empty list.
    }

    return gifts;
  }

  Future<String> uploadArticle({
  required String description,
  required Uint8List file,
  required String uid,
  required String pseudo,
  required String profImage,
  required String question,
  required List<String> possibleAnswers,
  String? correctAnswer,
  }) async {
  String res = "Some error occurred";
  try {
  String photoUrl = await StorageMethods().uploadImageToStorage('Articles', file, true);
  String articleId = const Uuid().v1(); // creates unique id based on time
  Article article = Article(
  description: description,
  uid: uid,
  pseudo: pseudo,
  likes: [],
  articleId: articleId,
  datePublished: DateTime.now(),
  postUrl: photoUrl,
  profImage: profImage,
  question: question,
  possibleAnswers: possibleAnswers,
  correctAnswer: correctAnswer,
  );

  await _firestore.collection('articles').doc(articleId).set(article.toJson());
  res = "success";
  } catch (err) {
  res = err.toString();
  }
  return res;
  }
}




