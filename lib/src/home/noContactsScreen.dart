import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../core/providers/auth.dart';

import '../../constant.dart';

class NoContactsScreen extends StatelessWidget {
  AuthProvider authProvider;
  final refreshList;
  final newChatHandler;
  NoContactsScreen({this.refreshList, this.newChatHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: SvgPicture.asset(
            'assets/Face.svg',
          )),
          // SizedBox(height: 43),
          Text(
            "No Conversation Yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: chatRoomColor,
              fontSize: 21,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
              width: 220,
              height: 66,
              child: Text(
                "Tap and hold on any message to star it, so you can easily find it later.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: chatRoomTextColor,
                  fontSize: 14,
                ),
              )),
          SizedBox(height: 22),
          Container(
            width: 196,
            height: 56,
            child: Container(
                width: 196,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: refreshButtonColor,
                    width: 3,
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    newChatHandler();
                  },
                  child: Text(
                    "New Group",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: primaryFontFamily,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: refreshButtonColor),
                  ),
                )),
          ),
          SizedBox(height: 15),
          Container(
            width: 196,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: refreshButtonColor,
            ),
            child: Container(
                width: 196,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: selectcontactColor,
                    width: 3,
                  ),
                ),
                child: Center(
                    child: FlatButton(
                  onPressed: () {
                    // _showDialog();
                    print("in Refresh button");
                  },
                  child: Text(
                    "Refresh",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: primaryFontFamily,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: refreshTextColor,
                        letterSpacing: 0.90),
                  ),
                ))),
          ),
        ],
      ),
    );
  }
}
