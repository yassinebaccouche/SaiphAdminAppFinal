import 'package:flutter/material.dart';
import 'package:saiphadminfinal/screens/SignInScreen.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 350;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 1050 * fem,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/backgroundSignin.png'),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 32.7479248047 * fem,
                left: (MediaQuery.of(context).size.width - (180.78 * fem)) / 2,
                child: Align(
                  child: SizedBox(
                    width: 180.78 * fem,
                    height: 70.81 * fem,
                    child: Image.asset(
                      'assets/accroche-adol-1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: 280 * fem,
                  height: 270 * fem,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: Text('Please Enter your Email To update your Password' ,style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Color(0xff273085),
                    ),),
                        ),
                        // Email Input Field
                        SizedBox(height: 25),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        // Password Input Field


                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 135.0), // Adjust left padding as needed
                              child: Text(
                                'retour Sign In page',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Inter',
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        // Sign In Button
                        Container(
                          width: 120 * fem,
                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff273085),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50 * fem),
                              ),
                              elevation: 2 * fem,
                            ),
                            onPressed: () {
                              // Add your sign-in logic here
                            },
                            child: !_isLoading
                                ? const Text(
                              'Envoyer',
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
            ],
          ),
        ),
      ),
    );
  }
}
