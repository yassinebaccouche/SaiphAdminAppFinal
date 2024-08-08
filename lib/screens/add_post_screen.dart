import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
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

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // Change back button color
        title: const Text(
          'Créer un message',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => postImage(
              userProvider.getUser.uid,
              userProvider.getUser.pseudo,
              userProvider.getUser.photoUrl,
            ),
            child: const Text(
              'Partager',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userProvider.getUser.photoUrl), // Add user's profile image here
                  radius: 20,
                ),
                title: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Qu'est-ce qui préoccupe votre esprit?",
                    border: InputBorder.none,
                  ),
                ),

              ),
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 350.0,
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: _file != null
                            ? MemoryImage(_file!) as ImageProvider<Object>
                            : AssetImage('your_placeholder_image_path'), // Replace 'your_placeholder_image_path' with your actual placeholder image path
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _selectImage(context);
                      // Add functionality for attaching photos
                    },
                    icon: Icon(
                      Icons.photo,
                      color: Colors.green,
                    ),
                    label: Text(
                      "Image",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
