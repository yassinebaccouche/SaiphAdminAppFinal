
import 'package:saiphadminfinal/resources/firestore_methods.dart';

import 'package:saiphadminfinal/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/follow_button.dart';
class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData={};
  int postLen= 0;
  int followers= 0;
  int following = 0;
  bool isFollowing= false;
  bool isLoading =false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
    setState(() {
      isLoading = true;
    });
    try{
      var Usersnap =await FirebaseFirestore.instance.collection('users')
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap =await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen=postSnap.docs.length;
      userData=Usersnap.data()!;
      followers= Usersnap.data()!['followers'].length;
      following= Usersnap.data()!['following'].length;
      isFollowing=Usersnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid );
      setState(() {

      });
    }catch(e){
      showSnackBar(context, e.toString(),);
    }
    setState(() {
      isLoading = false;
    });
  }
  Widget build(BuildContext context) {
    return  isLoading ?
    const Center(
      child:CircularProgressIndicator()
      ,) :Scaffold(
      appBar: AppBar(
backgroundColor: Colors.transparent,
        title: Text(
          userData['pseudo'],
        ),
        centerTitle: false,
      ),
        body:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          userData['photoUrl'],
                        ),
                        radius: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(postLen, "posts"),
                                buildStatColumn(followers, "followers"),
                                buildStatColumn(following, "following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid == widget.uid? FollowButton(
                                  text: 'Edit profile',
                                  backgroundColor: Colors.blueAccent,
                                  textColor: Colors.white,
                                  borderColor: Colors.blueAccent,




                                ): isFollowing ?FollowButton(
                                  text: 'Unfollow',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'],
                                    );
                                    setState((){
                                      isFollowing = false;
                                      followers--;

                                    });

                                  }
                                ):FollowButton(
                                  text: 'Follow',
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                  function: () async {
                                    await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'],

                                    );
                                    setState((){
                                      isFollowing = true;
                                      followers++;

                                    });

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Text(
                     'Email: ' + userData['email'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 1,
                    ),
                    child:Text('Pharmacy: ' + userData['pharmacy'] +   ' (Ville:'+ userData['ville']+')')

                  ),
                ],
              ),
            ),
            const Divider(),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Handle error if there's an issue with the future.
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Data is available, so build the grid.
                  final documents = snapshot.data!.docs; // Get the documents from the query result.

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];
                      return Container(
                        child: Image(
                          image: NetworkImage(
                            snap['postUrl']
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                        ;
                    },
                  );
                }
              },
            )

          ],
        ),
    );

  }
  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
