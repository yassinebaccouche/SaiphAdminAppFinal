import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/user.dart';
import 'package:saiphadminfinal/resources/auth-methode.dart';
import 'package:saiphadminfinal/screens/ForgetPasswordScreen.dart';
import 'package:saiphadminfinal/screens/base_screen.dart';
import 'package:saiphadminfinal/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethodes().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      print('here!!!!');
      debugPrint(_emailController.text);
      User loggedInUser = await getUserDetailsByEmail(_emailController.text.toLowerCase());

      if (context.mounted) {
        if (loggedInUser.Verified == "0") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BaseScreen(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BaseScreen(),
            ),
          );
        }

        setState(() {
          _isLoading = false;
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Utilisateur',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Identifiant';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Mot de passe';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordPage(),
                          ),
                        ),
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Inter',
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff273085),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 2,
                        ),
                        child: !_isLoading
                            ? const Text(
                          'Connecter',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        )
                            : CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<User> getUserDetailsByEmail(String email) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return User.fromSnap(querySnapshot.docs[0]);
  } else {
    throw Exception("User not found");
  }
}
