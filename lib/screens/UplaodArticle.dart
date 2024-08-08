import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:saiphadminfinal/resources/firestore_methods.dart'; // Ensure you have this file and class implemented


class UploadArticlePage extends StatefulWidget {
  @override
  _UploadArticlePageState createState() => _UploadArticlePageState();
}

class _UploadArticlePageState extends State<UploadArticlePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  List<String> _possibleAnswers = [];
  String? _correctAnswer;
  Uint8List? _image;
  bool _isLoading = false;

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() async {
        _image = Uint8List.fromList(await image.readAsBytes());
      });
    }
  }

  Future<void> _uploadArticle() async {
    setState(() {
      _isLoading = true;
    });

    final String description = _descriptionController.text;
    final String question = _questionController.text;

    // Replace these with actual user data in a real application
    const String uid = 'test_uid';
    const String pseudo = 'test_pseudo';
    const String profImage = 'test_prof_image';

    if (_image != null) {
      String res = await FireStoreMethods().uploadArticle(
        description: description,
        file: _image!,
        uid: uid,
        pseudo: pseudo,
        profImage: profImage,
        question: question,
        possibleAnswers: _possibleAnswers,
        correctAnswer: _correctAnswer,
      );

      if (res == "success") {
        setState(() {
          _isLoading = false;
          _descriptionController.clear();
          _questionController.clear();
          _answerController.clear();
          _possibleAnswers.clear();
          _correctAnswer = null;
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article uploaded successfully')));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Article'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            _buildPossibleAnswersSection(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            _image != null
                ? Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(_image!),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
            )
                : SizedBox.shrink(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadArticle,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Upload Article'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPossibleAnswersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Possible Answers:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Enter a possible answer',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                if (_answerController.text.isNotEmpty) {
                  setState(() {
                    _possibleAnswers.add(_answerController.text);
                    _answerController.clear();
                  });
                }
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _possibleAnswers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_possibleAnswers[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _possibleAnswers.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xff273085),
              width: 2,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: DropdownButton<String>(
              hint: const Text('Choisissez la bonne réponse'),
              underline: const SizedBox(),
              value: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                });
              },
              items: _possibleAnswers
                  .map<DropdownMenuItem<String>>((String answer) {
                return DropdownMenuItem<String>(
                  value: answer,
                  child: SizedBox(

                    child: Text(
                      answer,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
            SizedBox(height: 16.0),

            SizedBox(height: 16.0),
            _image != null
                ? Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(_image!),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
            )
                : SizedBox.shrink(),

          ],
        );

  }
}
