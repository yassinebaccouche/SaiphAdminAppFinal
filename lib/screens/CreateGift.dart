import 'package:flutter/material.dart';
import 'package:saiphadminfinal/models/Gift.dart';
import 'package:saiphadminfinal/resources/firestore_methods.dart';
import 'package:saiphadminfinal/widgets/GiftItem.dart';

class CreateGift extends StatefulWidget {
  const CreateGift({Key? key}) : super(key: key);

  @override
  State<CreateGift> createState() => _CreateGiftState();
}

class _CreateGiftState extends State<CreateGift> {
  TextEditingController _giftController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pointsController = TextEditingController(); // Added
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  List<GiftModel> gifts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter des cadeaux',
          style: TextStyle(
            color: const Color(0xff273085),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _giftController,
              decoration: InputDecoration(
                labelText: 'Cadeau',
                labelStyle: const TextStyle(color: Color(0xff273085)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      labelStyle: const TextStyle(color: Color(0xff273085)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _pointsController,
                    decoration: InputDecoration(
                      labelText: 'Points',
                      labelStyle: const TextStyle(color: Color(0xff273085)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addItem();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff273085),
              ),
              child: Text('Ajouter', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addItem() async {
    if (_codeController.text.isNotEmpty) {
      int code = int.parse(_codeController.text);
      String card = _giftController.text; // Fixed
      String points = _pointsController.text; // Fixed

      setState(() {
        gifts.add(
          GiftModel(
            code: code,
            card: card,
            points: points,
            isUsed: false,
          ),
        );
        _codeController.clear();
        _giftController.clear(); // Added to clear gift controller
        _pointsController.clear(); // Added to clear points controller
      });

      String result = await fireStoreMethods.createGift(
        GiftModel(
          code: code,
          card: card,
          points: points,
          isUsed: false,
        ),
      );

      print(result);
    }
  }
}


