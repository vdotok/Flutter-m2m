import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_stream_example/src/core/models/ParticipantsModel.dart';
import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
import 'package:vdotok_stream_example/src/home/home.dart';
import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';

import '../../../constant.dart';

class CallDialScreen extends StatelessWidget {
  List<ParticipantsModel> callingto;
  String mediatype;
  var registerRes;
  List<Map<String, dynamic>> rendererListWithRefid = [];
  CallProvider callprovider;
  CallDialScreen({this.callingto,this.mediatype,this.registerRes,this.rendererListWithRefid,this.callprovider});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            mediatype == MediaType.video
                ? Container(
                    // color: Colors.red,
                    //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RemoteStream(
                      remoteRenderer: rendererListWithRefid[0]
                          ["rtcVideoRenderer"],
                    )
                    )
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
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                       isRinging==false? "Calling..": "Ringing..",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                      Text(
                              "$groupName",
                              style: TextStyle(
                                  fontFamily: primaryFontFamily,
                                  color: darkBlackColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24)),
                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: callingto.length,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         alignment: Alignment.center,
                      //         child: Text(
                      //           callingto[index].full_name,
                      //           style: TextStyle(
                      //               fontFamily: primaryFontFamily,
                      //               color: darkBlackColor,
                      //               decoration: TextDecoration.none,
                      //               fontWeight: FontWeight.w700,
                      //               fontStyle: FontStyle.normal,
                      //               fontSize: 24),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // )
                    ])),
            Container(
              padding: EdgeInsets.only(bottom: 56),
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                 // audioPlayer.stop();
                  signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
                callprovider.initial();
                audioPlayer.stop();
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
