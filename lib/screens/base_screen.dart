import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saiphadminfinal/constants/color.dart';
import 'package:saiphadminfinal/constants/icons.dart';
import 'package:saiphadminfinal/providers/user_provider.dart';
import 'package:saiphadminfinal/screens/AllNotif.dart';
import 'package:saiphadminfinal/screens/CreateGift.dart';
import 'package:saiphadminfinal/screens/CreateNotif.dart';
import 'package:saiphadminfinal/screens/SettingScreen.dart';
import 'package:saiphadminfinal/screens/UplaodArticle.dart';
import 'package:saiphadminfinal/screens/add_post_screen.dart';
import 'package:saiphadminfinal/screens/featuerd_screen.dart';
import 'package:saiphadminfinal/screens/feed_screen.dart';

import '../constants/size.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    FeaturedScreen(),
    FeedScreen(),
    NotificationPage(),
    SettingsScreen()
  ];
  @override
  void initState() {
    super.initState();
    _refreshUser();
  }
  void _refreshUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              icFeatured,
              height: kBottomNavigationBarItemSize,
            ),
            icon: Image.asset(
              icFeaturedOutlined,
              height: kBottomNavigationBarItemSize,
            ),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              icLearning,
              height: kBottomNavigationBarItemSize,
            ),
            icon: Image.asset(
              icLearningOutlined,
              height: kBottomNavigationBarItemSize,
            ),
            label: "Poste",
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              icWishlist,
              height: kBottomNavigationBarItemSize,
            ),
            icon: Image.asset(
              icWishlistOutlined,
              height: kBottomNavigationBarItemSize,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              icSetting,
              height: kBottomNavigationBarItemSize,
            ),
            icon: Image.asset(
              icSettingOutlined,
              height: kBottomNavigationBarItemSize,
            ),
            label: "Paramètres",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
