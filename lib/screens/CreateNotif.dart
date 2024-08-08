import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/Notif.dart';
import 'package:saiphadminfinal/resources/firestore_methods.dart';


class CreateNotif extends StatefulWidget {
  const CreateNotif({Key? key}) : super(key: key);

  @override
  State<CreateNotif> createState() => _CreateNotifState();
}

class _CreateNotifState extends State<CreateNotif> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  List<String> possibleAnswers = [];
  String? correctAnswer;
  late double screenWidth;
  late double fontSizeFactor;
  double baseWidth = 380;
  List<NotificationModel> notifications = [];




  Widget _buildNotificationList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notifications[index].question),
          subtitle: Text(
            'Correct Answer: ${notifications[index].correctAnswer ?? "Not provided"}',
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final double scalingFactor = MediaQuery.of(context).size.width / baseWidth;
    fontSizeFactor = scalingFactor * 0.97;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer une notification',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSizeFactor * 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question à envoyer:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14 * fontSizeFactor,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xff273085),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xff273085),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.question_mark_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Réponses possibles:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14 * fontSizeFactor,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildPossibleAnswers(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (answerController.text.isNotEmpty) {
                  addAnswer();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50 * scalingFactor),
                ),
                backgroundColor: Color(0xff273085),
                shadowColor: Colors.grey.withOpacity(0.5),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                width: screenWidth / 2,
                child: Center(
                  child: Text(
                    'Ajouter la réponse',
                    style: TextStyle(
                      fontSize: 16 * fontSizeFactor,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Réponse correcte:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14 * fontSizeFactor,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xff273085),
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: DropdownButton<String>(
                  hint: const Text('Choisissez la bonne réponse'),
                  underline: const SizedBox(),
                  value: correctAnswer,
                  onChanged: (value) {
                    setState(() {
                      correctAnswer = value!;
                    });
                  },
                  items: possibleAnswers
                      .map<DropdownMenuItem<String>>((String answer) {
                    return DropdownMenuItem<String>(
                      value: answer,
                      child: SizedBox(
                        width: screenWidth / 2,
                        child: Text(
                          answer,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                await createNotification();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50 * scalingFactor),
                ),
                backgroundColor: const Color(0xff273085),
                shadowColor: Colors.grey.withOpacity(0.5),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 17,
                ),
                width: screenWidth / 2,
                child: Center(
                  child: Text(
                    'Envoyer',
                    style: TextStyle(
                      fontSize: 16 * fontSizeFactor,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPossibleAnswers() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'Entrez une réponse possible',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xff273085),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xff273085),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.question_answer_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: possibleAnswers
              .map((answer) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    answer,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    removeAnswer(answer);
                  },
                ),
              ],
            ),
          ))
              .toList(),
        ),
      ],
    );
  }

  void addAnswer() {
    setState(() {
      possibleAnswers.add(answerController.text);
      answerController.clear();
    });
  }

  void removeAnswer(String answer) {
    setState(() {
      possibleAnswers.remove(answer);
    });
  }

  Future<void> createNotification() async {
    try {
      NotificationModel notification = NotificationModel(
        question: questionController.text,
        possibleAnswers: possibleAnswers,
        correctAnswer: correctAnswer,
      );

      String result = await FireStoreMethods().createNotification(notification);
      print(result);
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

}
