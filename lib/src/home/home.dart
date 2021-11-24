import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vdotok_stream_example/src/core/config/config.dart';
import 'package:vdotok_stream_example/src/home/noContactsScreen.dart';
import 'package:vdotok_stream_example/src/common/customAppBar.dart';
import 'package:vdotok_stream_example/src/core/models/GroupListModel.dart';
import 'package:vdotok_stream_example/src/core/models/GroupModel.dart';
import 'package:vdotok_stream_example/src/core/models/ParticipantsModel.dart';
import 'package:vdotok_stream_example/src/core/models/contact.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'package:vdotok_stream_example/src/home/streams/largStream.dart';
import 'package:vdotok_stream_example/src/home/streams/remoteStream.dart';
import 'package:vdotok_stream_example/src/home/CreateGroupPopUp.dart';
import 'package:vdotok_stream_example/src/home/noGroupYetScreen.dart';
import 'package:vdotok_stream_example/src/home/responsiveWidget.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'dart:io' show Platform;
import '../../constant.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';
import '../home/streams/remoteStream.dart';



class Home extends StatefulWidget {
  final state;
  Home({this.state});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool notmatched = false;
  bool groupnotmatched = false;
  List<Contact> _selectedContacts = [];
  bool isDeviceConnected = false;
  bool isdev = true;
  DateTime _time;
  Timer _ticker;
  String _pressDuration = "";
  DateTime _callTime;
  bool iscalloneto1 = false;
  bool inCall = false;
  bool isPushed = false;
  bool iscallReConnected = false;
  double upstream;
  double downstream;
  void _updateTimer() {
    var duration;

    duration = DateTime.now().difference(_time);

    final newDuration = _formatDuration(duration);

    print("TYHISSDDDDDDDDJFN $_callTime");
    setState(() {
      _pressDuration = newDuration;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (twoDigitHours == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    
  }

  SignalingClient signalingClient = SignalingClient.instance;
  RTCPeerConnection _peerConnection;
  RTCPeerConnection _answerPeerConnection;
  MediaStream _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  // RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  // RTCVideoRenderer _remoteRenderer2 = new RTCVideoRenderer();
  // RTCVideoRenderer _remoteRenderer3 = new RTCVideoRenderer();
  // RTCVideoRenderer _remoteRenderer4 = new RTCVideoRenderer();
  GlobalKey forsmallView = new GlobalKey();
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  String incomingfrom;
  // ContactBloc _contactBloc;
  // CallBloc _callBloc;
  // LoginBloc _loginBloc;
  CallProvider _callProvider;
  AuthProvider _auth;
  bool enableCamera = true;
  bool switchMute = true;
  bool switchSpeaker = true;
  bool secondRemoteVideo = false;
  String callTo = "";
  List _filteredList = [];
  var number;
  List _groupfilteredList = [];
  final _searchController = new TextEditingController();
  final _GroupListsearchController = new TextEditingController();
  bool sockett = true;
  bool isSocketregis = false;
  List<int> vibrationList = [
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000
  ];
  String meidaType = MediaType.video;
  bool remoteVideoFlag = true;
  bool remoteAudioFlag = true;
  bool onRemoteStream = false;
  ContactProvider _contactProvider;
  GroupListProvider _groupListProvider;
  final _groupNameController = TextEditingController();
  List<Map<String, dynamic>> rendererListWithRefID = [
    // {
    //   "i": "k",
    //   "j": "k",
    // },
    // {
    //   "i": "k",
    //   "j": "k",
    // }
  ];
  List<ParticipantsModel> callingTo;
  Map<String, dynamic> forLargStream = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initRenderers(_localRenderer);
    checkConnectivity();

    WidgetsBinding.instance.addObserver(this);
    _auth = Provider.of<AuthProvider>(context, listen: false);
    _contactProvider = Provider.of<ContactProvider>(context, listen: false);
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    _callProvider = Provider.of<CallProvider>(context, listen: false);

    _contactProvider.getContacts(_auth.getUser.auth_token);
    _groupListProvider.getGroupList(_auth.getUser.auth_token);

    signalingClient.connect(project_id, _auth.completeAddress);
    signalingClient.onConnect = (res) {
      print("onConnect $res");
      if (res == "connected") {
        sockett = true;
      }

      signalingClient.register(_auth.getUser.toJson(), project_id);
      // signalingClient.register(user);
    };
    signalingClient.onError = (code, res) {
      print("onConnect erorrrrrrbf $code $res");
      print("hey i am here");
      // _callProvider.initial();
      var snackBar;
      if (code == 1002 || code == 1001) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
        isdev = false;
        //  snackBar = SnackBar(content: Text("Socket Disconnected"));
      } else {
        print("ffgfffff $res");
        // snackBar = SnackBar(content: Text(res));
      }
      if (code == 1005) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
        isdev = false;
      }

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // setState(() {
      //   // _localRenderer.srcObject = null;
      //   // _remoteRenderer.srcObject = null;
      //   // _remoteRenderer2.srcObject = null;
      //   // _remoteRenderer3.srcObject = null;
      //   // _remoteRenderer4.srcObject = null;
      // });
      // signalingClient.register(user);
    };
    signalingClient.onRegister = (res) {
      print("onRegister  $res");
      setState(() {
        registerRes = res;
      });
      // signalingClient.register(user);
    };
    Map<String, dynamic> temp = {
      "refID": _auth.getUser.ref_id,
      "rtcVideoRenderer": new RTCVideoRenderer(),
      "remoteVideoFlag": 1,
      "remoteAudioFlag": 1
    };

    initRenderers(temp["rtcVideoRenderer"]);
    setState(() {
      rendererListWithRefID.add(temp);
    });

    signalingClient.onLocalStream = (stream) {
      print("call callback on call local stream");

      setState(() {
        rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
      });
    };

    signalingClient.onRemoteStream = (stream, refid) async {
     print("here on else existing participant new peer connection1");

      print("call callback on call remote Stream ${stream.id}");
      print(
            "this is on remote stream BEFORE ADD${rendererListWithRefID.length}");

      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };

       initRenderers(temp["rtcVideoRenderer"]).then((value) 
       {
          temp["rtcVideoRenderer"].srcObject = stream;
      setState(() {
        
        if (iscallReConnected == false) {
          print("this is  time in reconnected false $_time..... $_callTime");
          _time = DateTime.now();
          _callTime = DateTime.now();
        } else {
          print("this is  time in reconnected true $_time..... $_callTime");
          _time = _callTime;
          iscallReConnected = false;
        }
        //_time = DateTime.now();
        _updateTimer();
        _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
      });
      if (forLargStream.isEmpty) {
        setState(() {
          forLargStream = temp;
        });
      }
      setState(() {
        rendererListWithRefID.add(temp);
        forLargStream = temp;
        onRemoteStream = true;
      });
       print("in initialize function 1111122222");
      // setState(() {
      //   temp["rtcVideoRenderer"].srcObject = stream;
      //   if (iscallReConnected == false) {
      //     print("this is  time in reconnected false $_time..... $_callTime");
      //     _time = DateTime.now();
      //     _callTime = DateTime.now();
      //   } else {
      //     print("this is  time in reconnected true $_time..... $_callTime");
      //     _time = _callTime;
      //     iscallReConnected = false;
      //   }
      //   //_time = DateTime.now();
      //   _updateTimer();
      //   _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
      // });
      // if (forLargStream.isEmpty) {
      //   setState(() {
      //     forLargStream = temp;
      //   });
      // }
      // setState(() {
      //   print(
      //       "this is on remote stream BEFORE ADD${rendererListWithRefID.length}");
      //   rendererListWithRefID.add(temp);
      //   forLargStream = temp;
      //   onRemoteStream = true;
      // });
      // print(
      //     "this is on remote stream after ADD${rendererListWithRefID.length}");
       });
   
    };

    signalingClient.onReceiveCallFromUser =
        (receivefrom, type, isonetone) async {
      print("call callback on call Received incomming");

      startRinging();
      inCall = true;
      iscalloneto1 = isonetone;
      setState(() {
        onRemoteStream = false;
        _pressDuration = "";
        upstream = 0;
        downstream = 0;
        incomingfrom = receivefrom;
        meidaType = type;
        switchMute = true;
        enableCamera = true;
        switchSpeaker = type == MediaType.audio ? true : false;
        remoteVideoFlag = true;
        remoteAudioFlag = true;
      });
      //here
      // _callBloc.add(CallReceiveEvent());
      _callProvider.callReceive();
    };
    signalingClient.onParticipantsLeft = (refID) async {
      print("call callback on call left by participant");

      // on participants left
      if (refID == _auth.getUser.ref_id) {
      } else {
        int index = rendererListWithRefID
            .indexWhere((element) => element["refID"] == refID);

        setState(() {
          rendererListWithRefID.removeAt(index);
        });
      }
    };
    signalingClient.onCallAcceptedByUser = () async {
      print("call callback on call Accepted");
      inCall = true;
      //here
      // _callBloc.add(CallStartEvent());
      _callProvider.callStart();
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      print("call callback on call hungUpBy User");
      //_ticker.cancel();
      inCall = false;
      setState(() {
        _pressDuration = "";
        upstream = 0;
        downstream = 0;
      });
      //here
      // _callBloc.add(CallNewEvent());
      _callProvider.initial();
      disposeAllRenderer();

      stopRinging();
    };
    // signalingClient.onCallDeclineByYou = () {
    //   print("call callback on call decline");

    //   //here
    //   // _callBloc.add(CallNewEvent());
    //   _callProvider.initial();
    //   setState(() {
    //     // _localRenderer.srcObject = null;
    //     // _remoteRenderer.srcObject = null;
    //     // _remoteRenderer2.srcObject = null;
    //     // _remoteRenderer3.srcObject = null;
    //     // _remoteRenderer4.srcObject = null;
    //   });
    //   stopRinging();
    // };
    signalingClient.onCallBusyCallback = () {
      print("call callback on call busy");
      _callProvider.initial();
      final snackBar =
          SnackBar(content: Text('User is busy with another call.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        // _localRenderer.srcObject = null;
        // _remoteRenderer.srcObject = null;
        // _remoteRenderer2.srcObject = null;
        // _remoteRenderer3.srcObject = null;
        // _remoteRenderer4.srcObject = null;
      });
    };
    // signalingClient.onCallRejectedByUser = () {
    //   print("call callback on call Rejected");
    //   //here
    //   // _callBloc.add(CallNewEvent());
    //   stopRinging();
    //   _callProvider.initial();

    //   setState(() {
    //     // _localRenderer.srcObject = null;
    //     // _remoteRenderer.srcObject = null;
    //     // _remoteRenderer2.srcObject = null;
    //     // _remoteRenderer3.srcObject = null;
    //     // _remoteRenderer4.srcObject = null;
    //   });
    // };

    signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
      print("call callback on call audioVideo status $audioFlag, $videoFlag");
      int index = rendererListWithRefID
          .indexWhere((element) => element["refID"] == refID);
      print("this is index $index");
      setState(() {
        rendererListWithRefID[index]["remoteVideoFlag"] = videoFlag;
        rendererListWithRefID[index]["remoteAudioFlag"] = audioFlag;
      });
    };
  }

  void checkConnectivity() async {
    isDeviceConnected = false;
    if (!kIsWeb) {
      DataConnectionChecker().onStatusChange.listen((status) async {
        print("this on listener");
        isDeviceConnected = await DataConnectionChecker().hasConnection;
        print("this is is connected in $isDeviceConnected");
        if (isDeviceConnected == true) {
          setState(() {
            isdev = true;
          });
          // showSnackbar("Internet Connected", whiteColor, Colors.green, false);
        } else {
          setState(() {
            isdev = false;
          });
          // showSnackbar(
          //     "No Internet Connection", whiteColor, primaryColor, true);

        }
      });
    }
  }

  disposeAllRenderer() async {
    for (int i = 0; i < rendererListWithRefID.length; i++) {
      if (i == 0) {
        rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
      } else
        await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
    }
    print("this is after dispose all elements $rendererListWithRefID");
    // setState(() {
    if (rendererListWithRefID.length > 1) {
      print("yes i'm here ");
      rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));
    }
    // });

    print("this is after dispose all elements $rendererListWithRefID");
  }

  _startCall(
      GroupModel to, String mtype, String callType, String sessionType) async {
    setState(() {
      switchMute = true;
      _pressDuration = "";
      upstream = 0;
      downstream = 0;
      enableCamera = true;
      onRemoteStream = false;
      switchSpeaker = mtype == MediaType.audio ? true : false;
    });

    List<String> groupRefIDS = [];
    // participantsCalling = to.participants;
    to.participants.forEach((element) {
      if (_auth.getUser.ref_id != element.ref_id)
        groupRefIDS.add(element.ref_id.toString());
    });

    callingTo = to.participants;
    callingTo.removeWhere((element) => element.ref_id == _auth.getUser.ref_id);
    print("this is rendererList $rendererListWithRefID");

    rendererListWithRefID.first["remoteVideoFlag"] =
        mtype == MediaType.video ? 1 : 0;
    // groupRefIDS.add("bba0bcc3174e200139f9881538ff208d");
    print("this is list ${groupRefIDS}");
    print("this is call type in home $callType");
    signalingClient.startCall(
        from: _auth.getUser.ref_id,
        to: groupRefIDS,
        // to: [
        //   "d4852b644614854af2707f1f3f43f726",
        //   "e74573df8a062cb4d5a0a8a9aa143cb3"
        // ],
        mcToken: registerRes["mcToken"],
        meidaType: mtype,
        callType: callType,
        sessionType: sessionType);
    // Map<String, dynamic> temp = {
    //   "refID": _auth.getUser.ref_id,
    //   "rtcVideoRenderer": new RTCVideoRenderer()
    // };
    // await initRenderers(temp["rtcVideoRenderer"]);
    // Navigator.pushNamedAndRemoveUntil(context, "/call", (route) => false,
    //     arguments: {"to": callingTo, "mediaType": mtype, "rtcRenderer": temp});
    _callProvider.callDial();
  }

Future<void> initRenderers(RTCVideoRenderer rtcRenderer) async {
    await rtcRenderer.initialize();
    print("in initialize function");
  }

  startRinging() async {
    if (Platform.isAndroid) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: vibrationList);
      }
    }
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
  }

  stopRinging() {
    print("this is on rejected ");
    // startRinging();
    vibrationList.clear();
    // });
    Vibration.cancel();
    FlutterRingtonePlayer.stop();

    // setState(() {
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("this is state of App change $state");
    if (state == AppLifecycleState.detached) {
      // if app swipe killed from background
      signalingClient.unRegister(registerRes["mcToken"]);
    } else if (state == AppLifecycleState.inactive) {
      // if app go to background
    } else if (state == AppLifecycleState.paused) {
      // if app in background and app go to in paused State
    } else if (state == AppLifecycleState.resumed) {
      // if app open from background
    }
  }
  
  @override
  dispose() {
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
    // _remoteRenderer2.dispose();
    // _remoteRenderer3.dispose();
    // _remoteRenderer4.dispose();
    _ticker.cancel();
    // FlutterRingtonePlayer.stop();
    // Vibration.cancel();
    // sdpController.dispose();
    super.dispose();
  }

  Future<Null> refreshList() async {
    renderList();
    // rendersubscribe();

    return;
  }

  renderList() {
    if (_groupListProvider.groupListStatus == ListStatus.Scussess)
      _groupListProvider.getGroupList(_auth.getUser.auth_token);
    else {
      _contactProvider.getContacts(_auth.getUser.auth_token);
      _selectedContacts.clear();
    }
  }
 showSnakbar(msg) {
      final snackBar = SnackBar(
        content: Text(
          "$msg",
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

  stopCall() {
    signalingClient.stopCall(registerRes["mcToken"]);
    //here
    // _callBloc.add(CallNewEvent());
    isPushed = false;
    _ticker.cancel();
    setState(() {
      _pressDuration = "";
      upstream = 0;
      downstream = 0;
    });
    _callProvider.initial();
    inCall = false;
    disposeAllRenderer();
    if (!kIsWeb) stopRinging();
  }
void _showDialogDeletegroup(group_id, index) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  //title: Text('Alert Dialog Example'),
                  content:
                      Text('Are you sure you want to delete this chatroom?'),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('CANCEL',
                                style: TextStyle(color: chatRoomColor))),
                        // Consumer2<GroupListProvider, AuthProvider>(builder:
                        //     (context, listProvider, authProvider, child) {
                        //   return
                        FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _groupListProvider.deleteGroup(
                                group_id,
                                _auth.getUser.auth_token,
                              );
                              // (groupListProvider.deleteGroupStatus ==
                              //         DeleteGroupStatus.Loading)
                              //     ? SplashScreen():

                              if (_groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Success) {
                                // groupListProvider.groupList.groups.

                                showSnakbar(_groupListProvider.successMsg);
                              } else if (_groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Failure) {
                                showSnakbar(_groupListProvider.errorMsg);
                              } else {}
                              // if (groupListProvider.status == 200) {
                              //   print(
                              //       "this is status ${groupListProvider.status}");
                              //   groupListProvider.getGroupList(
                              //       authProvider.getUser.auth_token);
                              // }
                            },
                            child: Text('DELETE',
                                style: TextStyle(color: chatRoomColor)))
                        //;
                        // }),
                      ],
                    )
                  ],
                );
              });
        }
  void _showDialog() {
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: ResponsiveWidget.isSmallHeight(context)
                  ? EdgeInsets.only(bottom: 10, right: 30)
                  : EdgeInsets.only(bottom: 40, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          elevation: 10,
                          actions: <Widget>[
                            ///Create Group alert dialogue box

                            Container(
                                height: 170,
                                width: 419,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                              // width:201,
                                              margin: EdgeInsets.only(
                                                  left: 24,
                                                  top: 25,
                                                  bottom: 20),
                                              child: Text(
                                                "Add Attachment",
                                                style: TextStyle(
                                                  color: createGroupColor2,
                                                  fontSize: 14,
                                                  fontFamily: searchFontFamily,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 54,
                                            top: 25,
                                          ),
                                          width: 30,
                                          height: 30,
                                          child: IconButton(
                                            icon: SvgPicture.asset(
                                                'assets/close.svg'),
                                            onPressed: () {
                                              print("close icon pressed");
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/File.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "File",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/Camera.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "Camera",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/Album.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "Album",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/Audio.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "Audio",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/Map.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "Loction",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4),
                                              width: 56,
                                              height: 56,
                                              decoration: new BoxDecoration(
                                                color: textfieldhint,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: SvgPicture.asset(
                                                    'assets/User.svg'),
                                                onPressed: () {
                                                  print("close icon pressed");
                                                },
                                              ),
                                            ),
                                            Text(
                                              "Contact",
                                              style: TextStyle(
                                                color: attachmentNameColor,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ]),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  backHandler() {
    setState(() {
      print("here in back handler set state");
      _selectedContacts = [];
      _groupListProvider.handleGroupListState(ListStatus.Scussess);
      _groupNameController.clear();
    });
  }

  handleGroupState() {
    _groupListProvider.handleGroupListState(ListStatus.CreateGroup);
  }

  handleCreateGroup(ListStatus state) {
    if (state == ListStatus.CreateGroup) {
      if (_selectedContacts.length == 0)
        buildShowDialog(
            context, "Please Select At least one contact to proceed!!!");
      else if (_selectedContacts.length <= 4) {
        print("Here in greater than 1");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateGroupPopUp(
                  editGroupName: false,
                  backHandler: backHandler,
                  groupNameController: _groupNameController,
                  selectedContacts: _selectedContacts,
                  authProvider: _auth);
            });
      } else {
        buildShowDialog(context, "Maximum limit is 4!!!");
      }
    } else
      handleGroupState();
  }

  Future buildShowDialog(BuildContext context, String errorMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
                title: Center(
                    child: Text(
                  "Error Message",
                  style: TextStyle(color: counterColor),
                )),
                content: Text("$errorMessage"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 0,
                actions: <Widget>[
                  Container(
                    height: 50,
                    width: 319,
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    signalingClient.onCallStatsuploads = (uploadstats) {
      var nummm = uploadstats;
      String dddi = nummm.toString();
      print("DFKMDKSDF//MNKSDFMDKS 0000000$dddi");

      double myDouble = double.parse(dddi);
      assert(myDouble is double);

      print("dfddfdfdfffffffffffffffff ${myDouble / 1024}"); // 123.45
      upstream = double.parse((myDouble / 1024).toStringAsFixed(2));
    };
    signalingClient.onCallstats = (timeStatsdownloads, timeStatsuploads) {
      //setState(() {
      print("NOT NULL  $timeStatsdownloads");
      // double d2=double.valueOf(timeStatsdownloads);
      number = timeStatsdownloads;
      String ddd = number.toString();
      print("DFKMDKSDFMNKSDFMDKS $ddd");

      double myDouble = double.parse(ddd);
      assert(myDouble is double);

      print("dfddfdfdf ${myDouble / 1024}"); // 123.45
      downstream = double.parse((myDouble / 1024).toStringAsFixed(2));
    };

    print("This is widget state $_pressDuration");

    if (isdev == true && sockett == false) {
      print("i am here in widget build");

      if (inCall == true) {
        iscallReConnected = true;
      }
      if (isSocketregis == false) {
        isSocketregis = true;
        print(
            "this iscall time $_callTime..... and press duration $_pressDuration");
        //  _callTime=_pressDuration;
        print("IN WIODGET TRUE AND SOCKET FALSE");

        signalingClient.connect(project_id, _auth.completeAddress);

        // if (inCall == true) {
        print("I am in Re Reregister");

        // signalingClient.onConnect = (res) {
        //   print("onConnect in widget $res");

        //   if (res == "connected") {
        //     sockett = true;
        //   }

        signalingClient.register(_auth.getUser.toJson(), project_id);
        // };
        //  }

        isPushed = false;

        signalingClient.onRegister = (res) {
          print("onRegister after reconnection $res");

          setState(() {
            registerRes = res;
          });

// signalingClient.register(user);
        };
      }

// signalingClient.reRegister(authProvider.getUser.toJson(), project_id);

// }

    }

    if (!ResponsiveWidget.isSmallScreen(context))
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: logoBckgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    width: 40,
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      signalingClient.unRegister(registerRes["mcToken"]);
                      _auth.logout();
                    },
                    child: Row(
                      children: <Widget>[
                        // SvgPicture.asset('assets/logo.svg'),

                        Text(
                          'Logout ${_auth.getUser.full_name}',
                          style: TextStyle(
                            color: attachmentNameColor,
                            fontSize: 14,
                            fontFamily: primaryFontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Consumer<GroupListProvider>(
            builder: (context, groupListProvid, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: ResponsiveWidget.isSmallScreen(context)
                            ? const EdgeInsets.only(
                                right: 0,
                                bottom: 10,
                              )
                            : const EdgeInsets.only(
                                bottom: 20,
                              ),
                        color: logoBckgroundColor,
                        child: Row(
                          children: [
                            //left Section
                            groupListProvid.groupListStatus ==
                                    ListStatus.CreateGroup
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                    ),
                                    height:
                                        ResponsiveWidget.isSmallHeight(context)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height +
                                                1000
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height +
                                                1,
                                    width:
                                        ResponsiveWidget.isSmallScreen(context)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                125
                                            : 370,
                                    margin: const EdgeInsets.only(right: 34),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      _groupListProvider
                                                          .handleGroupListState(
                                                              ListStatus
                                                                  .Scussess);
                                                    },
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color: chatRoomwebColor,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Create Group",
                                                          style: TextStyle(
                                                            color:
                                                                chatRoomwebColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                primaryFontFamily,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "CREATE",
                                                        style: TextStyle(
                                                          color:
                                                              chatRoomwebColor,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              primaryFontFamily,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: SvgPicture.asset(
                                                        'assets/checkmark.svg'),
                                                    onPressed: _selectedContacts
                                                                .length ==
                                                            0
                                                        ? () async {
                                                            buildShowDialog(
                                                                context,
                                                                "Please Select At least one contact to proceed!!!");
                                                            // var groupName =
                                                            //     _selectedContacts[0].full_name +
                                                            //         "-" +
                                                            //         authProvider.getUser.full_name;
                                                            // print("The Group Join: ${groupName}");
                                                            // var res = await contactProvider.createGroup(
                                                            //     groupName,
                                                            //     _selectedContacts,
                                                            //     authProvider.getUser.auth_token);
                                                            // // groupListProvider.getGroupList(
                                                            // //     authProvider.getUser.auth_token);
                                                            // GroupModel groupModel =
                                                            //     GroupModel.fromJson(res["group"]);
                                                            // // print(
                                                            // //     "this is response of createGroup ${groupModel.channel_key}, ${groupModel.channel_name}");

                                                            // groupListProvider.addGroup(groupModel);
                                                            // groupListProvider.subscribeChannel(
                                                            //     groupModel.channel_key,
                                                            //     groupModel.channel_name);
                                                            // groupListProvider.subscribePresence(
                                                            //     groupModel.channel_key,
                                                            //     groupModel.channel_name,
                                                            //     true,
                                                            //     true);

                                                            // Navigator.pop(context, true);
                                                            // Navigator.pop(context, true);
                                                          }
                                                        : _selectedContacts
                                                                    .length <=
                                                                4
                                                            ? () {
                                                                print(
                                                                    "Here in greater than 1");
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return ListenableProvider<
                                                                          GroupListProvider>.value(
                                                                        value:
                                                                            _groupListProvider,
                                                                        child: CreateGroupPopUp(
                                                                            editGroupName: false,
                                                                            backHandler: backHandler,
                                                                            groupNameController: _groupNameController,
                                                                            selectedContacts: _selectedContacts,
                                                                            // groupListProvider: groupListProvider,
                                                                            authProvider: _auth),
                                                                      );
                                                                    });
                                                              }
                                                            : () {
                                                                buildShowDialog(
                                                                    context,
                                                                    "Maximum limit is 4!!!");
                                                              },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: groupListProvid
                                                      .groupListStatus ==
                                                  ListStatus.CreateGroup
                                              ? Consumer<ContactProvider>(
                                                  builder: (context, contactp,
                                                      child) {
                                                    if (contactp.contactState ==
                                                        ContactStates.Loading)
                                                      return Center(
                                                        child: Container(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    chatRoomColor),
                                                          ),
                                                        ),
                                                      );
                                                    else if (contactp
                                                            .contactState ==
                                                        ContactStates.Success) {
                                                      if (contactp.contactList
                                                              .users.length ==
                                                          0)
                                                        return noContactFound(
                                                            context);
                                                      else
                                                        return contactList(
                                                            contactp);
                                                    } else
                                                      return Container(
                                                        child: Text(
                                                            "no contacts found"),
                                                      );
                                                  },
                                                )
                                              : Consumer<GroupListProvider>(
                                                  builder: (context, contact,
                                                      child) {
                                                    if (contact
                                                            .groupListStatus ==
                                                        ListStatus.Loading)
                                                      return Center(
                                                        child: Container(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    chatRoomColor),
                                                          ),
                                                        ),
                                                      );
                                                    else if (contact
                                                            .groupListStatus ==
                                                        ListStatus.Scussess) {
                                                      if (contact.groupList
                                                              .groups.length ==
                                                          0)
                                                        return noContactFound(
                                                            context);
                                                      else
                                                        return groupList(
                                                            contact.groupList);
                                                    } else
                                                      return Container(
                                                        child: Text(
                                                            "no contacts found"),
                                                      );
                                                  },
                                                ),
                                        )
                                      ],
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                    ),
                                    height: ResponsiveWidget
                                            .isSmallHeight(context)
                                        ? MediaQuery.of(context).size.height +
                                            1000
                                        : MediaQuery.of(context).size.height +
                                            1,
                                    width: ResponsiveWidget.isSmallScreen(
                                            context)
                                        ? MediaQuery.of(context).size.width -
                                            125
                                        : 370,
                                    margin: const EdgeInsets.only(right: 34),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Group List ",
                                                      style: TextStyle(
                                                        color: chatRoomwebColor,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            primaryFontFamily,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "CREATE",
                                                        style: TextStyle(
                                                          color:
                                                              chatRoomwebColor,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              primaryFontFamily,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          size: 24,
                                                          color: chatRoomColor,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            handleGroupState();
                                                          });
                                                          print(
                                                              "chat room add icon pressed");
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: groupListProvid
                                                      .groupListStatus ==
                                                  ListStatus.CreateGroup
                                              ? Consumer<ContactProvider>(
                                                  builder: (context, contactp,
                                                      child) {
                                                    if (contactp.contactState ==
                                                        ContactStates.Loading)
                                                      return Center(
                                                        child: Container(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    chatRoomColor),
                                                          ),
                                                        ),
                                                      );
                                                    else if (contactp
                                                            .contactState ==
                                                        ContactStates.Success) {
                                                      if (contactp.contactList
                                                              .users.length ==
                                                          0)
                                                        return noContactFound(
                                                            context);
                                                      else
                                                        return contactList(
                                                            contactp);
                                                    } else
                                                      return Container(
                                                        child: Text(
                                                            "no contacts found"),
                                                      );
                                                  },
                                                )
                                              : Consumer<GroupListProvider>(
                                                  builder: (context, contact,
                                                      child) {
                                                    if (contact
                                                            .groupListStatus ==
                                                        ListStatus.Loading)
                                                      return Center(
                                                        child: Container(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    chatRoomColor),
                                                          ),
                                                        ),
                                                      );
                                                    else if (contact
                                                            .groupListStatus ==
                                                        ListStatus.Scussess) {
                                                      if (contact.groupList
                                                              .groups.length ==
                                                          0)
                                                        return noContactFound(
                                                            context);
                                                      else
                                                        return groupList(
                                                            contact.groupList);
                                                    } else
                                                      return Container(
                                                        child: Text(
                                                            "no contacts found"),
                                                      );
                                                  },
                                                ),
                                        )
                                      ],
                                    )),
                            ResponsiveWidget.isSmallScreen(context)
                                ? SizedBox(height: 3, width: 3)
                                :
                                //rightSection
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.white,
                                      ),
                                      child: Consumer<CallProvider>(
                                        builder:
                                            (context, callProvider, child) {
                                          print(
                                              "this is callStatus ${callProvider.callStatus}");
                                          if (callProvider.callStatus ==
                                              CallStatus.CallReceive)
                                            return callReceive();
                                          // return Container(
                                          //   child: Text("test"),
                                          // );

                                          if (callProvider.callStatus ==
                                              CallStatus.CallStart)
                                          // return Container(
                                          //   child: Text("test"),
                                          // );
                                          if (ResponsiveWidget.isSmallScreen(
                                              context))
                                            return callStart();
                                          else
                                            return callStartWeb();
                                          if (callProvider.callStatus ==
                                              CallStatus.CallDial)
                                            return callDial();
                                          // return Container(
                                          //   child: Text("test"),
                                          // );
                                          else if (callProvider.callStatus ==
                                              CallStatus.Initial)
                                            return SafeArea(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    FocusScopeNode currentFous =
                                                        FocusScope.of(context);
                                                    if (!currentFous
                                                        .hasPrimaryFocus) {
                                                      return currentFous
                                                          .unfocus();
                                                    }
                                                  },
                                                  child: NoGroupScreen(
                                                    handleRefresh: refreshList,
                                                    handleNewCreate:
                                                        handleGroupState,
                                                  )),
                                            );
                                          return Container(
                                            child: Text("test"),
                                          );
                                        },
                                      ),
                                    )),

                            // rightSection()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
    else
      return Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          print("this is callStatus ${callProvider.callStatus}");
          if (callProvider.callStatus == CallStatus.CallReceive)
            return callReceive();

          if (callProvider.callStatus == CallStatus.CallStart) {
            // if (isPushed == false) {
            //   isPushed = true;
            print("in ispushed false");
            return callStart();
            // }
          }
          // return callStartNewDesign();
          if (callProvider.callStatus == CallStatus.CallDial)
            return callDial();
          else
            return 
            SafeArea(
                          child: Scaffold(
                  resizeToAvoidBottomInset: true,
                backgroundColor: chatRoomBackgroundColor,
               //   backgroundColor: chatRoomBackgroundColor,
                  appBar: CustomAppBar(
                    handlePress: handleCreateGroup,
                  ),
                  body: Consumer2<ContactProvider, GroupListProvider>(
                    builder: (context, contact, groupProvider, child) {
                      if (groupProvider.groupListStatus == ListStatus.Loading)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(chatRoomColor),
                        ));
                      else if (groupProvider.groupListStatus ==
                          ListStatus.Scussess) {
                        if (groupProvider.groupList.groups.length == 0)
                          return NoContactsScreen(
                              isConnect: sockett,
                              state: widget.state,
                              refreshList: renderList,
                              groupListProvider: groupProvider,
                              authProvider: _auth,
                              newChatHandler: handleGroupState);
                        else
                          return groupList(groupProvider.groupList);
                      } else
                        return contactList(contact);
                    },
                  )),
            );
        },
      );
  }

  Container noContactFound(BuildContext context) {
    return Container(
      height: ResponsiveWidget.isSmallHeight(context)
          ? MediaQuery.of(context).size.height + 1000
          : MediaQuery.of(context).size.height + 1,
      width: ResponsiveWidget.isSmallScreen(context)
          ? MediaQuery.of(context).size.width - 125
          : 370,
      color: Colors.white,
      margin: const EdgeInsets.only(right: 34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "No Available Chatroom",
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
                color: horizontalDotIconColor,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Scaffold callReceive() {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(children: <Widget>[
        meidaType == MediaType.video
            ? Container(
                child: RemoteStream(
                remoteRenderer: rendererListWithRefID[0]["rtcVideoRenderer"],
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
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
              Consumer<ContactProvider>(
                builder: (context, contact, child) {
                  if (contact.contactState == ContactStates.Success) {
                    int index = contact.contactList.users.indexWhere(
                        (element) => element.ref_id == incomingfrom);
                    print("callto is $callTo");
                    print(
                        "incoming ${index == -1 ? incomingfrom : contact.contactList.users[index].full_name}");
                    return Text(
                      index == -1
                          ? incomingfrom
                          : contact.contactList.users[index].full_name,
                      style: TextStyle(
                          fontFamily: primaryFontFamily,
                          color: darkBlackColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 24),
                    );
                  } else
                    return Container();
                },
              ),
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
                      _auth.getUser.ref_id, registerRes["mcToken"]);
                  // _callBloc.add(CallNewEvent());
                  _callProvider.initial();
                  // signalingClient.onDeclineCall(widget.registerUser);
                  // setState(() {
                  //   _isCalling = false;
                  // });
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
                  _callProvider.callStart();
                  // setState(() {
                  //   _isCalling = true;
                  //   incomingfrom = null;
                  // });
                  // FlutterRingtonePlayer.stop();
                  // Vibration.cancel();
                },
              ),
            ],
          ),
        ),
      ]);
    }));
    //   floatingActionButton: Padding(
    //     padding: const EdgeInsets.only(bottom: 70),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         Container(
    //           // width: 80,
    //           // height: 80,
    //           child: FloatingActionButton(
    //             backgroundColor: redColor,
    //             onPressed: () {
    //               stopRinging();
    //               signalingClient.onDeclineCall(_auth.getUser.ref_id);
    //               // _callBloc.add(CallNewEvent());
    //               _callProvider.initial();
    //               // signalingClient.onDeclineCall(widget.registerUser);
    //               // setState(() {
    //               //   _isCalling = false;
    //               // });
    //             },
    //             child: Icon(Icons.clear),
    //           ),
    //         ),
    //         Container(
    //           // width: 80,
    //           // height: 80,
    //           child: FloatingActionButton(
    //             backgroundColor: Colors.green,
    //             onPressed: () {
    //               stopRinging();
    //               signalingClient.createAnswer(incomingfrom);
    //               // setState(() {
    //               //   _isCalling = true;
    //               //   incomingfrom = null;
    //               // });
    //               // FlutterRingtonePlayer.stop();
    //               // Vibration.cancel();
    //             },
    //             child: Icon(Icons.phone),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
  }

  Scaffold callDial() {
    print(
        "ths is width ${MediaQuery.of(context).size.height}, ${MediaQuery.of(context).size.width}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            meidaType == MediaType.video
                ? Container(
                    // color: Colors.red,
                    //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RemoteStream(
                      remoteRenderer: rendererListWithRefID[0]
                          ["rtcVideoRenderer"],
                    )

                    // RTCVideoView(
                    //     rendererListWithRefID[0]["rtcVideoRenderer"],
                    //     key: forDialView,
                    //     mirror: false,
                    //     objectFit: RTCVideoViewObjectFit
                    //         .RTCVideoViewObjectFitCover),
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
                        "Calling",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: callingTo.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                callingTo[index].full_name,
                                style: TextStyle(
                                    fontFamily: primaryFontFamily,
                                    color: darkBlackColor,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 24),
                              ),
                            );
                          },
                        ),
                      )
                    ])),

            // Container(
            //     padding: EdgeInsets.only(top: 120),
            //     alignment: Alignment.center,
            //     child: Column(
            //         // mainAxisAlignment: MainAxisAlignment.center,
            //         // crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Dialing Call to",
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 decoration: TextDecoration.none,
            //                 fontFamily: secondaryFontFamily,
            //                 fontWeight: FontWeight.w400,
            //                 fontStyle: FontStyle.normal,
            //                 color: darkBlackColor),
            //           ),
            //           SizedBox(
            //             height: 8,
            //           ),
            //           Text(
            //             callTo,
            //             style: TextStyle(
            //                 fontFamily: primaryFontFamily,
            //                 color: darkBlackColor,
            //                 decoration: TextDecoration.none,
            //                 fontWeight: FontWeight.w700,
            //                 fontStyle: FontStyle.normal,
            //                 fontSize: 24),
            //           )
            //         ])),

            Container(
              padding: EdgeInsets.only(bottom: 56),
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
                  _callProvider.initial();
                  // _callBloc.add(CallNewEvent());
                  // signalingClient.onDeclineCall(widget.user.ref_id);
                  // setState(() {
                  //   _isCalling = false;
                  // });
                },
              ),
            ),
          ],
        );
      }),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 70),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       Container(
      //         // width: 80,
      //         // height: 80,
      //         child: FloatingActionButton(
      //           backgroundColor: redColor,
      //           onPressed: () {
      //             signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
      //             _callProvider.initial();
      //             // _callBloc.add(CallNewEvent());
      //             // signalingClient.onDeclineCall(widget.user.ref_id);
      //             // setState(() {
      //             //   _isCalling = false;
      //             // });
      //           },
      //           child: Icon(Icons.clear),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Scaffold callStart() {
    print("this is press duration value in widget build  $_pressDuration");
    print(
        "this is on remote stream in start call ${rendererListWithRefID.length}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            // when remote video come
            // meidaType == MediaType.video
            //     ?
            onRemoteStream
                ? rendererListWithRefID.length == 1
                    ? Container()
                    : rendererListWithRefID.length == 2
                        ?
                        // if video is off then show white screen
                        rendererListWithRefID[1]["remoteVideoFlag"] == 0
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
                                      Text(_contactProvider
                                          .contactList
                                          .users[_contactProvider
                                              .contactList.users
                                              .indexWhere((element) =>
                                                  element.ref_id ==
                                                  rendererListWithRefID[1]
                                                      ["refID"])]
                                          .full_name)
                                    ],
                                  ),
                                ),
                              )
                            : RemoteStream(
                                remoteRenderer: rendererListWithRefID[1]
                                    ["rtcVideoRenderer"],
                              )
                        : rendererListWithRefID.length == 3
                            ? Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                        // color: Colors.yellow,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: // if video is off then show white screen
                                            rendererListWithRefID[1]
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
                                                          Text(_contactProvider
                                                              .contactList
                                                              .users[_contactProvider
                                                                  .contactList
                                                                  .users
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .ref_id ==
                                                                      rendererListWithRefID[
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
                                                        rendererListWithRefID[1]
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
                                            rendererListWithRefID[2]
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
                                                          Text(_contactProvider
                                                              .contactList
                                                              .users[_contactProvider
                                                                  .contactList
                                                                  .users
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .ref_id ==
                                                                      rendererListWithRefID[
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
                                                        rendererListWithRefID[2]
                                                            [
                                                            "rtcVideoRenderer"],
                                                  )),
                                  )
                                ],
                              )
                            : rendererListWithRefID.length == 4
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
                                                    rendererListWithRefID[1][
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
                                                                  Text(_contactProvider
                                                                      .contactList
                                                                      .users[_contactProvider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                              rendererListWithRefID[1]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                rendererListWithRefID[
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
                                                  rendererListWithRefID[2][
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
                                                                Text(_contactProvider
                                                                    .contactList
                                                                    .users[_contactProvider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                            rendererListWithRefID[2]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                              rendererListWithRefID[
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
                                              rendererListWithRefID[3]
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
                                                            Text(_contactProvider
                                                                .contactList
                                                                .users[_contactProvider
                                                                    .contactList
                                                                    .users
                                                                    .indexWhere((element) =>
                                                                        element
                                                                            .ref_id ==
                                                                        rendererListWithRefID[3]
                                                                            [
                                                                            "refID"])]
                                                                .full_name)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : RemoteStream(
                                                      remoteRenderer:
                                                          rendererListWithRefID[
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
                                                    rendererListWithRefID[1][
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
                                                                  Text(_contactProvider
                                                                      .contactList
                                                                      .users[_contactProvider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                              rendererListWithRefID[1]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                rendererListWithRefID[
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
                                                  rendererListWithRefID[2][
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
                                                                Text(_contactProvider
                                                                    .contactList
                                                                    .users[_contactProvider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                            rendererListWithRefID[2]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                              rendererListWithRefID[
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
                                                    rendererListWithRefID[3][
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
                                                                  Text(_contactProvider
                                                                      .contactList
                                                                      .users[_contactProvider
                                                                          .contactList
                                                                          .users
                                                                          .indexWhere((element) =>
                                                                              element.ref_id ==
                                                                              rendererListWithRefID[3]["refID"])]
                                                                      .full_name)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : RemoteStream(
                                                            remoteRenderer:
                                                                rendererListWithRefID[
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
                                                  rendererListWithRefID[4][
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
                                                                Text(_contactProvider
                                                                    .contactList
                                                                    .users[_contactProvider
                                                                        .contactList
                                                                        .users
                                                                        .indexWhere((element) =>
                                                                            element.ref_id ==
                                                                            rendererListWithRefID[4]["refID"])]
                                                                    .full_name)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : RemoteStream(
                                                          remoteRenderer:
                                                              rendererListWithRefID[
                                                                      4][
                                                                  "rtcVideoRenderer"],
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )

                // RTCVideoView(rendererListWithRefID[0]["refID"],
                //     mirror: false,
                //     objectFit: kIsWeb
                //         ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                //         : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                // : Container(
                //     decoration: BoxDecoration(
                //         gradient: LinearGradient(
                //       colors: [
                //         backgroundAudioCallDark,
                //         backgroundAudioCallLight,
                //         backgroundAudioCallLight,
                //         backgroundAudioCallLight,
                //       ],
                //       begin: Alignment.topCenter,
                //       end: Alignment(0.0, 0.0),
                //     )),
                //     child: Center(
                //       child: SvgPicture.asset(
                //         'assets/userIconCall.svg',
                //       ),
                //     ),
                //   )
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
            // : Container(
            //     decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //       colors: [
            //         backgroundAudioCallDark,
            //         backgroundAudioCallLight,
            //         backgroundAudioCallLight,
            //         backgroundAudioCallLight,
            //       ],
            //       begin: Alignment.topCenter,
            //       end: Alignment(0.0, 0.0),
            //     )),
            //     child: Center(
            //       child: SvgPicture.asset(
            //         'assets/userIconCall.svg',
            //       ),
            //     ),
            //   ),

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
                        //            Consumer<ContactProvider>(
                        //   builder: (context, contact, child) {
                        //     if (contact.contactState == ContactStates.Success) {
                        //       int index = contact.contactList.users.indexWhere(
                        //           (element) => element.ref_id == incomingfrom);
                        //       return Text(
                        //         contact.contactList.users[index].full_name,
                        //         style: TextStyle(
                        //             fontFamily: primaryFontFamily,
                        //             color: darkBlackColor,
                        //             decoration: TextDecoration.none,
                        //             fontWeight: FontWeight.w700,
                        //             fontStyle: FontStyle.normal,
                        //             fontSize: 24),
                        //       );
                        //     }
                        //   },
                        // ),
                        (callTo == "")
                            ? Consumer<ContactProvider>(
                                builder: (context, contact, child) {
                                if (contact.contactState ==
                                    ContactStates.Success) {
                                  int index = contact.contactList.users
                                      .indexWhere((element) =>
                                          element.ref_id == incomingfrom);
                                  print("i am here-");
                                  return Text(
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
                                callTo,
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
                          _pressDuration,
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
                  //  Column(
                  //         children: [
                  //           // Text(
                  //           //   _pressDuration,
                  //           //   style: TextStyle(
                  //           //       decoration: TextDecoration.none,
                  //           //       fontSize: 14,
                  //           //       fontFamily: secondaryFontFamily,
                  //           //       fontWeight: FontWeight.w400,
                  //           //       fontStyle: FontStyle.normal,
                  //           //       color: darkBlackColor),
                  //           // ),
                  //           SizedBox(width:10),
                  //         number!=null?   Text(
                  //             "DownStream $downstream  UpStream $upstream",
                  //             style: TextStyle(
                  //                 decoration: TextDecoration.none,
                  //                 fontSize: 14,
                  //                 fontFamily: secondaryFontFamily,
                  //                 fontWeight: FontWeight.w400,
                  //                 fontStyle: FontStyle.normal,
                  //                 color: darkBlackColor),
                  //           ):Text(
                  //             "DownStream 0   UpStream 0",
                  //             style: TextStyle(
                  //                 decoration: TextDecoration.none,
                  //                 fontSize: 14,
                  //                 fontFamily: secondaryFontFamily,
                  //                 fontWeight: FontWeight.w400,
                  //                 fontStyle: FontStyle.normal,
                  //                 color: darkBlackColor),
                  //           ),
                  //         ],
                  //       ),
                ],
              ),
            ),
            !kIsWeb
                ? meidaType == MediaType.video
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
                              // padding: EdgeInsets.zero,
                              // height: 500,
                              // width: 500,
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                child: switchSpeaker
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
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Padding(
                              // padding: EdgeInsets.zero,
                              // height: 500,
                              // width: 500,
                              padding: const EdgeInsets.fromLTRB(
                                  327.0, 120.0, 20.0, 8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  child: switchSpeaker
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

            meidaType == MediaType.video
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
                              remoteRenderer: rendererListWithRefID[0]
                                  ["rtcVideoRenderer"],
                            )

                            // RTCVideoView(_remoteRenderer,
                            //     // key: forsmallView,
                            //     mirror: false,
                            //     objectFit: RTCVideoViewObjectFit
                            //         .RTCVideoViewObjectFitCover),
                            ),
                      ),
                    ),
                  )
                : Container(),

            // Positioned(
            //   // left: 225.0,
            //   bottom: 145.0,
            //   right: 20,
            //   child: Align(
            //     // alignment: Alignment.bottomRight,
            //     child: Container(
            //       height: 170,
            //       width: 130,
            //       decoration: BoxDecoration(
            //         color: Colors.green,
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(10.0),
            //         child:
            //             // RemoteStream(
            //             //   remoteRenderer: _remoteRenderer,
            //             // )
            //             Container(),
            //       ),
            //     ),
            //   ),
            // ),

            Container(
              padding: EdgeInsets.only(
                bottom: 56,
              ),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  meidaType == MediaType.video
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
                                    audioFlag: switchMute ? 1 : 0,
                                    videoFlag: enableCamera ? 1 : 0,
                                    mcToken: registerRes["mcToken"]);
                                signalingClient.enableCamera(enableCamera);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        )
                      : SizedBox(),
                  // : Container(),

                  // FloatingActionButton(
                  //   backgroundColor:
                  //       switchSpeaker ? chatRoomColor : Colors.white,
                  //   elevation: 0.0,
                  //   onPressed: () {
                  //     setState(() {
                  //       switchSpeaker = !switchSpeaker;
                  //     });
                  //     signalingClient.switchSpeaker(switchSpeaker);
                  //   },
                  //   child: switchSpeaker
                  //       ? Icon(Icons.volume_up)
                  //       : Icon(
                  //           Icons.volume_off,
                  //           color: chatRoomColor,
                  //         ),
                  // ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/end.svg',
                    ),
                    onTap: () {
                      stopCall();
                      // setState(() {
                      //   _isCalling = false;
                      // });
                    },
                  ),

                  // SvgPicture.asset('assets/images/end.svg'),

                  SizedBox(width: 20),
                  GestureDetector(
                    child: !switchMute
                        ? SvgPicture.asset('assets/mute_microphone.svg')
                        : SvgPicture.asset('assets/microphone.svg'),
                    onTap: () {
                      final bool enabled = signalingClient.muteMic();
                      print("this is enabled $enabled");
                      setState(() {
                        switchMute = enabled;
                      });
                    },
                  ),
                ],
              ),
            )
          ]),
        );
      }),
    );
  }

  Scaffold callStartNewDesign() {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
            child: Stack(
          children: [
            onRemoteStream
                ? forLargStream["remoteVideoFlag"] == 0
                    ? Container(
                        decoration:
                            BoxDecoration(color: backgroundAudioCallLight),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/userIconCall.svg',
                              ),
                              Text(_contactProvider
                                  .contactList
                                  .users[_contactProvider.contactList.users
                                      .indexWhere((element) =>
                                          element.ref_id ==
                                          forLargStream["refID"])]
                                  .full_name)
                            ],
                          ),
                        ),
                      )
                    : RemoteStream(
                        remoteRenderer: forLargStream["rtcVideoRenderer"],
                      )
                : Container(
                    decoration: BoxDecoration(color: backgroundAudioCallLight),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/userIconCall.svg',
                          ),
                        ],
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
                        //            Consumer<ContactProvider>(
                        //   builder: (context, contact, child) {
                        //     if (contact.contactState == ContactStates.Success) {
                        //       int index = contact.contactList.users.indexWhere(
                        //           (element) => element.ref_id == incomingfrom);
                        //       return Text(
                        //         contact.contactList.users[index].full_name,
                        //         style: TextStyle(
                        //             fontFamily: primaryFontFamily,
                        //             color: darkBlackColor,
                        //             decoration: TextDecoration.none,
                        //             fontWeight: FontWeight.w700,
                        //             fontStyle: FontStyle.normal,
                        //             fontSize: 24),
                        //       );
                        //     }
                        //   },
                        // ),
                        (callTo == "")
                            ? Consumer<ContactProvider>(
                                builder: (context, contact, child) {
                                if (contact.contactState ==
                                    ContactStates.Success) {
                                  int index = contact.contactList.users
                                      .indexWhere((element) =>
                                          element.ref_id == incomingfrom);
                                  print("i am here-");
                                  return Text(
                                    // contact.contactList.users[index].full_name,
                                    "this is GroupCall",
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
                                callTo,
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
                          _pressDuration,
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
            // meidaType == MediaType.video
            //     ?
            Container(
              // color: Colors.red,
              child: Column(
                children: [
                  Padding(
                    // height: 500,
                    // width: 500,
                    // padding: EdgeInsets.zero,
                    padding: const EdgeInsets.fromLTRB(327.0, 120.0, 25.0, 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: SvgPicture.asset('assets/switch_camera.svg'),
                        onTap: () {
                          signalingClient.switchCamera();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    // padding: EdgeInsets.zero,
                    // height: 500,
                    // width: 500,
                    padding: const EdgeInsets.fromLTRB(327.0, 10.0, 20.0, 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: switchSpeaker
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
                  ),
                ],
              ),
            ),

            meidaType == MediaType.video
                ? Positioned(
                    bottom: 145.0,
                    // right: 20,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: rendererListWithRefID.length,
                          itemBuilder: (context, index) {
                            int userIndex = _contactProvider.contactList.users
                                .indexWhere((element) =>
                                    element.ref_id ==
                                    rendererListWithRefID[index]["refID"]);
                            return Container(
                              width: 80.0,
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Stack(
                                children: [
                                  Container(
                                    child: rendererListWithRefID[index]
                                                ["remoteVideoFlag"] ==
                                            1
                                        ? RemoteStream(
                                            remoteRenderer:
                                                rendererListWithRefID[index]
                                                    ["rtcVideoRenderer"],
                                          )
                                        : Container(
                                            width: 80.0,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                color:
                                                    backgroundAudioCallLight),
                                            child: Container(
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  'assets/userIconCall.svg',
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        forLargStream =
                                            rendererListWithRefID[index];
                                      });
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 100,
                                      // color: Colors.white,
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        userIndex == -1
                                            ? _auth.getUser.full_name
                                            : _contactProvider.contactList
                                                .users[userIndex].full_name,
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              // Stack(
                              //   children: [
                              //     // Container(child: Text("this is teset"))
                              //     Container(
                              //       child: rendererListWithRefID[index]
                              //                   ["remoteVideoFlag"] ==
                              //               1
                              //           ? RemoteStream(
                              //               remoteRenderer:
                              //                   rendererListWithRefID[index]
                              //                       ["rtcVideoRenderer"],
                              //             )
                              //           : Container(
                              //               width: 80.0,
                              //               height: 100,
                              //               decoration: BoxDecoration(
                              //                   borderRadius:
                              //                       new BorderRadius.all(
                              //                           Radius.circular(10.0)),
                              //                   color:
                              //                       backgroundAudioCallLight),
                              //               child: Container(
                              //                 child: Center(
                              //                   child: SvgPicture.asset(
                              //                     'assets/userIconCall.svg',
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //     ),
                              //     InkWell(
                              //       onTap: () {
                              //         // print("Container clicked");
                              //         // var temp =
                              //         //     rendererListWithRefID[index + 1];
                              //         // setState(() {
                              //         //   rendererListWithRefID[index + 1] =
                              //         //       rendererListWithRefID[0];
                              //         //   rendererListWithRefID[0] = temp;
                              //         // });

                              //         setState(() {
                              //           forLargStream =
                              //               rendererListWithRefID[index];
                              //         });
                              //       },
                              //       child: Expanded(
                              //         child: Container(
                              //           padding: EdgeInsets.all(10),
                              //           width: 80,
                              //           height: 100,
                              //           child: Container(
                              //             child: Row(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.end,
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Container(
                              //                   width: 5,
                              //                   height: 5,
                              //                   decoration: new BoxDecoration(
                              //                       color: Colors.green,
                              //                       borderRadius:
                              //                           new BorderRadius.all(
                              //                               Radius.circular(
                              //                                   50.0))),
                              //                 ),
                              //                 SizedBox(
                              //                   width: 5,
                              //                 ),
                              //                 Text(
                              //                   userIndex == -1
                              //                       ? _auth.getUser.full_name
                              //                       : _contactProvider
                              //                           .contactList
                              //                           .users[userIndex]
                              //                           .full_name,
                              //                   overflow: TextOverflow.ellipsis,
                              //                   style: TextStyle(
                              //                       color: primaryColor,
                              //                       fontSize: 8,
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),

            Container(
              padding: EdgeInsets.only(
                bottom: 56,
              ),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  meidaType == MediaType.video
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
                                    audioFlag: switchMute ? 1 : 0,
                                    videoFlag: enableCamera ? 1 : 0,
                                    mcToken: registerRes["mcToken"]);
                                signalingClient.enableCamera(enableCamera);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        )
                      : SizedBox(),
                  // : Container(),

                  // FloatingActionButton(
                  //   backgroundColor:
                  //       switchSpeaker ? chatRoomColor : Colors.white,
                  //   elevation: 0.0,
                  //   onPressed: () {
                  //     setState(() {
                  //       switchSpeaker = !switchSpeaker;
                  //     });
                  //     signalingClient.switchSpeaker(switchSpeaker);
                  //   },
                  //   child: switchSpeaker
                  //       ? Icon(Icons.volume_up)
                  //       : Icon(
                  //           Icons.volume_off,
                  //           color: chatRoomColor,
                  //         ),
                  // ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/end.svg',
                    ),
                    onTap: () {
                      stopCall();
                      // setState(() {
                      //   _isCalling = false;
                      // });
                    },
                  ),

                  // SvgPicture.asset('assets/images/end.svg'),

                  SizedBox(width: 20),
                  GestureDetector(
                    child: !switchMute
                        ? SvgPicture.asset('assets/mute_microphone.svg')
                        : SvgPicture.asset('assets/microphone.svg'),
                    onTap: () {
                      final bool enabled = signalingClient.muteMic();
                      print("this is enabled $enabled");
                      setState(() {
                        switchMute = enabled;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ));
      }),
    );
  }

  Scaffold callStartWeb() {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 200,
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: rendererListWithRefID.length - 1,
                          itemBuilder: (context, index) {
                            int userIndex = _contactProvider.contactList.users
                                .indexWhere((element) =>
                                    element.ref_id ==
                                    rendererListWithRefID[index + 1]["refID"]);
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                width: 200.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Stack(
                                  children: [
                                    Expanded(
                                      child: rendererListWithRefID[index + 1]
                                                  ["remoteVideoFlag"] ==
                                              1
                                          ? RemoteStream(
                                              remoteRenderer:
                                                  rendererListWithRefID[index +
                                                      1]["rtcVideoRenderer"],
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      backgroundAudioCallLight),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  'assets/userIconCall.svg',
                                                ),
                                              ),
                                            ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("Container clicked");
                                        var temp =
                                            rendererListWithRefID[index + 1];
                                        setState(() {
                                          rendererListWithRefID[index + 1] =
                                              rendererListWithRefID[0];
                                          rendererListWithRefID[0] = temp;
                                        });
                                      },
                                      child: Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          width: 200,
                                          height: 200,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: new BoxDecoration(
                                                    // color: Colors.green,
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            Radius.circular(
                                                                50.0))),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                userIndex == -1
                                                    ? _auth.getUser.full_name
                                                    : _contactProvider
                                                        .contactList
                                                        .users[userIndex]
                                                        .full_name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 200,
                          alignment: Alignment(0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child:
                                rendererListWithRefID[0]["remoteVideoFlag"] == 1
                                    ? LargStream(
                                        remoteRenderer: rendererListWithRefID[0]
                                            ["rtcVideoRenderer"],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: backgroundAudioCallLight),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/userIconCall.svg',
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    )
                  ],
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
                  meidaType == MediaType.video
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
                                    audioFlag: switchMute ? 1 : 0,
                                    videoFlag: enableCamera ? 1 : 0,
                                    mcToken: registerRes["mcToken"]);
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
                      stopCall();
                      // setState(() {
                      //   _isCalling = false;
                      // });
                    },
                  ),

                  // SvgPicture.asset('assets/images/end.svg'),

                  SizedBox(width: 20),
                  GestureDetector(
                    child: !switchMute
                        ? SvgPicture.asset('assets/mute_microphone.svg')
                        : SvgPicture.asset('assets/microphone.svg'),
                    onTap: () {
                      final bool enabled = signalingClient.muteMic();
                      print("this is enabled $enabled");
                      setState(() {
                        switchMute = enabled;
                      });
                    },
                  ),
                ],
              ),
            ),

            // meidaType == MediaType.video
            //     ? remoteVideoFlag
            //         ? RTCVideoView(_localRenderer,
            //             mirror: false,
            //             objectFit:
            //                 RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
            //         : Container(
            //             decoration: BoxDecoration(
            //                 gradient: LinearGradient(
            //               colors: [
            //                 backgroundAudioCallDark,
            //                 backgroundAudioCallLight,
            //                 backgroundAudioCallLight,
            //                 backgroundAudioCallLight,
            //               ],
            //               begin: Alignment.topCenter,
            //               end: Alignment(0.0, 0.0),
            //             )),
            //             child: Center(
            //               child: SvgPicture.asset(
            //                 'assets/userIconCall.svg',
            //               ),
            //             ),
            //           )
            //     : Container(
            //         decoration: BoxDecoration(
            //             gradient: LinearGradient(
            //           colors: [
            //             backgroundAudioCallDark,
            //             backgroundAudioCallLight,
            //             backgroundAudioCallLight,
            //             backgroundAudioCallLight,
            //           ],
            //           begin: Alignment.topCenter,
            //           end: Alignment(0.0, 0.0),
            //         )),
            //         child: Center(
            //           child: SvgPicture.asset(
            //             'assets/userIconCall.svg',
            //           ),
            //         ),
            //       ),

            // //decoration: BoxDecoration(color: Colors.black54),
            // //),
            // //  ),
            // // Positioned(
            // //   top: 55,
            // //   child:
            // Container(
            //   padding: EdgeInsets.only(top: 55, left: 20),
            //   //height: 79,
            //   //width: MediaQuery.of(context).size.width,

            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'You are video calling with',
            //         style: TextStyle(
            //             fontSize: 14,
            //             decoration: TextDecoration.none,
            //             fontFamily: secondaryFontFamily,
            //             fontWeight: FontWeight.w400,
            //             fontStyle: FontStyle.normal,
            //             color: darkBlackColor),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(
            //           right: 25,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             //            Consumer<ContactProvider>(
            //             //   builder: (context, contact, child) {
            //             //     if (contact.contactState == ContactStates.Success) {
            //             //       int index = contact.contactList.users.indexWhere(
            //             //           (element) => element.ref_id == incomingfrom);
            //             //       return Text(
            //             //         contact.contactList.users[index].full_name,
            //             //         style: TextStyle(
            //             //             fontFamily: primaryFontFamily,
            //             //             color: darkBlackColor,
            //             //             decoration: TextDecoration.none,
            //             //             fontWeight: FontWeight.w700,
            //             //             fontStyle: FontStyle.normal,
            //             //             fontSize: 24),
            //             //       );
            //             //     }
            //             //   },
            //             // ),
            //             (callTo == "")
            //                 ? Consumer<ContactProvider>(
            //                     builder: (context, contact, child) {
            //                     if (contact.contactState ==
            //                         ContactStates.Success) {
            //                       int index = contact.contactList.users
            //                           .indexWhere((element) =>
            //                               element.ref_id == incomingfrom);
            //                       print("i am here-");
            //                       return Text(
            //                         contact.contactList.users[index].full_name,
            //                         style: TextStyle(
            //                             fontFamily: primaryFontFamily,
            //                             color: darkBlackColor,
            //                             decoration: TextDecoration.none,
            //                             fontWeight: FontWeight.w700,
            //                             fontStyle: FontStyle.normal,
            //                             fontSize: 24),
            //                       );
            //                     } else {
            //                       return Container();
            //                     }
            //                   })
            //                 : Text(
            //                     callTo,
            //                     style: TextStyle(
            //                         fontFamily: primaryFontFamily,
            //                         // background: Paint()..color = yellowColor,
            //                         color: darkBlackColor,
            //                         decoration: TextDecoration.none,
            //                         fontWeight: FontWeight.w700,
            //                         fontStyle: FontStyle.normal,
            //                         fontSize: 24),
            //                   ),
            //             Text(
            //               _pressDuration,
            //               style: TextStyle(
            //                   decoration: TextDecoration.none,
            //                   fontSize: 14,
            //                   fontFamily: secondaryFontFamily,
            //                   fontWeight: FontWeight.w400,
            //                   fontStyle: FontStyle.normal,
            //                   color: darkBlackColor),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // !kIsWeb
            //     ? meidaType == MediaType.video
            //         ? Container(
            //             // color: Colors.red,
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   // height: 500,
            //                   // width: 500,
            //                   // padding: EdgeInsets.zero,
            //                   padding: const EdgeInsets.fromLTRB(
            //                       327.0, 120.0, 25.0, 8.0),
            //                   child: Align(
            //                     alignment: Alignment.topRight,
            //                     child: GestureDetector(
            //                       child: SvgPicture.asset(
            //                           'assets/switch_camera.svg'),
            //                       onTap: () {
            //                         signalingClient.switchCamera();
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   // padding: EdgeInsets.zero,
            //                   // height: 500,
            //                   // width: 500,
            //                   padding: const EdgeInsets.fromLTRB(
            //                       327.0, 10.0, 20.0, 8.0),
            //                   child: Align(
            //                     alignment: Alignment.topRight,
            //                     child: GestureDetector(
            //                       child: switchSpeaker
            //                           ? SvgPicture.asset('assets/VolumnOn.svg')
            //                           : SvgPicture.asset(
            //                               'assets/VolumeOff.svg'),
            //                       onTap: () {
            //                         signalingClient
            //                             .switchSpeaker(switchSpeaker);
            //                         setState(() {
            //                           switchSpeaker = !switchSpeaker;
            //                         });
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           )
            //         : Container(
            //             // color: Colors.red,
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   // padding: EdgeInsets.zero,
            //                   // height: 500,
            //                   // width: 500,
            //                   padding: const EdgeInsets.fromLTRB(
            //                       327.0, 120.0, 20.0, 8.0),
            //                   child: Align(
            //                     alignment: Alignment.topRight,
            //                     child: GestureDetector(
            //                       child: switchSpeaker
            //                           ? SvgPicture.asset('assets/VolumnOn.svg')
            //                           : SvgPicture.asset(
            //                               'assets/VolumeOff.svg'),
            //                       onTap: () {
            //                         signalingClient
            //                             .switchSpeaker(switchSpeaker);
            //                         setState(() {
            //                           switchSpeaker = !switchSpeaker;
            //                         });
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           )
            //     : SizedBox(),

            // Positioned(
            //   left: 20.0,
            //   bottom: 145.0,
            //   // right: 20,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: 170,
            //       width: 130,
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(10.0),
            //         child: enableCamera
            //             ? RTCVideoView(_remoteRenderer,
            //                 key: forsmallView,
            //                 mirror: false,
            //                 objectFit: RTCVideoViewObjectFit
            //                     .RTCVideoViewObjectFitCover)
            //             : Container(),
            //       ),
            //     ),
            //   ),
            // ),

            // Container(
            //   padding: EdgeInsets.only(
            //     bottom: 56,
            //   ),
            //   alignment: Alignment.bottomCenter,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       meidaType == MediaType.video
            //           ? Row(
            //               children: [
            //                 GestureDetector(
            //                   child: !enableCamera
            //                       ? SvgPicture.asset('assets/video_off.svg')
            //                       : SvgPicture.asset('assets/video.svg'),
            //                   onTap: () {
            //                     setState(() {
            //                       enableCamera = !enableCamera;
            //                     });
            //                     signalingClient.audioVideoState(
            //                         audioFlag: switchMute ? 1 : 0,
            //                         videoFlag: enableCamera ? 1 : 0,
            //                         mcToken: registerRes["mcToken"]);
            //                     signalingClient.enableCamera(enableCamera);
            //                   },
            //                 ),
            //                 SizedBox(
            //                   width: 20,
            //                 )
            //               ],
            //             )
            //           : SizedBox(),
            //       // : Container(),

            //       // FloatingActionButton(
            //       //   backgroundColor:
            //       //       switchSpeaker ? chatRoomColor : Colors.white,
            //       //   elevation: 0.0,
            //       //   onPressed: () {
            //       //     setState(() {
            //       //       switchSpeaker = !switchSpeaker;
            //       //     });
            //       //     signalingClient.switchSpeaker(switchSpeaker);
            //       //   },
            //       //   child: switchSpeaker
            //       //       ? Icon(Icons.volume_up)
            //       //       : Icon(
            //       //           Icons.volume_off,
            //       //           color: chatRoomColor,
            //       //         ),
            //       // ),
            //       // SizedBox(
            //       //   width: 20,
            //       // ),
            //       GestureDetector(
            //         child: SvgPicture.asset(
            //           'assets/end.svg',
            //         ),
            //         onTap: () {
            //           stopCall();
            //           // setState(() {
            //           //   _isCalling = false;
            //           // });
            //         },
            //       ),

            //       // SvgPicture.asset('assets/images/end.svg'),

            //       SizedBox(width: 20),
            //       GestureDetector(
            //         child: !switchMute
            //             ? SvgPicture.asset('assets/mute_microphone.svg')
            //             : SvgPicture.asset('assets/microphone.svg'),
            //         onTap: () {
            //           final bool enabled = signalingClient.muteMic();
            //           print("this is enabled $enabled");
            //           setState(() {
            //             switchMute = enabled;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // )
          ]),
        );
      }),
    );
  }

  Scaffold contactList(ContactProvider state) {
    onSearch(value) {
      print("this is here $value");
      List temp;
      temp = state.contactList.users
          .where((element) =>
              element.full_name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
      print("this is filtered list $_filteredList");
      setState(() {
        if (temp.isEmpty) {
          notmatched = true;
          print("Here in true not matched");
        } else {
          print("Here in false matched");
          notmatched = false;
          _filteredList = temp;
        }
        //_filteredList = temp;
      });
    }

    if (state.contactState == ContactStates.Loading)
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(chatRoomColor),
        )),
      );
    else
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 21, right: 21),
                  child: TextFormField(
                    //textAlign: TextAlign.center,
                    controller: _searchController,
                    onChanged: (value) {
                      onSearch(value);
                    },
                    validator: (value) =>
                        value.isEmpty ? "Field cannot be empty." : null,
                    decoration: InputDecoration(
                      fillColor: refreshTextColor,
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/SearchIcon.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: searchbarContainerColor)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: searchbarContainerColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: searchbarContainerColor)),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: searchTextColor,
                          fontFamily: secondaryFontFamily),
                    ),
                  ),
                  //),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Scrollbar(
                    child: notmatched == true
                        ? Text("No data Found")
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            cacheExtent: 9999,
                            scrollDirection: Axis.vertical,
                            itemCount: _searchController.text.isEmpty
                                ? state.contactList.users.length
                                : _filteredList.length,
                            itemBuilder: (context, position) {
                              Contact element = _searchController.text.isEmpty
                                  ? state.contactList.users[position]
                                  : _filteredList[position];

                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      if (_selectedContacts.indexWhere(
                                              (contact) =>
                                                  contact.user_id ==
                                                  element.user_id) !=
                                          -1) {
                                        setState(() {
                                          _selectedContacts.remove(element);
                                        });
                                      } else {
                                        setState(() {
                                          _selectedContacts.add(element);
                                        });
                                      }
                                    },
                                    leading: Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, right: 14),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:
                                          SvgPicture.asset('assets/User.svg'),
                                    ),
                                    title: Text(
                                      "${element.full_name}",
                                      style: TextStyle(
                                        color: contactNameColor,
                                        fontSize: 16,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.only(right: 35),
                                      child: _selectedContacts.indexWhere(
                                                  (contact) =>
                                                      contact.user_id ==
                                                      element.user_id) ==
                                              -1
                                          ? Text("")
                                          : SvgPicture.asset(
                                              'assets/checkmark-circle.svg'),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 14.33, right: 19),
                                child: Divider(
                                  thickness: 1,
                                  color: listdividerColor,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Scaffold groupList(GroupListModel state) {
    onSearch(value) {
      print("this is here $value");
      List temp;
      temp = state.groups
          .where((element) =>
              element.group_title.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
      print("this is filtered list $_groupfilteredList");
      setState(() {
        if (temp.isEmpty) {
          groupnotmatched = true;
          print("Here in true not matched");
        } else {
          print("Here in false matched");
          groupnotmatched = false;
          _groupfilteredList = temp;
        }
        //_filteredList = temp;
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 21, right: 21),
                child: TextFormField(
                  //textAlign: TextAlign.center,
                  controller: _GroupListsearchController,
                  onChanged: (value) {
                    onSearch(value);
                  },
                  validator: (value) =>
                      value.isEmpty ? "Field cannot be empty." : null,
                  decoration: InputDecoration(
                    fillColor: refreshTextColor,
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/SearchIcon.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: searchbarContainerColor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: searchbarContainerColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(color: searchbarContainerColor)),
                    // border: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    // contentPadding: EdgeInsets.only(
                    //   top: 15,
                    // ),
                    // contentPadding:
                    //   EdgeInsets.symmetric(vertical: 20, horizontal: 20),

                    // isDense: true,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: searchTextColor,
                        fontFamily: secondaryFontFamily),
                  ),
                ),
                //),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Scrollbar(
                  child: groupnotmatched == true
                      ? Text("No data Found")
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          cacheExtent: 9999,
                          scrollDirection: Axis.vertical,
                          itemCount: _GroupListsearchController.text.isEmpty
                              ? state.groups.length
                              : _groupfilteredList.length,
                          itemBuilder: (context, position) {
                            GroupModel element =
                                _GroupListsearchController.text.isEmpty
                                    ? state.groups[position]
                                    : _groupfilteredList[position];
//Consumer<GroupListProvider>(
  //      builder: (context, listProvider, child) {
                            return Container(
                              //width: screenwidth,
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 11.5, right: 13.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset('assets/User.svg'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${element.group_title}",
                                      style: TextStyle(
                                        color: contactNameColor,
                                        fontSize: 16,
                                        fontFamily: primaryFontFamily,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: 32,
                                    // height: 32,
                                    child: IconButton(
                                      icon: SvgPicture.asset('assets/call.svg'),
                                      onPressed: () {
                                        // _startCall(
                                        //     [element.ref_id],
                                        //     MediaType.audio,
                                        //     CAllType.one2one,
                                        //     SessionType.call);
                                        // setState(() {
                                        //   callTo = element.full_name;
                                        //   meidaType = MediaType.audio;
                                        //   print("this is callTo $callTo");
                                        // });
                                        // print("three dot icon pressed");

                                        _startCall(
                                            element,
                                            MediaType.audio,
                                            CAllType.many2many,
                                            SessionType.call);
                                        setState(() {
                                          callTo = element.group_title;
                                          meidaType = MediaType.audio;
                                          print("this is callTo $callTo");
                                        });
                                        print("three dot icon pressed");
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 5.9),
                                    // width: 35,
                                    // height: 35,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                          'assets/videocallicon.svg'),
                                      onPressed: () {
                                        _startCall(
                                            element,
                                            MediaType.video,
                                            CAllType.many2many,
                                            SessionType.call);
                                        setState(() {
                                          callTo = element.group_title;
                                          meidaType = MediaType.video;
                                          print("this is callTo $callTo");
                                        });
                                        print("three dot icon pressed");
                                      },
                                    ),
                                  )
                                  ,
                                     Consumer<GroupListProvider>(
       builder: (context, listProvider, child) {
                                        return    Container(
                                            height: 24,
                                            width: 24,
                                            margin: EdgeInsets.only(right: 19,bottom: 15),
                                            child: PopupMenuButton(
                                                offset: Offset(8, 30),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                  size: 24,
                                                  color: horizontalDotIconColor,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) => [
                                                          PopupMenuItem(
                                                            enabled: (
                                                                         listProvider.groupList
                                                                            .groups[
                                                                                position]
                                                                            .participants
                                                                            .length ==
                                                                        1 ||
                                                                    listProvider
                                                                            .groupList
                                                                            .groups[
                                                                                position]
                                                                            .participants
                                                                            .length ==
                                                                        2)
                                                                ? false
                                                                : true,
                                                            padding:
                                                                EdgeInsets.only(
                                                                  right: 12,
                                                                    left: 12),
                                                            value: 1,

                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 14,
                                                                      left: 16,
                                                                      right: 50),
                                                              width: 200,
                                                              height: 44,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      chatRoomBackgroundColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              //  color:popupGreyColor,
                                                              child: Text(
                                                                "Edit Group Name",
                                                                //textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  //decoration: TextDecoration.underline,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      font_Family,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color:
                                                                      personNameColor,
                                                                ),
                                                              ),
                                                            ),
                                                            //)
                                                          ),
                                                          //SizedBox(height: 8,),

                                                          PopupMenuItem(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      right: 12,
                                                                      left: 12),
                                                              value: 2,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: 14,
                                                                      left: 16,
                                                                    ),
                                                                    width: 200,
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            chatRoomBackgroundColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    //  color:popupGreyColor,
                                                                    child: Text(
                                                                      "Delete",
                                                                      style:
                                                                          TextStyle(
                                                                        //decoration: TextDecoration.underline,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontFamily:
                                                                            font_Family,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        color:
                                                                            Colors.red[700],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                onSelected: (menu) {
                                                  if (menu == 1) {
                                                    print("i am in edit group name press");
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ListenableProvider<
                                                                  GroupListProvider>.value(
                                                              value:
                                                                  _groupListProvider,
                                                              child:
                                                                  CreateGroupPopUp(
                                                                editGroupName:
                                                                    true,
                                                                groupid:
                                                                    listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            position]
                                                                        .id,
                                                                controllerText:
                                                                    listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            position]
                                                                        .group_title,
                                                                groupNameController:
                                                                    _groupNameController,
                                                               // publishMessage:
                                                                 //   publishMessage,
                                                                authProvider:
                                                                    _auth,
                                                              ));
                                                        });
                                                    print("i am after here");
                                                   

                                                  } else if (menu == 2) {
                                                    _showDialogDeletegroup(
                                                        listProvider.groupList
                                                            .groups[position].id,
                                                        listProvider.groupList
                                                            .groups[position]);
                                                 
                                                  }
                                                }),
 
                                          );
                                  
       })
                                ],
                              ),
                            );
                            //});
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.33, right: 19),
                              child: Divider(
                                thickness: 1,
                                color: listdividerColor,
                              ),
                            );
                          },
                        ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
// padding: const EdgeInsets.only(bottom: 30),

                              child: FlatButton(
                                onPressed: () {
                                  _auth.logout();

                                  signalingClient
                                      .unRegister(registerRes["mcToken"]);
                                },
                                child: Text(
                                  "LOG OUT",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: primaryFontFamily,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      color: logoutButtonColor,
                                      letterSpacing: 0.90),
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              child: SvgPicture.asset(
                                'assets/call.svg',
                                color: sockett && isdev
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ]),
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Text(_auth.getUser.full_name))
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
