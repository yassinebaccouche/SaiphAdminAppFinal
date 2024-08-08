import 'package:flutter/material.dart';

class CustomYesNoDialog extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function()? onYesPressed;
  final Color primaryColor;

  CustomYesNoDialog({
    required this.title,
    required this.content,
    required this.onYesPressed,
    required this.primaryColor,
  });


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: ()=>Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'Non',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffE47B73)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if (onYesPressed != null) {
                          Navigator.of(context).pop();
                          onYesPressed!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Oui',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
