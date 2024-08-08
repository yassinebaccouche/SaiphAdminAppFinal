import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saiphadminfinal/Screens/search_screen.dart';
import 'package:saiphadminfinal/constants/color.dart';
import 'package:saiphadminfinal/constants/size.dart';
import 'package:saiphadminfinal/models/category.dart';
import 'package:saiphadminfinal/providers/user_provider.dart';
import 'package:saiphadminfinal/screens/AllNotif.dart';
import 'package:saiphadminfinal/screens/CreateGift.dart';
import 'package:saiphadminfinal/screens/CreateNotif.dart';
import 'package:saiphadminfinal/screens/add_post_screen.dart';
import 'package:saiphadminfinal/screens/feed_screen.dart';
import 'package:saiphadminfinal/screens/signup_screen.dart';
import 'package:saiphadminfinal/widgets/circle_button.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {

      UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);

      // Make sure to call async code in an async function
      Future<void> refreshUser() async {
        await userProvider.refreshUser();
      }

      refreshUser();
      return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            AppBar(),
            Body(),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: screenWidth > 600 ? 40 : 20,
              right: screenWidth > 600 ? 40 : 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Bonjour",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 40 : 20,
              vertical: 8,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              childAspectRatio: screenWidth > 600 ? 0.7 : 0.8,
              crossAxisSpacing: screenWidth > 600 ? 30 : 20,
              mainAxisSpacing: screenWidth > 600 ? 40 : 24,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(
                category: categoryList[index],
              );
            },
            itemCount: categoryList.length,
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.name == 'Posts') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(),
            ),
          );
        } else if (category.name == 'Utilisateurs') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            ),
          );
        } else if (category.name == 'Cadeaux') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGift(),
            ),
          );
        } else if (category.name == 'Notifications') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNotif(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                category.thumbnail,
                height: kCategoryCardImageSize,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(category.name),
            Text(
              "${category.noOfCourses.toString()} ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);

    // Make sure to call async code in an async function
    Future<void> refreshUser() async {
      await userProvider.refreshUser();
    }

    refreshUser(); // Call the refreshUser function

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bienvenu,\nSAIPH Admin Center",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              CircleButton(
                icon: Icons.notifications,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin : '+
              userProvider.getUser.pseudo, // Make sure you have userName defined somewhere
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
