import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutterm2m/constant.dart';
// import 'package:flutterm2m/src/common/dragable.dart';
// import 'package:flutterm2m/src/core/providers/call_provider.dart';
// import 'package:flutterm2m/src/core/providers/contact_provider.dart';
// import 'package:flutterm2m/src/home/home.dart';
// import 'package:flutterm2m/src/home/streams/remoteStream.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vdotok_stream_example/constant.dart';
import 'package:vdotok_stream_example/src/common/dragable.dart';
import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream_example/src/home/home.dart';
import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';

// import 'package:vdotok_stream_example/constant.dart';
// import 'package:vdotok_stream_example/src/common/dragable.dart';
// import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
// import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
// import 'package:vdotok_stream_example/src/home/home.dart';
// import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';

CallProvider? callProvider;

class CallSttartScreen extends StatefulWidget {
  String? mediatype;
  var registerRes;
  final callprovider;
  // final AudioVideoSates;
  // List<Map<String, dynamic>> rendererListWithRefid = [];
  String? incomingfrom;
  ContactProvider? contactprovider;
  bool onRemotestream;
  String? callto;
  String pressduration;

  final stopcall;
  final enableCam;
  final muteMic;
  final switchCam;

  final switchSpeaker;
  CallSttartScreen(
      {this.mediatype,
      this.registerRes,
      // required this.rendererListWithRefid,
      // required this.AudioVideoSates,
      this.incomingfrom,
      this.contactprovider,
      required this.onRemotestream,
      this.callto,
      required this.muteMic,
      required this.switchCam,
      required this.switchSpeaker,
      required this.enableCam,
      required this.pressduration,
      this.stopcall,
      this.callprovider});

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
  void initState() {
    // TODO: implement initState

    callProvider = Provider.of<CallProvider>(context, listen: false);
    print('-----localState----${localAudioVideoStates}');
    // print('((((( ${widget.onRemotestream}');
    // print('((((( session List ${sessionList.values.toList().length}');
    // print('((((( session List2 ${sessionList.values.toList()[0].to}');
    // print(
    // 'thi is refID--${widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == "114ALUJ5ef077b3581c20700b18d483a8b274faa")}');
    // print('thi is refID--2${sessionList.values.toList()[0].to}');
    // ref_id: 114ALUJ5208a594e7cab1be19d0a334d2c76b648

    // print('')
    // widget.switchCam.initialize();
    // print(
    //     'this is sessionList=== ${sessionList.values.toList().remoteRenderer}');
    // print('boolRemoteStream== ${widget.onRemotestream}');
    // print('-----${sessionList.values.toList().length}');
    // print('--------${sessionList.values.toList()[1].remoteRenderer}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("this is lengthhhhhhhhh ${sessionList} ");
    print('this is presdu ${widget.pressduration}');
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Consumer<CallProvider>(
            builder: (context, callprovider, child) {
              return OrientationBuilder(builder: (context, orientation) {
                return Container(
                  child: Stack(children: <Widget>[
                    widget.onRemotestream
                        ? sessionList!.isEmpty
                            ? Container()
                            : sessionList!.length == 0
                                ? Container(
                                    // child: RemoteStream(
                                    //   remoteRenderer: sessionList.values
                                    //       .toList()[0]
                                    //       .remoteRenderer,
                                    // ),
                                    // decoration: BoxDecoration(
                                    //     color: backgroundAudioCallLight),
                                    // child: Center(
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       // SvgPicture.asset(
                                    //       //   'assets/userIconCall.svg',
                                    //       // ),
                                    //       // Text(widget
                                    //       //     .contactprovider!
                                    //       //     .contactList
                                    //       //     .users![widget.contactprovider!
                                    //       //         .contactList.users!
                                    //       //         .indexWhere((element) =>
                                    //       //             element!.ref_id ==
                                    //       //             sessionList.values
                                    //       //                 .toList()[0]
                                    //       //                 .from)]!
                                    //       //     .full_name)
                                    //     ],
                                    //   ),
                                    // ),
                                    )
                                : sessionList.length == 1
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: backgroundAudioCallLight),
                                        child: sessionList[0]
                                                        .values
                                                        .toList()[0]
                                                        .mediaType !=
                                                    "audio" &&
                                                sessionList[0]
                                                        .values
                                                        .toList()[0]
                                                        .remoteRenderer
                                                        .srcObject !=
                                                    null
                                            ? RemoteStream(
                                                remoteRenderer: sessionList[0]
                                                    .values
                                                    .toList()[0]
                                                    .remoteRenderer,
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/userIconCall.svg',
                                                    ),
                                                    widget.contactprovider!.contactList.users!.indexWhere((element) =>
                                                                element!
                                                                    .ref_id ==
                                                                sessionList[0]
                                                                    .values
                                                                    .toList()[0]
                                                                    .to[0]) ==
                                                            -1
                                                        ? Text(
                                                            '${sessionList[0].values.toList()[0].to[0]}')
                                                        : Text(widget
                                                            .contactprovider!
                                                            .contactList
                                                            .users![widget
                                                                .contactprovider!
                                                                .contactList
                                                                .users!
                                                                .indexWhere((element) =>
                                                                    element!
                                                                        .ref_id ==
                                                                    sessionList[0]
                                                                        .values
                                                                        .toList()[
                                                                            0]
                                                                        .to[0])]!
                                                            .full_name)
                                                  ],
                                                ),
                                              ),
                                      )
                                    // : RemoteStream(
                                    //     remoteRenderer:
                                    //         widget.rendererListWithRefid[1]
                                    //             ["rtcVideoRenderer"],
                                    //   )
                                    : sessionList.length == 2
                                        ? Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  // color: Colors.yellow,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: // if video is off then show white screen
                                                      sessionList[0]
                                                                      .values
                                                                      .toList()[
                                                                          0]
                                                                      .mediaType !=
                                                                  "audio" &&
                                                              sessionList[0]
                                                                      .values
                                                                      .toList()[
                                                                          0]
                                                                      .remoteRenderer
                                                                      .srcObject !=
                                                                  null
                                                          ? RemoteStream(
                                                              remoteRenderer:
                                                                  sessionList[0]
                                                                      .values
                                                                      .toList()[
                                                                          0]
                                                                      .remoteRenderer,
                                                            )
                                                          : Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    'assets/userIconCall.svg',
                                                                  ),
                                                                  widget.contactprovider!.contactList.users!.indexWhere((element) =>
                                                                              element!.ref_id ==
                                                                              sessionList[0].values.toList()[0].to[
                                                                                  0]) ==
                                                                          -1
                                                                      ? Text(
                                                                          '${sessionList[0].values.toList()[0].to[0]}')
                                                                      : Text(widget
                                                                          .contactprovider!
                                                                          .contactList
                                                                          .users![widget
                                                                              .contactprovider!
                                                                              .contactList
                                                                              .users!
                                                                              .indexWhere((element) => element!.ref_id == sessionList[0].values.toList()[0].to[0])]!
                                                                          .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                // color: Colors.green,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: // if video is off then show white screen
                                                    sessionList[1]
                                                                    .values
                                                                    .toList()[0]
                                                                    .mediaType !=
                                                                "audio" &&
                                                            sessionList[1]
                                                                    .values
                                                                    .toList()[0]
                                                                    .remoteRenderer
                                                                    .srcObject !=
                                                                null
                                                        ? RemoteStream(
                                                            remoteRenderer:
                                                                sessionList[1]
                                                                    .values
                                                                    .toList()[0]
                                                                    .remoteRenderer,
                                                          )
                                                        : Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/userIconCall.svg',
                                                                ),
                                                                widget.contactprovider!.contactList.users!.indexWhere((element) =>
                                                                            element!.ref_id ==
                                                                            sessionList[1].values.toList()[0].to[
                                                                                0]) ==
                                                                        -1
                                                                    ? Text(
                                                                        '${sessionList[1].values.toList()[0].to[0]}')
                                                                    : Text(widget
                                                                        .contactprovider!
                                                                        .contactList
                                                                        .users![widget
                                                                            .contactprovider!
                                                                            .contactList
                                                                            .users!
                                                                            .indexWhere((element) =>
                                                                                element!.ref_id ==
                                                                                sessionList[1].values.toList()[0].to[0])]!
                                                                        .full_name)
                                                              ],
                                                            ),
                                                          ),
                                              ))
                                            ],
                                          )
                                        : sessionList.length == 3
                                            ? Column(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          // color: Colors.yellow,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          child: // if video is off then show white screen
                                                              sessionList[0].values.toList()[0].mediaType !=
                                                                          "audio" &&
                                                                      sessionList[0]
                                                                              .values
                                                                              .toList()[0]
                                                                              .remoteRenderer
                                                                              .srcObject !=
                                                                          null
                                                                  ? RemoteStream(
                                                                      remoteRenderer: sessionList[
                                                                              0]
                                                                          .values
                                                                          .toList()[
                                                                              0]
                                                                          .remoteRenderer,
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            'assets/userIconCall.svg',
                                                                          ),
                                                                          widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[0].values.toList()[0].to[0]) == -1
                                                                              ? Text('${sessionList[0].values.toList()[0].to[0]}')
                                                                              : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[0].values.toList()[0].to[0])]!.full_name)
                                                                        ],
                                                                      ),
                                                                    ),
                                                        ),
                                                        Container(
                                                          // color: Colors.yellow,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          child: // if video is off then show white screen
                                                              sessionList[1].values.toList()[0].mediaType !=
                                                                          "audio" &&
                                                                      sessionList[1]
                                                                              .values
                                                                              .toList()[0]
                                                                              .remoteRenderer
                                                                              .srcObject !=
                                                                          null
                                                                  ? RemoteStream(
                                                                      remoteRenderer: sessionList[
                                                                              1]
                                                                          .values
                                                                          .toList()[
                                                                              0]
                                                                          .remoteRenderer,
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            'assets/userIconCall.svg',
                                                                          ),
                                                                          widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[1].values.toList()[0].to[0]) == -1
                                                                              ? Text('${sessionList[1].values.toList()[0].to[0]}')
                                                                              : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[1].values.toList()[0].to[0])]!.full_name)
                                                                        ],
                                                                      ),
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // color: Colors.green,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: // if video is off then show white screen
                                                          sessionList[2]
                                                                          .values
                                                                          .toList()[
                                                                              0]
                                                                          .mediaType !=
                                                                      "audio" &&
                                                                  sessionList[2]
                                                                          .values
                                                                          .toList()[
                                                                              0]
                                                                          .remoteRenderer
                                                                          .srcObject !=
                                                                      null
                                                              ? RemoteStream(
                                                                  remoteRenderer:
                                                                      sessionList[
                                                                              2]
                                                                          .values
                                                                          .toList()[
                                                                              0]
                                                                          .remoteRenderer,
                                                                )
                                                              : Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        'assets/userIconCall.svg',
                                                                      ),
                                                                      widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[2].values.toList()[0].to[0]) ==
                                                                              -1
                                                                          ? Text(
                                                                              '${sessionList[2].values.toList()[0].to[0]}')
                                                                          : Text(widget
                                                                              .contactprovider!
                                                                              .contactList
                                                                              .users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[2].values.toList()[0].to[0])]!
                                                                              .full_name)
                                                                    ],
                                                                  ),
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          child: // if video is off then show white screen
                                                              Container(
                                                            // color: Colors.yellow,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                            child: // if video is off then show white screen
                                                                sessionList[0].values.toList()[0].mediaType !=
                                                                            "audio" &&
                                                                        sessionList[0].values.toList()[0].remoteRenderer.srcObject !=
                                                                            null
                                                                    ? RemoteStream(
                                                                        remoteRenderer: sessionList[0]
                                                                            .values
                                                                            .toList()[0]
                                                                            .remoteRenderer,
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              'assets/userIconCall.svg',
                                                                            ),
                                                                            widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[0].values.toList()[0].to[0]) == -1
                                                                                ? Text('${sessionList[0].values.toList()[0].to[0]}')
                                                                                : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[0].values.toList()[0].to[0])]!.full_name)
                                                                          ],
                                                                        ),
                                                                      ),
                                                          ),
                                                        ),
                                                        // widget.rendererListWithRefid[
                                                        //                 1][
                                                        //             "remoteVideoFlag"] ==
                                                        //         0
                                                        // ? Container(
                                                        //     decoration:
                                                        //         BoxDecoration(
                                                        //             color:
                                                        //                 backgroundAudioCallLight),
                                                        //     child:
                                                        //         Center(
                                                        //       child:
                                                        //           Column(
                                                        //         mainAxisAlignment:
                                                        //             MainAxisAlignment.center,
                                                        //         children: [
                                                        //           SvgPicture
                                                        //               .asset(
                                                        //             'assets/userIconCall.svg',
                                                        //           ),
                                                        //           Text(widget
                                                        //               .contactprovider!
                                                        //               .contactList
                                                        //               .users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == widget.rendererListWithRefid[1]["refID"])]!
                                                        //               .full_name)
                                                        //         ],
                                                        //       ),
                                                        //     ),
                                                        //   )
                                                        // : RemoteStream(
                                                        //     remoteRenderer:
                                                        //         widget.rendererListWithRefid[1]
                                                        //             [
                                                        //             "rtcVideoRenderer"],
                                                        //   )
                                                        //   ),
                                                        Container(
                                                            // color: Colors.yellow,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                            child: // if video is off then show white screen
                                                                Container(
                                                              // color: Colors.yellow,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  2,
                                                              child: // if video is off then show white screen
                                                                  sessionList[1].values.toList()[0].mediaType !=
                                                                              "audio" &&
                                                                          sessionList[1].values.toList()[0].remoteRenderer.srcObject !=
                                                                              null
                                                                      ? RemoteStream(
                                                                          remoteRenderer: sessionList[1]
                                                                              .values
                                                                              .toList()[0]
                                                                              .remoteRenderer,
                                                                        )
                                                                      : Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                'assets/userIconCall.svg',
                                                                              ),
                                                                              widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[1].values.toList()[0].to[0]) == -1 ? Text('${sessionList[1].values.toList()[0].to[0]}') : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[1].values.toList()[0].to[0])]!.full_name)
                                                                            ],
                                                                          ),
                                                                        ),
                                                            )
                                                            // widget.rendererListWithRefid[
                                                            //                 2][
                                                            //             "remoteVideoFlag"] ==
                                                            //         0
                                                            //     ? Container(
                                                            //         decoration:
                                                            //             BoxDecoration(
                                                            //                 color:
                                                            //                     backgroundAudioCallLight),
                                                            //         child: Center(
                                                            //           child:
                                                            //               Column(
                                                            //             mainAxisAlignment:
                                                            //                 MainAxisAlignment
                                                            //                     .center,
                                                            //             children: [
                                                            //               SvgPicture
                                                            //                   .asset(
                                                            //                 'assets/userIconCall.svg',
                                                            //               ),
                                                            //               Text(widget
                                                            //                   .contactprovider!
                                                            //                   .contactList
                                                            //                   .users![widget.contactprovider!.contactList.users!.indexWhere((element) =>
                                                            //                       element!.ref_id ==
                                                            //                       widget.rendererListWithRefid[2]["refID"])]!
                                                            //                   .full_name)
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       )
                                                            //     : RemoteStream(
                                                            //         remoteRenderer:
                                                            //             widget.rendererListWithRefid[
                                                            //                     2]
                                                            //                 [
                                                            //                 "rtcVideoRenderer"],
                                                            //       ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          // color: Colors.yellow,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          child: // if video is off then show white screen
                                                              Container(
                                                            // color: Colors.yellow,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                            child: // if video is off then show white screen
                                                                sessionList[2].values.toList()[0].mediaType !=
                                                                            "audio" &&
                                                                        sessionList[2].values.toList()[0].remoteRenderer.srcObject !=
                                                                            null
                                                                    ? RemoteStream(
                                                                        remoteRenderer: sessionList[2]
                                                                            .values
                                                                            .toList()[0]
                                                                            .remoteRenderer,
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              'assets/userIconCall.svg',
                                                                            ),
                                                                            widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[2].values.toList()[0].to[0]) == -1
                                                                                ? Text('${sessionList[2].values.toList()[0].to[0]}')
                                                                                : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[2].values.toList()[0].to[0])]!.full_name)
                                                                          ],
                                                                        ),
                                                                      ),
                                                          ),
                                                          // widget.rendererListWithRefid[
                                                          //                 3][
                                                          //             "remoteVideoFlag"] ==
                                                          //         0
                                                          //     ? Container(
                                                          //         decoration:
                                                          //             BoxDecoration(
                                                          //                 color:
                                                          //                     backgroundAudioCallLight),
                                                          //         child:
                                                          //             Center(
                                                          //           child:
                                                          //               Column(
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment.center,
                                                          //             children: [
                                                          //               SvgPicture
                                                          //                   .asset(
                                                          //                 'assets/userIconCall.svg',
                                                          //               ),
                                                          //               Text(widget
                                                          //                   .contactprovider!
                                                          //                   .contactList
                                                          //                   .users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == widget.rendererListWithRefid[3]["refID"])]!
                                                          //                   .full_name)
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       )
                                                          //     : RemoteStream(
                                                          //         remoteRenderer:
                                                          //             widget.rendererListWithRefid[3]
                                                          //                 [
                                                          //                 "rtcVideoRenderer"],
                                                          //       )
                                                        ),
                                                        Container(
                                                          // color: Colors.yellow,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          child: // if video is off then show white screen
                                                              Container(
                                                            // color: Colors.yellow,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                            child: // if video is off then show white screen
                                                                sessionList[3].values.toList()[0].mediaType !=
                                                                            "audio" &&
                                                                        sessionList[3].values.toList()[0].remoteRenderer.srcObject !=
                                                                            null
                                                                    ? RemoteStream(
                                                                        remoteRenderer: sessionList[3]
                                                                            .values
                                                                            .toList()[0]
                                                                            .remoteRenderer,
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              'assets/userIconCall.svg',
                                                                            ),
                                                                            widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[3].values.toList()[0].to[0]) == -1
                                                                                ? Text('${sessionList[3].values.toList()[0].to[0]}')
                                                                                : Text(widget.contactprovider!.contactList.users![widget.contactprovider!.contactList.users!.indexWhere((element) => element!.ref_id == sessionList[3].values.toList()[0].to[0])]!.full_name)
                                                                          ],
                                                                        ),
                                                                      ),
                                                          ),
                                                          // widget.rendererListWithRefid[
                                                          //                 4][
                                                          //             "remoteVideoFlag"] ==
                                                          //         0
                                                          //     ? Container(
                                                          //         decoration:
                                                          //             BoxDecoration(
                                                          //                 color:
                                                          //                     backgroundAudioCallLight),
                                                          //         child: Center(
                                                          //           child:
                                                          //               Column(
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment
                                                          //                     .center,
                                                          //             children: [
                                                          //               SvgPicture
                                                          //                   .asset(
                                                          //                 'assets/userIconCall.svg',
                                                          //               ),
                                                          //               Text(widget
                                                          //                   .contactprovider!
                                                          //                   .contactList
                                                          //                   .users![widget.contactprovider!.contactList.users!.indexWhere((element) =>
                                                          //                       element!.ref_id ==
                                                          //                       widget.rendererListWithRefid[4]["refID"])]!
                                                          //                   .full_name)
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       )
                                                          //     : RemoteStream(
                                                          //         remoteRenderer:
                                                          //             widget.rendererListWithRefid[
                                                          //                     4]
                                                          //                 [
                                                          //                 "rtcVideoRenderer"],
                                                          //       ),
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
                            (widget.mediatype == MediaType.video)
                                ? 'You are video calling with'
                                : 'You are audio calling with',
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
                                Container(
                                  // padding: EdgeInsets.only(top: 85, left: 50),
                                  child: Text(
                                    '$groupName',
                                    //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        decoration: TextDecoration.none,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        color: darkBlackColor),
                                  ),
                                ),
                                SizedBox(width: 20),
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
                                // height: MediaQuery.of(context).size.height,
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
                                          print(
                                              'this is switch CAmerrrraaaa=====');
                                          widget.switchCam();
                                          print(
                                              'this is switch CAmerrrraaaa=====');
                                          // callprovider.switchCamera();
                                          // signalingClient.switchCamera();
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        child: localAudioVideoStates[
                                                "SpeakerState"]!
                                            ? SvgPicture.asset(
                                                'assets/VolumnOn.svg')
                                            : SvgPicture.asset(
                                                'assets/VolumeOff.svg'),
                                        onTap: () {
                                          widget.switchSpeaker();
                                          // callprovider.switchSpeaker();
                                          // signalingClient
                                          //     .switchSpeaker(switchSpeaker);
                                          // setState(() {
                                          //   switchSpeaker = !switchSpeaker;
                                          // });
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
                                          child: localAudioVideoStates[
                                                  "SpeakerState"]!
                                              ? SvgPicture.asset(
                                                  'assets/VolumnOn.svg')
                                              : SvgPicture.asset(
                                                  'assets/VolumeOff.svg'),
                                          onTap: () {
                                            widget.switchSpeaker();
                                            // callprovider.switchSpeaker();
                                            // signalingClient
                                            //     .switchSpeaker(switchSpeaker);
                                            // setState(() {
                                            //   switchSpeaker = !switchSpeaker;
                                            // });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : SizedBox(),
                    !kIsWeb
                        ? widget.mediatype == MediaType.video
                            ? DragBox()
                            : Container()
                        : Positioned(
                            left: 225,
                            bottom: 145,
                            right: 20,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: enableCamera
                                      ? localRenderer != null
                                          ? RemoteStream(
                                              remoteRenderer: localRenderer!
                                              // widget.rendererListWithRefid[0]
                                              //     ["rtcVideoRenderer"],
                                              )
                                          : Container()
                                      : Container(),
                                ),
                              ),
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
                          widget.mediatype == MediaType.video
                              ? Row(
                                  children: [
                                    GestureDetector(
                                      child: localAudioVideoStates[
                                              "CameraState"]!
                                          ? SvgPicture.asset('assets/video.svg')
                                          : SvgPicture.asset(
                                              'assets/video_off.svg'),
                                      // !enableCamera
                                      //     ? SvgPicture.asset('assets/video_off.svg')
                                      //     : SvgPicture.asset('assets/video.svg'),
                                      onTap: () {
                                        widget.enableCam();
                                        // callprovider.enableCamera();
                                        // setState(() {
                                        //   enableCamera = !enableCamera;
                                        // });
                                        // widget.enableCam();
                                        // signalingClient.audioVideoState(
                                        //     audioFlag: switchMute ? 1 : 0,
                                        //     videoFlag: enableCamera ? 1 : 0,
                                        //     mcToken: widget.registerRes["mcToken"]);
                                        // signalingClient.enableCamera(enableCamera);
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
                              print('onCallhangup--');
                              widget.stopcall();
                              // if (isConnected == false) {
                              //   setState(() {
                              //     noInternetCallHungUp = true;
                              //   });
                              //   // widget.callprovider.initial();
                              // } else {
                              //   widget.stopcall();
                              // }
                              // widget.callprovider.initial();
                            },
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            child: localAudioVideoStates["MuteState"]!
                                ? SvgPicture.asset('assets/microphone.svg')
                                : SvgPicture.asset(
                                    'assets/mute_microphone.svg'),
                            onTap: () {
                              print('Muting mic===============');
                              widget.muteMic();
                              print('Muting mic===============');
                              // callprovider.muteMic();
                              // muteMic();
                              // widget.muteMic();
                              // final bool enabled = signalingClient.muteMic();
                              // print("this is enabled $enabled");
                              // setState(() {
                              //   switchMute = !switchMute;
                              // });
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
                );
              });
            },
          ),
        ));
  }
}
