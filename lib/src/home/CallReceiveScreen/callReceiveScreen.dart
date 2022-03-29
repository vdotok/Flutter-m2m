import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream_example/constant.dart';
import 'package:vdotok_stream_example/src/core/models/ParticipantsModel.dart';
import 'package:vdotok_stream_example/src/core/providers/auth.dart';
import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream_example/src/home/home.dart';
import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';

// ignore: must_be_immutable
class CallReceiveScreen extends StatelessWidget {
  List<ParticipantsModel> callingto;
  String mediatype;
  var registerRes;
  List<Map<String, dynamic>> rendererListWithRefid = [];
  CallProvider callprovider;
  AuthProvider authprovider;
  String incomingfrom;
  final stopRinging;
  final groupName;
  CallReceiveScreen(
      {this.callingto,
      this.mediatype,
      this.registerRes,
      this.rendererListWithRefid,
      this.callprovider,
      this.authprovider,
      this.incomingfrom,
      this.stopRinging, this.groupName});

  @override
  Widget build(BuildContext context) {
    print("here i am in separte class of Call Receive Screen");
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(children: <Widget>[
        mediatype == MediaType.video
            ? Container(
                child: RemoteStream(
                remoteRenderer: rendererListWithRefid[0]["rtcVideoRenderer"],
              ))
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    backgroundAudioCallDark,
                    backgroundAudioCallLight,
                    backgroundAudioCallLight,
                    backgroundAudioCallLight,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.0),
                )),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/userIconCall.svg',
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.only(top: 120),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "Incoming Call from",
                style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontFamily: secondaryFontFamily,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: darkBlackColor),
              ),
              SizedBox(
                height: 8,
              ),
               Text(
                
                    groupName,
                style: TextStyle(
                    fontFamily: primaryFontFamily,
                    color: darkBlackColor,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24),
              ),
              // Consumer<ContactProvider>(
              //   builder: (context, contact, child) {
              //     if (contact.contactState == ContactStates.Success) {
              //       int index = contact.contactList.users.indexWhere(
              //           (element) => element.ref_id == incomingfrom);
              //       return Text(
              //         index == -1
              //             ? incomingfrom
              //             : contact.contactList.users[index].full_name,
              //         style: TextStyle(
              //             fontFamily: primaryFontFamily,
              //             color: darkBlackColor,
              //             decoration: TextDecoration.none,
              //             fontWeight: FontWeight.w700,
              //             fontStyle: FontStyle.normal,
              //             fontSize: 24),
              //       );
              //     } else
              //       return Container();
              //   },
              // ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: 56,
          ),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  stopRinging();
                  signalingClient.onDeclineCall(
                      authprovider.getUser.ref_id, registerRes["mcToken"]);

                  callprovider.initial();
                },
              ),
              SizedBox(width: 64),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/Accept.svg',
                ),
                onTap: () {
                  stopRinging();
                  signalingClient.createAnswer(incomingfrom);
                  callprovider.callStart();
                },
              ),
            ],
          ),
        ),
      ]);
    }));
  }
}
