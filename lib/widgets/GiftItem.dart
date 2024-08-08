import 'package:flutter/material.dart';

class GiftItem extends StatelessWidget {
  final String card;
  final int code;

  const GiftItem({
    Key? key,
    required this.card,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSizeRatio = constraints.maxHeight * 0.00125;

        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: const Color(0xffD5D6E5),
            child: ListTile(
              onTap: () {
                // Handle onTap event
              },
              title: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card,
                            style: TextStyle(
                              color: const Color(0xff273085),
                              fontWeight: FontWeight.w600,
                              fontSize: fontSizeRatio * 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                            child: Text(
                              "Code: $code",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontSizeRatio * 12,
                                color: const Color(0xff273085),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
