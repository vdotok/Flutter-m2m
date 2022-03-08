import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream_example/constant.dart';
import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream_example/src/home/home.dart';
import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';


class CallSttartScreen extends StatefulWidget {
  String mediatype;
  var registerRes;
  List<Map<String, dynamic>> rendererListWithRefid = [];
  String incomingfrom;
  ContactProvider contactprovider;
  bool onRemotestream;
  String callto;
  String pressduration;
 
  final stopcall;
  CallSttartScreen({this.mediatype,this.registerRes,this.rendererListWithRefid,this.incomingfrom,
  this.contactprovider,this.onRemotestream,this.callto,this.pressduration,this.stopcall});

  @override
  _CallSttartScreenState createState() => _CallSttartScreenState();
}



class _CallSttartScreenState extends State<CallSttartScreen> {
  Future<bool> _onWillPop() async {
    print("this is string last ");
   // print("this is incall vaiableee $inCall");
   // if(inCall){

MoveToBackground.moveTaskToBack();
print("thissssssskbncjvbcvj");
return false;


}
  @override
  Widget build(BuildContext context) {
    return
    
      WillPopScope(
                onWillPop: _onWillPop,
                child:
     Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            widget.onRemotestream
                ? widget.rendererListWithRefid.length == 1
                    ? Container(
                    //color:Colors.red
                    // child:
                    // Center(child: Text("Reconnecting......"))
                    )
                    :  widget.rendererListWithRefid.length == 2
                        ?
                         widget.rendererListWithRefid[1]["remoteVideoFlag"] == 0
                            ? Container(
                                decoration: BoxDecoration(
                                    color: backgroundAudioCallLight),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/userIconCall.svg',
                                      ),
                                      Text(widget.contactprovider
                                          .contactList
                                          .users[widget.contactprovider
                                              .contactList.users
                                              .indexWhere((element) =>
                                                  element.ref_id ==
                                                   widget.rendererListWithRefid[1]
                                                      ["refID"])]
                                          .full_name)
                                    ],
                                  ),
                                ),
                              )
                            : RemoteStream(
                                remoteRenderer:  widget.rendererListWithRefid[1]
                                    ["rtcVideoRenderer"],
                              )
                        :  widget.rendererListWithRefid.length == 3
                            ? Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                        // color: Colors.yellow,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: // if video is off then show white screen
                                             widget.rendererListWithRefid[1]
                                                        ["remoteVideoFlag"] ==
                                                    0
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            backgroundAudioCallLight),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/userIconCall.svg',
                                                          ),
                                                          Text(widget.contactprovider
                                                              .contactList
                                                              .users[widget.contactprovider
                                                                  .contactList
                                                                  .users
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .ref_id ==
                                                                       widget.rendererListWithRefid[
                                                                              1]
                                                                          [
                                                                          "refID"])]
                                                              .full_name)
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : RemoteStream(
                                                    remoteRenderer:
                                                         widget.rendererListWithRefid[1]
                                                            [
                                                            "rtcVideoRenderer"],
                                                  )),
                                  ),
                                  Expanded(
                                    child: Container(
                                        // color: Colors.green,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: // if video is off then show white screen
                                             widget.rendererListWithRefid[2]
                                                        ["remoteVideoFlag"] ==
                                                    0
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            backgroundAudioCallLight),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/userIconCall.svg',
                                                          ),
                                                          Text(widget.contactprovider
                                                              .contactList
                                                              .users[widget.contactprovider
                                                                  .contactList
                                                                  .users
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .ref_id ==
                                                                      widget.rendererListWithRefid[
                                                                              2]
                                                                          [
                                                                          "refID"])]
                                                              .full_name)
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : RemoteStream(
                                                    remoteRenderer:
                                                         widget.rendererListWithRefid[2]
                                                            [
                                                            "rtcVideoRenderer"],
                                                  )),
                                  )
                                ],
                              )
                            :  widget.rendererListWithRefid.length == 4
                                ? Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                                // color: Colors.yellow,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: // if video is off then show white screen
                                                    widget.rendererListWithRefid[1][
                                                                "remoteVideoFlag"] ==
                                                            0
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        backgroundAudioCallLight),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/userIconCall.svg',
                                                                  ),
                                                                  Text(widget.contactprovider
                                                                      .contactList
                                                                      .users[widget.contactprovider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                               widget.rendererListWithRefid[1]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                 widget.rendererListWithRefid[
                                                                        1][
                                                                    "rtcVideoRenderer"],
                                                          )),
                                            Container(
                                              // color: Colors.yellow,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: // if video is off then show white screen
                                                   widget.rendererListWithRefid[2][
                                                              "remoteVideoFlag"] ==
                                                          0
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  backgroundAudioCallLight),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/userIconCall.svg',
                                                                ),
                                                                Text(widget.contactprovider
                                                                    .contactList
                                                                    .users[widget.contactprovider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                             widget.rendererListWithRefid[2]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                              widget.rendererListWithRefid[
                                                                      2][
                                                                  "rtcVideoRenderer"],
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // color: Colors.green,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: // if video is off then show white screen
                                              widget.rendererListWithRefid[3]
                                                          ["remoteVideoFlag"] ==
                                                      0
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundAudioCallLight),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/userIconCall.svg',
                                                            ),
                                                            Text(widget.contactprovider
                                                                .contactList
                                                                .users[widget.contactprovider
                                                                    .contactList
                                                                    .users
                                                                    .indexWhere((element) =>
                                                                        element
                                                                            .ref_id ==
                                                                         widget.rendererListWithRefid[3]
                                                                            [
                                                                            "refID"])]
                                                                .full_name)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : RemoteStream(
                                                      remoteRenderer:
                                                          widget.rendererListWithRefid[
                                                                  3][
                                                              "rtcVideoRenderer"],
                                                    ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                                // color: Colors.yellow,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: // if video is off then show white screen
                                                    widget.rendererListWithRefid[1][
                                                                "remoteVideoFlag"] ==
                                                            0
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        backgroundAudioCallLight),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/userIconCall.svg',
                                                                  ),
                                                                  Text(widget.contactprovider
                                                                      .contactList
                                                                      .users[widget.contactprovider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                              widget.rendererListWithRefid[1]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                 widget.rendererListWithRefid[
                                                                        1][
                                                                    "rtcVideoRenderer"],
                                                          )),
                                            Container(
                                              // color: Colors.yellow,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: // if video is off then show white screen
                                                   widget.rendererListWithRefid[2][
                                                              "remoteVideoFlag"] ==
                                                          0
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  backgroundAudioCallLight),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/userIconCall.svg',
                                                                ),
                                                                Text(widget.contactprovider
                                                                    .contactList
                                                                    .users[widget.contactprovider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                             widget.rendererListWithRefid[2]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                               widget.rendererListWithRefid[
                                                                      2][
                                                                  "rtcVideoRenderer"],
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                                // color: Colors.yellow,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: // if video is off then show white screen
                                                    widget.rendererListWithRefid[3][
                                                                "remoteVideoFlag"] ==
                                                            0
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        backgroundAudioCallLight),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/userIconCall.svg',
                                                                  ),
                                                                  Text(widget.contactprovider
                                                                      .contactList
                                                                      .users[widget.contactprovider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                               widget.rendererListWithRefid[3]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                 widget.rendererListWithRefid[
                                                                        3][
                                                                    "rtcVideoRenderer"],
                                                          )),
                                            Container(
                                              // color: Colors.yellow,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: // if video is off then show white screen
                                                   widget.rendererListWithRefid[4][
                                                              "remoteVideoFlag"] ==
                                                          0
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  backgroundAudioCallLight),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/userIconCall.svg',
                                                                ),
                                                                Text(widget.contactprovider
                                                                    .contactList
                                                                    .users[widget.contactprovider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                             widget.rendererListWithRefid[4]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                             widget.rendererListWithRefid[
                                                                      4][
                                                                  "rtcVideoRenderer"],
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
              padding: EdgeInsets.only(top: 55, left: 20),
              //height: 79,
              //width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You are video calling with',
                    style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontFamily: secondaryFontFamily,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: darkBlackColor),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        (widget.callto == "")
                            ? Consumer<ContactProvider>(
                                builder: (context, contact, child) {
                                if (contact.contactState ==
                                    ContactStates.Success) {
                                  int index = contact.contactList.users
                                      .indexWhere((element) =>
                                          element.ref_id == widget.incomingfrom);
                                  print("i am here------- $index");
                                  return Text(
                                    //"${widget.incomingfrom}",
                                   contact.contactList.users[index].full_name,
                                    style: TextStyle(
                                        fontFamily: primaryFontFamily,
                                        color: darkBlackColor,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 24),
                                  );
                                } else {
                                  return Container();
                                }
                              })
                            : Text(
                                widget.callto,
                                style: TextStyle(
                                    fontFamily: primaryFontFamily,
                                    // background: Paint()..color = yellowColor,
                                    color: darkBlackColor,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 24),
                              ),

                        Text(
                          widget.pressduration,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontFamily: secondaryFontFamily,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            !kIsWeb
                ? widget.mediatype == MediaType.video
                    ? Container(
                        // color: Colors.red,
                        child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 120.33, 20, 27),
                              child: GestureDetector(
                                child: SvgPicture.asset(
                                    'assets/switch_camera.svg'),
                                onTap: () {
                                  signalingClient.switchCamera();
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                child:!switchSpeaker
                                    ? SvgPicture.asset('assets/VolumnOn.svg')
                                    : SvgPicture.asset('assets/VolumeOff.svg'),
                                onTap: () {
                                  signalingClient.switchSpeaker(switchSpeaker);
                                  setState(() {
                                    switchSpeaker = !switchSpeaker;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                    : Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 120.0, 20.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  child:!switchSpeaker
                                      ? SvgPicture.asset('assets/VolumnOn.svg')
                                      : SvgPicture.asset(
                                          'assets/VolumeOff.svg'),
                                  onTap: () {
                                    signalingClient
                                        .switchSpeaker(switchSpeaker);
                                    setState(() {
                                      switchSpeaker = !switchSpeaker;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                : SizedBox(),

            widget.mediatype == MediaType.video
                ? Positioned(
                    right: 20.0,
                    bottom: 145.0,
                    // right: 20,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 170,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: RemoteStream(
                              remoteRenderer:  widget.rendererListWithRefid[0]
                                  ["rtcVideoRenderer"],
                            )
                            ),
                      ),
                    ),
                  )
                : Container(
                 // color:Colors.red
                ),
            Container(
              padding: EdgeInsets.only(
                bottom: 56,
              ),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                widget.mediatype == MediaType.video
                      ? Row(
                          children: [
                            GestureDetector(
                              child: !enableCamera
                                  ? SvgPicture.asset('assets/video_off.svg')
                                  : SvgPicture.asset('assets/video.svg'),
                              onTap: () {
                                setState(() {
                                 enableCamera = !enableCamera;
                                });
                                signalingClient.audioVideoState(
                                    audioFlag: switchMute  ? 1 : 0,
                                    videoFlag: enableCamera ? 1 : 0,
                                    mcToken: widget.registerRes["mcToken"]);
                                signalingClient.enableCamera(enableCamera);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        )
                      : SizedBox(),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/end.svg',
                    ),
                    onTap: () {
                      widget.stopcall();
                    },
                  ),

                  SizedBox(width: 20),
                  GestureDetector(
                    child: !switchMute 
                        ? SvgPicture.asset('assets/mute_microphone.svg')
                        : SvgPicture.asset('assets/microphone.svg'),
                    onTap: () {
                      final bool enabled = signalingClient.muteMic();
                      print("this is enabled $enabled");
                      setState(() {
                        switchMute   = enabled;
                      });
                    },
                  ),
                ],
              ),
            )
          ]),
        );
      }),
    ));
  }
}