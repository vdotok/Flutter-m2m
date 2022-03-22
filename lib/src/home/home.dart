import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vdotok_stream_example/src/core/config/config.dart';
import 'package:vdotok_stream_example/src/home/CallDialScreen/callDialScreen.dart';
import 'package:vdotok_stream_example/src/home/CallReceiveScreen/callReceiveScreen.dart';
import 'package:vdotok_stream_example/src/home/CallStartScreen/callStartScreen.dart';
import 'package:vdotok_stream_example/src/home/ContactListScreen/contactList.dart';
import 'package:vdotok_stream_example/src/home/GroupListScreen/groupListScreen.dart';
import 'package:vdotok_stream_example/src/home/NoContactScreen/noContactsScreen.dart';
import 'package:vdotok_stream_example/src/common/customAppBar.dart';
import 'package:vdotok_stream_example/src/core/models/GroupModel.dart';
import 'package:vdotok_stream_example/src/core/models/ParticipantsModel.dart';
import 'package:vdotok_stream_example/src/core/models/contact.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'package:vdotok_stream_example/src/home/WebScreen/webScreen.dart';
import 'package:vdotok_stream_example/src/home/CreateGroupPopUp.dart';
import 'package:vdotok_stream_example/src/home/responsiveWidget.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show File, Platform, sleep;
import '../../constant.dart';
import '../../main.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';

SignalingClient signalingClient = SignalingClient.instance..checkConnectivity();
String callTo = "";
bool switchMute = true;
bool switchSpeaker = true;
bool enableCamera = true;
bool isRinging = false;
var snackBar;
bool isRegisteredAlready = false;
AudioPlayer audioPlayer = AudioPlayer();

class Home extends StatefulWidget {
  final state;
  Home({this.state});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
//  List<double> _accelerometerValues;
//   List<double> _userAccelerometerValues;
//   List<double> _gyroscopeValues;
//   bool _proximityValues = false;
//   List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _isNear = false;
  StreamSubscription<dynamic> _streamSubscription;

  List<Contact> _selectedContacts = [];
  List<String> strArr = [];
  bool isDeviceConnected = false;
  bool isdev = true;
  DateTime _time;
  Timer _ticker;
  Timer _callticker;
  String _pressDuration = "";
  DateTime _callTime;
  bool iscalloneto1 = false;
  bool inCall = false;
  bool isPushed = false;
  bool iscallReConnected = false;
  double upstream;
  bool isResumed = true;
  bool inPaused = false;
  bool iscallAcceptedbyuser = false;
  bool inInactive = false;

  double downstream;
  void _updateTimer() {
    var duration;
    duration = DateTime.now().difference(_time);
    final newDuration = _formatDuration(duration);
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

  GlobalKey forsmallView = new GlobalKey();
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  String incomingfrom;
  CallProvider _callProvider;
  AuthProvider _auth;
  bool secondRemoteVideo = false;
  bool isConnected = true;
  var number;
  final _searchController = new TextEditingController();
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
  List<Map<String, dynamic>> rendererListWithRefID = [];
  List<ParticipantsModel> callingTo;
  Map<String, dynamic> forLargStream = {};
  int count = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _auth = Provider.of<AuthProvider>(context, listen: false);
    _contactProvider = Provider.of<ContactProvider>(context, listen: false);
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    _callProvider = Provider.of<CallProvider>(context, listen: false);
    _contactProvider.getContacts(_auth.getUser.auth_token);
    _groupListProvider.getGroupList(_auth.getUser.auth_token);

    print("i AM here in home init");
    signalingClient.connect(project_id, _auth.completeAddress);
    signalingClient.onConnect = (res) {
      print("i am here in onconnect functiono $res");

      if (res == "connected") {
        sockett = true;
        isConnected = true;
        print("this is before socket iffff111 $sockett");
      }

      signalingClient.register(_auth.getUser.toJson(), project_id);
    };
    signalingClient.internetConnectivityCallBack = (mesg) {
      if (mesg == "Connected") {
        setState(() {
          isConnected = true;
        });

        showSnackbar("Internet Connected", whiteColor, Colors.green, false);

        if (sockett == false) {
          signalingClient.connect(project_id, _auth.completeAddress);

          print("I am in Re Reregister");

          remoteVideoFlag = true;

          print("here in init state register");

//signalingClient.register(_auth.getUser.toJson(), project_id);

        }

        if (inCall == true) {
          iscallReConnected = true;
        }
      } else {
        print("onError no internet connection");

        setState(() {
          isConnected = false;

          sockett = false;
        });

        showSnackbar("No Internet Connection", whiteColor, primaryColor, true);

        signalingClient.closeSocket();
      }
    };

    signalingClient.onError = (code, res) {
      print("onError $code $res");

      if (code == 1001 || code == 1002) {
        print("fk9tt");

        //  isInternetConnect = true;
        // signalingClient.connect(project_id, authProvider.completeAddress);
        signalingClient.sendPing(registerRes["mctoken"]);
        setState(() {
          sockett = false;

          isRegisteredAlready = false;
        });
      } else if (code == 401) {
        print("here in 401");
        setState(() {
          sockett = false;
          isRegisteredAlready = true;

          snackBar = SnackBar(
            content: Text('$res'),
            duration: Duration(days: 365),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        if (_auth.loggedInStatus == Status.LoggedOut) {
        } else {
          setState(() {
            sockett = false;
            // isRegisteredAlready=false;
          });
          if (isResumed) {
            // if (_auth.loggedInStatus == Status.LoggedOut) {
            // } else {
            if (isConnected && sockett == false && !isRegisteredAlready) {
              print("i am in connect in 1005");
              signalingClient.connect(project_id, _auth.completeAddress);

              // signalingClient.register(_auth.getUser.toJson(), project_id);

              // sockett = true;
            } else {
              //  sockett = false;
            }
            //}
          } else {}
        }
      }
    };

    signalingClient.onRegister = (res) {
      setState(() {
        registerRes = res;
      });
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
      setState(() {
        rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
      });
    };
    signalingClient.onRemoteStream = (stream, refid) async {
      print("HI1 i am here in remote stream");
      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };
      await initRenderers(temp["rtcVideoRenderer"]);
      setState(() {
        temp["rtcVideoRenderer"].srcObject = stream;
        if (iscallReConnected == false) {
          _time = DateTime.now();
          _callTime = DateTime.now();
        } else {
          _ticker.cancel();
          _time = _callTime;
          iscallReConnected = false;
        }
        _updateTimer();
        _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
        rendererListWithRefID.add(temp);
        forLargStream = temp;
        onRemoteStream = true;
      });
      if (forLargStream.isEmpty) {
        setState(() {
          forLargStream = temp;
        });
      }
      if (_callticker != null) {
        _callticker.cancel();
        count = 0;
        iscallAcceptedbyuser = true;
      }
      audioPlayer.stop();
    };
    signalingClient.onReceiveCallFromUser =
        (receivefrom, type, isonetone, callType, sessionType) async {
      Wakelock.toggle(enable: true);
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
      _callProvider.callReceive();
      _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
    };
    signalingClient.onTargetAlerting = () {
      setState(() {
        isRinging = true;
      });
    };
    signalingClient.onParticipantsLeft = (refID, receive) async {
      print("this is participant left reference id $refID");
      if (refID == _auth.getUser.ref_id) {
      } else {
        int index = rendererListWithRefID
            .indexWhere((element) => element["refID"] == refID);
        print("this is indexxxxxxx $index");
        setState(() {
          rendererListWithRefID.removeAt(index);
        });
      }
    };
    signalingClient.unRegisterSuccessfullyCallBack = () {
      _auth.logout();
    };
    signalingClient.onCallAcceptedByUser = () async {
      inCall = true;
      iscallAcceptedbyuser = true;
      audioPlayer.stop();
      if (iscallReConnected == false) {
        _time = DateTime.now();
        _callTime = DateTime.now();
      } else {
        _ticker.cancel();
        _time = _callTime;
        iscallReConnected = false;
      }
      _updateTimer();
      _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
      _callProvider.callStart();
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      print("this is on call hung by the user $_ticker");
      audioPlayer.stop();
      if (inPaused) {
        print("here in paused");

        signalingClient.closeSocket();
      }

      if (Platform.isIOS) {
        if (inInactive) {
          print("here in paused");

          signalingClient.closeSocket();
        }
      }
//       if (inPaused) {

// print("here in paused");

// signalingClient.closeSocket();

// }
      //.toggle(enable: false);
      inCall = false;
      if (_ticker != null) {
        _ticker.cancel();
      }
      if (_callticker != null) {
        _callticker.cancel();
        count = 0;
        iscallAcceptedbyuser = false;
      }
      setState(() {
        callTo = "";
        _pressDuration = "";
        upstream = 0;
        downstream = 0;
        isRinging = false;
      });
      _callProvider.initial();
      disposeAllRenderer();
      stopRinging();
    };
    signalingClient.onCallBusyCallback = () {
      Wakelock.toggle(enable: false);
      _callProvider.initial();
      snackBar = SnackBar(content: Text('User is busy with another call.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    };
    signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
      int index = rendererListWithRefID
          .indexWhere((element) => element["refID"] == refID);
      setState(() {
        rendererListWithRefID[index]["remoteVideoFlag"] = videoFlag;
        rendererListWithRefID[index]["remoteAudioFlag"] = audioFlag;
      });
    };
  }

  showSnackbar(text, Color color, Color backgroundColor, bool check) {
    print("Hi!!! i am here in snackbar");
    if (check == false) {
      rootScaffoldMessengerKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 2),
        ));
    } else if (check == true) {
      rootScaffoldMessengerKey.currentState
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(days: 365),
        ));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("this is changeapplifecyclestate");

    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");

        isResumed = true;
        inInactive = false;
        inPaused = false;

        if (_auth.loggedInStatus == Status.LoggedOut) {
        } else {
          print("this is variable for resume $sockett $isConnected");

          signalingClient.sendPing(registerRes["mcToken"]);
        }

        break;

      case AppLifecycleState.inactive:
        inInactive = true;
        isResumed = false;
        inPaused = false;

        if (Platform.isIOS) {
          if (inCall == true) {
            print("incall true");
          } else {
            print("here in ininactive");

            signalingClient.closeSocket();
          }
        }
        print("app in inactive");

        break;

      case AppLifecycleState.paused:
        print("app in paused");

        inPaused = true;
        inInactive = false;
        isResumed = false;

        if (inCall == true) {
          print("incall true");
        } else {
          print("incall false");

          signalingClient.closeSocket();
        }

        break;

      case AppLifecycleState.detached:
        print("app in detached");

        break;
    }

// super.didChangeAppLifecycleState(state);

// _isInForeground = state == AppLifecycleState.resumed;
  }

  disposeAllRenderer() async {
    for (int i = 0; i < rendererListWithRefID.length; i++) {
      if (i == 0) {
        rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
      } else
        await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
    }
    if (rendererListWithRefID.length > 1) {
      rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));
    }
  }

  Future<void> listenSensor() async {
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   FlutterError.dumpErrorToConsole(details);
    // };
    // _streamSubscription = ProximitySensor.events.listen((int event) {
    //   print(event);
    //   if (event > 0) {
    //     Screen.keepOn(false);
    //     Screen.keepOn(true);
    //   } else {}
    //   //   setState(() {
    //   //     _isNear = (event > 0) ? true : false;
    //   //      if(_isNear){
    //   //   print("i am here is screen hand true $_isNear");
    //   //   Screen.setBrightness(0);
    //   //   Screen.keepOn(false);
    //   // }
    //   //   });
    // });
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
    // UIDevice.current.isProximityMonitoringEnabled = true;
    meidaType = mtype;
    final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');

    await file.writeAsBytes(
        (await rootBundle.load("assets/sound/audio.mp3")).buffer.asUint8List());

    int status = await audioPlayer.play(file.path, isLocal: true);

    print("this is call type in home page ...$meidaType ");
    Wakelock.toggle(enable: true);
    List<String> groupRefIDS = [];
    to.participants.forEach((element) {
      if (_auth.getUser.ref_id != element.ref_id)
        groupRefIDS.add(element.ref_id.toString());
    });

    _callticker = Timer.periodic(Duration(seconds: 1), (_) => _callcheck());
    // count=count+1;
    //  print("i am here in start call timerrrrr $count.....$iscallAcceptedbyuser");
    callingTo = to.participants;
    callingTo.removeWhere((element) => element.ref_id == _auth.getUser.ref_id);
    rendererListWithRefID.first["remoteVideoFlag"] =
        mtype == MediaType.video ? 1 : 0;
    signalingClient.startCall(
        from: _auth.getUser.ref_id,
        to: groupRefIDS,
        mcToken: registerRes["mcToken"],
        meidaType: mtype,
        callType: callType,
        sessionType: sessionType);
    _callProvider.callDial();
  }

  initRenderers(RTCVideoRenderer rtcRenderer) async {
    await rtcRenderer.initialize();
  }

  _callcheck() {
    print("i am here in call chck  function $count $iscallAcceptedbyuser");
    count = count + 1;
    if (count == 30 && iscallAcceptedbyuser == false) {
      print("I am here in stopcall if");
      _callticker.cancel();
      count = 0;
      signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
      _callProvider.initial();
      iscallAcceptedbyuser = false;
    } else if (count == 30 && iscallAcceptedbyuser == true) {
      _callticker.cancel();
      count = 0;
      print("I am here in stopcall call accept true");
      iscallAcceptedbyuser = false;
    } else if (iscallAcceptedbyuser == true) {
      _callticker.cancel();
      print("I am here in emptyyyyyyyyyy stopcall call accept true");
      count = 0;
      iscallAcceptedbyuser = false;
    } else {}
  }

  void callbackDispatcher() {
    print('callbackDispatcher');
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false,
      // Android only - API >= 28
      volume: 1,
      // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );

    // return Future.value(true);
    //});
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
    vibrationList.clear();
    Vibration.cancel();
    FlutterRingtonePlayer.stop();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("this is state of App change $state");
  //   if (state == AppLifecycleState.detached) {
  //     // if app swipe killed from background
  //     signalingClient.unRegister(registerRes["mcToken"]);
  //   } else if (state == AppLifecycleState.inactive) {
  //     // if app go to background
  //   } else if (state == AppLifecycleState.paused) {
  //     // if app in background and app go to in paused State
  //   } else if (state == AppLifecycleState.resumed) {
  //     // if app open from background
  //   }
  // }

  @override
  dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Future<Null> refreshList() async {
    print("this is in refresh list $isConnected....$sockett");
    if (sockett == false) {
      print("i am in connect in 1005");

      signalingClient.connect(project_id, _auth.completeAddress);

//signalingClient.register(_auth.getUser.toJson(), project_id);

// sockett = true;

    }
    renderList();
    return;
  }

  Future<bool> _onWillPop() async {
    print("this is string last ");
    print("this is incall vaiableee $inCall");
    if (inCall) {
      MoveToBackground.moveTaskToBack();
      print("thissssssskbncjvbcvj");
      return false;
    }

// else

// { return true;}
    else if (strArr.last == "ContactList") {
      print("jere on contact ;isr");
      _groupListProvider.handleGroupListState(ListStatus.Scussess);
    } else {
      print("i a, hereeeeeeeeddvdv");
      SystemNavigator.pop();
      //  _groupListProvider.handleGroupListState(ListStatus.Scussess);
    }
    return false;
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
    snackBar = SnackBar(
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
    Wakelock.toggle(enable: false);
    print("i am here iin stopc sdsxfssd");
    signalingClient.stopCall(registerRes["mcToken"]);
    //here
    // _callBloc.add(CallNewEvent());
    //audioPlayer.stop();
    isPushed = false;
    //  print("i am here in stop call function");
    if (_ticker != null) {
      _ticker.cancel();
    }
    //    print("THIS IS CALL STATUS ${_callProvider.callStatus}");
    setState(() {
      callTo = "";
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
            content: Text('Are you sure you want to delete this chatroom?'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCEL',
                          style: TextStyle(color: chatRoomColor))),
                  FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _groupListProvider.deleteGroup(
                          group_id,
                          _auth.getUser.auth_token,
                        );
                        if (_groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Success) {
                          showSnakbar(_groupListProvider.successMsg);
                        } else if (_groupListProvider.deleteGroupStatus ==
                            DeleteGroupStatus.Failure) {
                          showSnakbar(_groupListProvider.errorMsg);
                        } else {}
                      },
                      child: Text('DELETE',
                          style: TextStyle(color: chatRoomColor)))
                ],
              )
            ],
          );
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
    // final List<String> accelerometer =
    // _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    // final List<String> gyroscope =
    // _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    // final List<String> userAccelerometer = _userAccelerometerValues
    //     ?.map((double v) => v.toStringAsFixed(1))
    //     ?.toList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    signalingClient.onCallStatsuploads = (uploadstats) {
      var nummm = uploadstats;
      String dddi = nummm.toString();
      double myDouble = double.parse(dddi);
      assert(myDouble is double);
      upstream = double.parse((myDouble / 1024).toStringAsFixed(2));
    };
    signalingClient.onCallstats = (timeStatsdownloads, timeStatsuploads) {
      number = timeStatsdownloads;
      String ddd = number.toString();
      double myDouble = double.parse(ddd);
      assert(myDouble is double);
      downstream = double.parse((myDouble / 1024).toStringAsFixed(2));
    };
    // if (isdev == true && sockett == false) {
    //   if (inCall == true) {
    //     iscallReConnected = true;
    //   }
    //   if (isSocketregis == false) {
    //     isSocketregis = true;
    //     signalingClient.connect(project_id, _auth.completeAddress);
    //     signalingClient.register(_auth.getUser.toJson(), project_id);
    //     isPushed = false;
    //     signalingClient.onRegister = (res) {
    //       setState(() {
    //         registerRes = res;
    //       });
    //     };
    //   }
    // }
    if (!ResponsiveWidget.isSmallScreen(context))
      return WebScreen();
    else
      return Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          if (callProvider.callStatus == CallStatus.CallReceive)
            return CallReceiveScreen(
              authprovider: _auth,
              callprovider: callProvider,
              callingto: callingTo,
              incomingfrom: incomingfrom,
              registerRes: registerRes,
              rendererListWithRefid: rendererListWithRefID,
              mediatype: meidaType,
              stopRinging: stopRinging,
            );
          if (callProvider.callStatus == CallStatus.CallStart) {
            return CallSttartScreen(
              callto: callTo,
              registerRes: registerRes,
              rendererListWithRefid: rendererListWithRefID,
              onRemotestream: onRemoteStream,
              pressduration: _pressDuration,
              incomingfrom: incomingfrom,
              stopcall: stopCall,
              mediatype: meidaType,
              contactprovider: _contactProvider,
            );
          }
          if (callProvider.callStatus == CallStatus.CallDial)
            return CallDialScreen(
              callingto: callingTo,
              mediatype: meidaType,
              registerRes: registerRes,
              rendererListWithRefid: rendererListWithRefID,
              callprovider: callProvider,
            );
          else
            return WillPopScope(
                onWillPop: _onWillPop,
                child: SafeArea(
                  child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: chatRoomBackgroundColor,
                      appBar: CustomAppBar(
                        isConnect: isConnected,
                        handlePress: handleCreateGroup,
                      ),
                      body: Consumer2<ContactProvider, GroupListProvider>(
                        builder: (context, contact, groupProvider, child) {
                          if (groupProvider.groupListStatus ==
                              ListStatus.Loading)
                            return Center(
                                child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(chatRoomColor),
                            ));
                          else if (groupProvider.groupListStatus ==
                              ListStatus.Scussess) {
                            if (groupProvider.groupList.groups.length == 0) {
                              strArr.add("Home");
                              return NoContactsScreen(
                                  isConnect: isConnected,
                                  state: widget.state,
                                  refreshList: renderList,
                                  groupListProvider: groupProvider,
                                  authProvider: _auth,
                                  socket:sockett,
                                  registerRes: registerRes,
                                  newChatHandler: handleGroupState);
                            } else {
                              print("here in grou screeeen");
                              strArr.add("Home");
                              return GroupListScreen(
                                  authprovider: _auth,
                                  registerRes: registerRes,
                                  isdev: isConnected,
                                  sockett: sockett,
                                  state: groupProvider.groupList,
                                  startCall: _startCall,
                                  showdialogdeletegroup: _showDialogDeletegroup,
                                  mediatype: meidaType,
                                  grouplistprovider: _groupListProvider,
                                  groupNameController: _groupNameController,
                                  refreshList: refreshList);
                            }
                          } 
                          else if (groupProvider.groupListStatus ==
                              ListStatus.Failure) {
                            return Center(
                              child: Text(
                                "${groupProvider.errorMsg}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          //Create group Screen
                          else {
                            strArr.add("ContactList");
                            return ContactListScreen(
                                refreshcontactList: refreshList,
                                searchController: _searchController,
                                selectedContact: _selectedContacts,
                                state: contact,
                                isConnect: isConnected);
                          }
                        },
                      )),
                ));
        },
      );
  }
}
