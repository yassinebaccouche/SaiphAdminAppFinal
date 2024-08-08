import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saiphadminfinal/resources/auth-methode.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final String defaultImageUrl =
      'https://i.stack.imgur.com/l60Hf.png';

  // Define the default image bytes
  Uint8List? defaultImageBytes;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethodes().SignUPUser(
      email: _emailController.text,
      password: _passwordController.text,
      Datedenaissance: '00/00/0000',
      FullScore: '0',
      PuzzleScore: '0',
      Verified: '0',
      pharmacy: '0',
      phoneNumber: '0',
      pseudo: '0',
      Ville:'0',
      CodeClient: '0',
      Profession: '0',
      isDeactivated:false,
      file: _image!,
    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Copiez ceci avant de fermer'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText('Email: ${_emailController.text}'),
                  SelectableText('Password: ${_passwordController.text}'),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );

      }
    } else {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    // Load the default image bytes when the widget initializes
    _loadDefaultImageBytes();
  }

  Future<void> _loadDefaultImageBytes() async {
    final response = await http.get(Uri.parse(defaultImageUrl));

    if (response.statusCode == 200) {
      setState(() {
        defaultImageBytes = response.bodyBytes;
      });
    }
  }

  void selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionnez la source de l''image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List img = await pickImage(ImageSource.camera);
                  if (img != null) {
                    setState(() {
                      _image = img;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List im = await pickImage(ImageSource.gallery);
                  if (im != null) {
                    setState(() {
                      _image = im;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Créer un utilisateur'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(36 * fem, 37 * fem, 36.83 * fem, 43 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20 * fem),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.red,
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: Colors.red,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 60,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Color(0xff273085),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.83 * fem, 0 * fem, 0 * fem, 19 * fem),
                child: Text(
                  'Ajouter une photo',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            // Remove validator here and use it within a Form widget if needed
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mot de passe',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Color(0xff273085).withOpacity(0.5),
                              ),
                            ),
                            // Remove validator here and use it within a Form widget if needed
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(79 * fem, 0 * fem, 78.28 * fem, 0 * fem),
                width: double.infinity,
                height: 54 * fem,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0 * fem, 4 * fem),
                      blurRadius: 2 * fem,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    GenerateUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff273085),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50 * fem),
                    ),
                    elevation: 2 * fem,
                  ),
                  child: Text(
                    'Generate',
                    style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(79 * fem, 0 * fem, 78.28 * fem, 0 * fem),
                width: double.infinity,
                height: 54 * fem,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0 * fem, 4 * fem),
                      blurRadius: 2 * fem,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    signUpUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff273085),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50 * fem),
                    ),
                    elevation: 2 * fem,
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void GenerateUser() {
    String generatedEmail = generateNewEmail();
    String generatedPassword = generateNewPassword();

    _emailController.text = generatedEmail;
    _passwordController.text = generatedPassword;


    setState(() {
      _image = defaultImageBytes;
    });

  }

  String generateNewPassword() {
    String characters = 'abcdefghijklmnopqrstuvwxyz0123456789.';
    String password_generated = '';

    for (int i = 0; i < 8; i++) {
      password_generated += characters[Random().nextInt(characters.length)];
    }

    return password_generated;
  }


  String generateNewEmail() {
    String characters = 'abcdefghijklmnopqrstuvwxyz';
    String email_generated = '';

    for (int i = 0; i < 8; i++) {
      int randomIndex = Random().nextInt(characters.length);
      email_generated += characters[randomIndex];
    }

    return '$email_generated@saiph.com.tn';
  }

}
