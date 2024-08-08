import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saiphadminfinal/screens/add_post_screen.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      appBar: AppBar(
        title: Text('Posts'),


      ),
      body: Column(

        children: [

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (
                  context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void postImage(String uid, String pseudo, String profImage) async {
    setState(() {
      isLoading = true;
    });

    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        pseudo,
        profImage,
      );

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Published!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
