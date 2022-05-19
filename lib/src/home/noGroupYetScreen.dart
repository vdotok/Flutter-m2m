import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'responsiveWidget.dart';
import '../../constant.dart';

class NoGroupScreen extends StatefulWidget {
  const NoGroupScreen({Key? key, this.handleRefresh, this.handleNewCreate})
      : super(key: key);
  final handleRefresh;
  final handleNewCreate;

  @override
  _NoGroupScreenState createState() => _NoGroupScreenState();
}

class _NoGroupScreenState extends State<NoGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    print("in new chat button");
                    widget.handleNewCreate();
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

            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Container(
            //         width: 196,
            //         height: 56,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(5),
            //           border: Border.all(
            //             color: refreshButtonColor,
            //             width: 3,
            //           ),
            //         ),
            //         child: FlatButton(
            //           onPressed: () {
            //             print("in new chat button");
            //           },
            //           child: Text(
            //             "New Chat",
            //             style: TextStyle(
            //                 fontSize: 14.0,
            //                 fontFamily: primaryFontFamily,
            //                 fontStyle: FontStyle.normal,
            //                 fontWeight: FontWeight.bold,
            //                 color: refreshButtonColor),
            //           ),
            //         )),
            //   ],
            // ),
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
                    widget.handleRefresh();
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
