import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/Notif.dart';
import 'package:saiphadminfinal/resources/firestore_methods.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    FireStoreMethods firestoreMethods = FireStoreMethods();
    List<NotificationModel> fetchedNotifications =
    await firestoreMethods.fetchAllNotifications();

    setState(() {
      notifications = fetchedNotifications;
    });
  }

  void _deleteNotification(int index) async {
    FireStoreMethods firestoreMethods = FireStoreMethods();
    String deleteResult = await firestoreMethods.deleteNotification(
      notifications[index].question,
      notifications[index].correctAnswer,
    );

    if (deleteResult == 'success') {
      setState(() {
        notifications.removeAt(index);
      });

      // Optionally, you may show a snackbar or toast to indicate successful deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notification deleted successfully'),
      ));
    } else {
      // Handle deletion failure
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting notification: $deleteResult'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: buildNotificationList(),
    );
  }

  Widget buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        NotificationModel notification = notifications[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
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
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                notification.question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Bonne réponse: ${notification.correctAnswer}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  // Add more details if needed
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Call the method to delete the notification
                  _deleteNotification(index);
                },
              ),
              onTap: () {
                // Add any action on notification tap
              },
            ),
          ),
        );
      },
    );
  }
}
