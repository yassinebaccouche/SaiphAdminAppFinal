import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saiphadminfinal/Screens/profile_screen.dart';
import 'package:saiphadminfinal/Screens/search_screen.dart';
import 'package:saiphadminfinal/resources/auth-methode.dart';
import 'package:saiphadminfinal/screens/Gifts.dart';
import 'package:saiphadminfinal/screens/SignInScreen.dart';
import 'package:saiphadminfinal/screens/UplaodArticle.dart';
import 'package:saiphadminfinal/screens/links_list_screen.dart';
import 'package:saiphadminfinal/widgets/profile_container.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileContainer(
                body: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: ()=> Navigator.of(context).push( MaterialPageRoute(builder: (context)=>ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),),),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userProvider.getUser.photoUrl),
                            radius: 80, // Adjust the radius to your desired size
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Image.asset(
                              "assets/icons/editpic.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          userProvider.getUser.pseudo,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),


                    ProfileButton(
                      screenWidth,
                      "Utilisateur",
                      const SizedBox(),
                          () {
                        // Navigate to the profile screen when "Amis" button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),


                    ProfileButton(
                      screenWidth,
                      "Links",
                      const SizedBox(),
                          () {
                        // Navigate to the profile screen when "Amis" button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LinksListScreen(),
                        ));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),


                    ProfileButton(
                      screenWidth,
                      "Article",
                      const SizedBox(),
                          () {
                        // Navigate to the profile screen when "Amis" button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadArticlePage(),
                        ));
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ProfileButton(
                        screenWidth,
                        "Transfert de points",
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                            () {}),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileButton(
                      screenWidth,
                      "Déconnexion",
                      const SizedBox(),
                          () async {
                        await AuthMethodes().signOut();
                        // Navigate back to the previous screen or any desired screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()), // Replace SignInScreen with your actual sign-in screen
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileButton(
                      screenWidth,
                      "Cadeaux",
                      const SizedBox(),
                          () {
                        // Navigate to the profile screen when "Amis" button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GiftScreen(),
                        ));
                      },
                    ),


                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget ProfileButton(
    double width, String text, Widget ending, VoidCallback function) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff273085),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ending
        ],
      ),
    ),
  );
}
