
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saiphadminfinal/providers/user_provider.dart';
import 'package:saiphadminfinal/screens/SignInScreen.dart';
import 'package:saiphadminfinal/screens/base_screen.dart';

 // Import the SignInScreen

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCzA6qTchzKCjIvJippBtqb3sj1LL6UNo4",
          authDomain: "adol-2789a.firebaseapp.com",
          projectId: "adol-2789a",
          storageBucket: "adol-2789a.appspot.com",
          messagingSenderId: "345522697739",
          appId: "1:345522697739:web:ab291843dd7c46520d790e"),

    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Saiph Admin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            displayMedium: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return BaseScreen(); // Change this to the appropriate screen for logged-in users
              } else {
                return SignInScreen();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('Error loading authentication state'),
              );
            }
          },
        ),
      ),
    );
  }
}
