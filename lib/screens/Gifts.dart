import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/Gift.dart';
import 'package:saiphadminfinal/resources/firestore_methods.dart';

class GiftScreen extends StatefulWidget {
  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  late Future<List<GiftModel>> gifts;

  @override
  void initState() {
    super.initState();
    // Use a try-catch block to handle potential errors during initialization
    try {
      gifts = FireStoreMethods().getAllGifts();
    } catch (error) {
      print('Error during initialization: $error');
      // Handle the error appropriately, such as showing an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Gifts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Choose a color that suits your app's theme
      ),
     // Choose a color that suits your app's theme
      body: FutureBuilder<List<GiftModel>>(
        future: gifts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                // Customize color
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            List<GiftModel>? giftList = snapshot.data;
            if (giftList != null && giftList.isNotEmpty) {
              return ListView.builder(
                itemCount: giftList.length,
                itemBuilder: (context, index) {
                  GiftModel gift = giftList[index];
                  return Card(
                    elevation: 5, // Adjust elevation as needed
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Gift Code: ${gift.code}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Card: ${gift.card} - Used: ${gift.isUsed}'),
                      // Add more details as needed
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          // Add your delete logic here, such as calling a method to delete the gift
                          // For example, you can use FireStoreMethods().deleteGift(gift.id);
                          // After deleting, you may want to refresh the list, you can call setState or reload the data
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No gifts available. 😔',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
