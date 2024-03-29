import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vdotok_stream_example/src/core/config/config.dart';
import 'package:vdotok_stream_example/src/core/models/contact.dart';
import 'package:vdotok_stream_example/src/home/CallDialScreen/callDialScreen.dart';
import 'package:vdotok_stream_example/src/home/CallReceiveScreen/callReceiveScreen.dart';
import 'package:vdotok_stream_example/src/home/CallStartScreen/callStartScreen.dart';
import 'package:vdotok_stream_example/src/home/ContactListScreen/contactList.dart';
import 'package:vdotok_stream_example/src/home/GroupListScreen/groupListScreen.dart';
import 'package:vdotok_stream_example/src/home/NoContactScreen/noContactsScreen.dart';
import 'package:vdotok_stream_example/src/common/customAppBar.dart';
import 'package:vdotok_stream_example/src/core/models/GroupModel.dart';
import 'package:vdotok_stream_example/src/core/models/ParticipantsModel.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';

import 'package:vdotok_stream_example/src/home/CreateGroupPopUp.dart';

import 'package:provider/provider.dart';

import 'package:wakelock/wakelock.dart';
import 'dart:io' show File, Platform, sleep;
import '../../constant.dart';
import '../../main.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';

SignalingClient signalingClient = SignalingClient.instance;
String callTo = "";
bool switchMute = true;
bool switchSpeaker = true;
bool enableCamera = true;
bool isRinging = false;
List<Map<String, dynamic>> rendererListWithRefID = [];
var snackBar;
String errorcode = "";
bool noInternetCallHungUp = false;
String groupName = "";
DateTime? time;
bool isConnected = true;
bool isRegisteredAlready = false;
bool isPressed = false;
GlobalKey forsmallView = new GlobalKey();

class Home extends StatefulWidget {
  final state;
  Home({this.state});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Contact> _selectedContacts = [];
  List<String> strArr = [];
  Timer? _ticker;
  Timer? _callticker;
  String pressDuration = "";
  late DateTime _callTime;
  bool iscalloneto1 = false;
  bool inCall = false;
  bool isPushed = false;
  bool iscallReConnected = false;
  bool isConnectedtoCall = false;
  bool isResumed = true;
  bool inPaused = false;
  bool inInactive = false;
  String meidaType = MediaType.video;
  bool remoteVideoFlag = true;
  late Map<String, dynamic> customData;
  bool remoteAudioFlag = true;
  bool onRemoteStream = false;
  late ContactProvider _contactProvider;
  late GroupListProvider _groupListProvider;
  final _groupNameController = TextEditingController();
  List<ParticipantsModel?>? callingTo;
  Map<String, dynamic> forLargStream = {};
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  String? incomingfrom;
  late CallProvider _callProvider;
  late AuthProvider _auth;
  final _searchController = new TextEditingController();
  bool sockett = true;
  bool iscallAcceptedbyuser = false;
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

  void _updateTimer() {
    var duration;
    duration = DateTime.now().difference(time!);
    final newDuration = _formatDuration(duration);
    setState(() {
      pressDuration = newDuration;
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
    // InternetConnectivity();

    print("i AM here in home init");
    signalingClient.connect( _auth.deviceId,
        project_id,
        _auth.completeAddress,
        _auth.getUser.authorization_token.toString(),
        _auth.getUser.ref_id.toString());
    signalingClient.onConnect = (res) {
      print("i am here in onconnect functiono $res");

      if (res == "connected") {
        sockett = true;
        // isConnected = true;
        print("this is before socket iffff111 $sockett");
        errorcode = "";
      }

      // signalingClient.register(_auth.getUser.toJson(), project_id);
    };

    signalingClient.internetConnectivityCallBack = (mesg) {
      if (mesg == "Connected") {
        setState(() {
          if (isConnectedtoCall == true) {
            print("fdjhfjd");
            iscallReConnected = true;
          }
          isConnected = true;
        });
        // if (isResumed) {
        Fluttertoast.showToast(
            msg: "Connected to Internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
        // }

        if (sockett == false) {
          // signalingClient.connect(
          //     _auth.projectId,
          //     _auth.completeAddress,
          //     _auth.getUser.authorization_token.toString(),
          //     _auth.getUser.ref_id.toString());
          print("I am in Re Reregister ");
          remoteVideoFlag = true;
          print("here in init state register");
        }
      } else {
        print("onError no internet connection");
        setState(() {
          isConnected = false;
          sockett = false;
        });
        //  if (isResumed) {
        Fluttertoast.showToast(
            msg: "Waiting for Internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
        // }
        signalingClient.closeSocket();

        print("uyututuir");
      }
    };
    signalingClient.onMissedCall = (mesg) {
      print("here in onmissedcall");
    };
    signalingClient.onError = (code, reason) async {
      print("this is socket error $code $reason");
      if (!mounted) {
        return;
      }
      setState(() {
        sockett = false;
      });

      if (_auth.loggedInStatus == Status.LoggedOut) {
      } else {
        bool status = await signalingClient.getInternetStatus();

        print("this is internet status $status"); 

        if (sockett == false && status == true) {
          print("here in onerrorrrrrr ");

          // signalingClient.connect(
          //     _auth.projectId,
          //     _auth.completeAddress,
          //     _auth.getUser.authorization_token.toString(),
          //     _auth.getUser.ref_id.toString());
        } else {
          print("else condition");
        }
      }
    };

    signalingClient.onRegister = (res) {
      print("here in register $res");
      setState(() {
        registerRes = res;
      });
    };

    signalingClient.onLocalStream = (stream) async {
      print("this is local streammmm");
      Map<String, dynamic> temp = {
        "refID": _auth.getUser.ref_id,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };
      await initRenderers(temp["rtcVideoRenderer"]).then((value) {
        setState(() {
          if (rendererListWithRefID.isEmpty) {
            rendererListWithRefID.add(temp);
            rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
          } else {
            print("9e472894y74");
          }
        });
      });
    };

    signalingClient.onRemoteStream = (stream, refid) async {
      if (noInternetCallHungUp == true) {
        print('this issussus $noInternetCallHungUp');
        signalingClient.stopCall(registerRes["mcToken"]);
        return;
        //signalingClient.closeSession(true);
      }
      print(
          "HI1 i am here in remote stream ${rendererListWithRefID.length} $refid $stream ${stream.id} ");
      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == MediaType.video ? 1 : 0,
        "remoteAudioFlag": 1
      };

      await initRenderers(temp["rtcVideoRenderer"]).then((value) {
        setState(() {
          temp["rtcVideoRenderer"].srcObject = stream;
          if (isConnectedtoCall) {
            iscallReConnected = true;
          }
          if (iscallReConnected == false) {
            time = DateTime.now();
            _callTime = DateTime.now();
          } else {
            _ticker!.cancel();
            time = _callTime;
            iscallReConnected = false;
          }

          rendererListWithRefID.add(temp);
          isConnectedtoCall = true;
          forLargStream = temp;
          onRemoteStream = true;
        });
        _updateTimer();
        _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
        if (forLargStream.isEmpty) {
          setState(() {
            forLargStream = temp;
          });
        }
        if (_callticker != null) {
          _callticker!.cancel();
          iscallAcceptedbyuser = true;
        }
      });
    };

    signalingClient.onCallDial = () {
      // if(ispublicbroadcast==false){
      _callProvider.callDial();
    };
    signalingClient.onReceiveCallFromUser = (res, isMultiSession) async {
      inCall = true;
      print("here in recerive call $res");

      Wakelock.toggle(enable: true);

      iscalloneto1 = res["callType"] == "one_to_one" ? true : false;
      print("ugdghfghf ${res["data"]["groupName"]}");
      setState(() {
        groupName = res["data"]["groupName"];
        onRemoteStream = false;
        pressDuration = "";
        incomingfrom = res["from"];
        meidaType = res["mediaType"];
        switchMute = true;
        enableCamera = true;
        switchSpeaker = res["mediaType"] == MediaType.audio ? true : false;
        remoteVideoFlag = true;
        remoteAudioFlag = true;
      });
      _callProvider.callReceive();
      if (_callticker != null) {
        _callticker!.cancel();
        _callticker = Timer.periodic(Duration(seconds: 30), (_) => _callcheck());
      } else {
        _callticker = Timer.periodic(Duration(seconds: 30), (_) => _callcheck());
      }
    };
    signalingClient.onTargetAlerting = () {
      setState(() {
        isRinging = true;
      });
    };
    signalingClient.onParticipantsLeft = (refID, receive, ishandle) async {
      print("this is participant left reference id $refID");
      if (refID == _auth.getUser.ref_id) {
      } else {
        int index = rendererListWithRefID
            .indexWhere((element) => element["refID"] == refID);
        print("this is indexxxxxxx $index");
        setState(() {
          if (index != -1) {
            rendererListWithRefID.removeAt(index);
          }
          print("list length ${rendererListWithRefID.length}");
        });
      }
    };
    signalingClient.unRegisterSuccessfullyCallBack = () {
      _auth.logout();
    };
    signalingClient.onCallAcceptedByUser = () async {
      setState(() {
        inCall = true;
         iscallAcceptedbyuser = true;
      });
      _callProvider.callStart();
       
    };
    signalingClient.insufficientBalance = (res) {
      print("here in insufficient balance");
      snackBar = SnackBar(content: Text('$res'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      print("this is on call hung by the user $_ticker $inCall $_callticker");

      if (inPaused) {
        print("here in paused");
      }
      if (kIsWeb) {
      } else {
        if (Platform.isIOS) {
          if (inInactive) {
            print("here in paused");
          }
        }
      }
      if (inCall) {
        if (_callticker != null) {
          _callticker!.cancel();
        }
      }
      setState(() {
        isPressed = false;
        inCall = false;
        iscallReConnected = false;
        isRinging = false;
        noInternetCallHungUp = false;
        callTo = "";
        pressDuration = "";
        isConnectedtoCall = false;
  iscallAcceptedbyuser = false;
        isRinging = false;
        if (_ticker != null) {
          _ticker!.cancel();
        }
      });

      disposeAllRenderer().then((value) {
        print("here in before then");
        _callProvider.initial();
        print("callprovider initial");
      }).catchError((onError) {
        print("this is error on disposing $onError");
      });

      //  stopRinging();
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
        if (index != -1) {
          rendererListWithRefID[index]["remoteVideoFlag"] = videoFlag;
          rendererListWithRefID[index]["remoteAudioFlag"] = audioFlag;
        } else {}
      });
    };
  }

  showSnackbar(text, Color color, Color backgroundColor, bool check) {
    print("Hi!!! i am here in snackbar $check");
// if(isResumed)
//    {
    if (check == false) {
      rootScaffoldMessengerKey!.currentState!
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
      rootScaffoldMessengerKey!.currentState!
        ..showSnackBar(SnackBar(
          content: Text(
            '$text',
            style: TextStyle(color: color),
          ),
          backgroundColor: backgroundColor,
          duration: Duration(days: 365),
        ));
      // }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("this is changeapplifecyclestate $state");

    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");

        isResumed = true;
        inInactive = false;
        inPaused = false;

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

            //  signalingClient.closeSocket();
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
          print("incall trueeee");
        } else {
          print("incall falseeeeeeee");

          // signalingClient.closeSocket();
        }

        break;

      case AppLifecycleState.detached:
        print("app in detached");

        break;
    }
  }

  Future<void> disposeAllRenderer() async {
    print("here in before thennnnn");
    print("this is list before dispose ${rendererListWithRefID.length}");

    for (int i = 0; i < rendererListWithRefID.length; i++) {
      if (i == 0) {
        print("indisposerenderer");
         rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
      } else {
        print("this is disposessss");
        await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
     }
    }

    rendererListWithRefID.clear();
    print("this is list after dispose ${rendererListWithRefID.length}");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("this is deactivated of home");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("this is didchange depenedencidessss");
    // The previous oldWidget.value != newWidget.value is done by ValueNotifier itself
    //  _valueNotifier.value = widget.value;
  }

  Future<void> listenSensor() async {}

  _startCall(
      GroupModel to, String mtype, String callType, String sessionType) async {
    setState(() {
      inCall = true;
      switchMute = true;
      pressDuration = "";
      enableCamera = true;
      onRemoteStream = false;
      switchSpeaker = mtype == MediaType.audio ? true : false;
    });
    // UIDevice.current.isProximityMonitoringEnabled = true;
    meidaType = mtype;
    // final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');

    // await file.writeAsBytes(
    //     (await rootBundle.load("assets/sound/audio.mp3")).buffer.asUint8List());

    // int status = await audioPlayer.play(file.path, isLocal: true);

    print("this is call type in home page ...$meidaType ");
    Wakelock.toggle(enable: true);
    List<String> groupRefIDS = [];
    to.participants.forEach((element) {
      if (_auth.getUser.ref_id != element!.ref_id)
        groupRefIDS.add(element.ref_id.toString());
    });
    if (_callticker != null) {
      _callticker!.cancel();
      _callticker = Timer.periodic(Duration(seconds: 30), (_) => _callcheck());
    } else {
      _callticker = Timer.periodic(Duration(seconds: 30), (_) => _callcheck());
    }

    callingTo = to.participants;
    callingTo!
        .removeWhere((element) => element!.ref_id == _auth.getUser.ref_id);
    // rendererListWithRefID.first["remoteVideoFlag"] =
    //     mtype == MediaType.video ? 1 : 0;
    print("i am here in call chck ${to.group_title}");
    customData = {
      "calleName": "",
      "groupName": groupName,
      "groupAutoCreatedValue": ""
    };
    signalingClient.startCall(
        customData: customData,
        from: _auth.getUser.ref_id,
        to: groupRefIDS,
        mcToken: registerRes["mcToken"],
        mediaType: mtype,
        callType: callType,
        sessionType: sessionType);
    // _callProvider.callDial();

    //   });
  }

  Future<void> initRenderers(RTCVideoRenderer rtcRenderer) async {
    print("here unnnnnn");
    await rtcRenderer.initialize();
  }

  _callcheck() {
    if(iscallAcceptedbyuser==false)
{    signalingClient.stopCall(registerRes["mcToken"]);}
  }

  @override
  void dispose() {
    print("here in dispose methodddddd");
    WidgetsBinding.instance.removeObserver(this);
    if (_ticker != null) {
      _ticker!.cancel();
    }
    super.dispose();
  }

  Future<Null> refreshList() async {
    print("this is in refresh list $isConnected....$sockett");

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

  renderList() async {
    if (_groupListProvider.groupListStatus == ListStatus.Scussess) {
      _groupListProvider.getGroupList(_auth.getUser.auth_token);
    } else {
      _contactProvider.getContacts(_auth.getUser.auth_token);
      _selectedContacts.clear();
    }
    bool connectionFlag = await signalingClient.getInternetStatus();
    print("this is connectionflag $connectionFlag $sockett");
    if (sockett == false && connectionFlag) {
      print("i am in refresh list connection");

      signalingClient.connect(
         _auth.deviceId,
          project_id,
          _auth.completeAddress,
          _auth.getUser.authorization_token.toString(),
          _auth.getUser.ref_id.toString());

//signalingClient.register(_auth.getUser.toJson(), project_id);

// sockett = true;
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
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCEL',
                          style: TextStyle(color: chatRoomColor))),
                  TextButton(
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
                authProvider: _auth,
                controllerText: '',
              );
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
    // InternetWidget(online: null,);
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

    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        print("callstatusss ${callProvider.callStatus}");
        if (callProvider.callStatus == CallStatus.CallReceive)
          return CallReceiveScreen(
            groupName: groupName,
            authprovider: _auth,
            callprovider: callProvider,
            callingto: callingTo,
            incomingfrom: incomingfrom,
            registerRes: registerRes,
            rendererListWithRefid: rendererListWithRefID,
            mediatype: meidaType,
            // stopRinging: stopRinging,
          );
        if (callProvider.callStatus == CallStatus.CallStart) {
          return CallSttartScreen(
            callto: callTo,
            registerRes: registerRes,
            rendererListWithRefid: rendererListWithRefID,
            onRemotestream: onRemoteStream,
            pressduration: pressDuration,
            incomingfrom: incomingfrom,
            stopcall: stopCall,
            mediatype: meidaType,
            callprovider: callProvider,
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
                      print("dudshjg ${groupProvider.groupListStatus}");
                      if (groupProvider.groupListStatus == ListStatus.Loading)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(chatRoomColor),
                        ));
                      else if (groupProvider.groupListStatus ==
                          ListStatus.Scussess) {
                        if (groupProvider.groupList.groups!.length == 0) {
                          strArr.add("Home");
                          return NoContactsScreen(
                              isConnect: isConnected,
                              state: widget.state,
                              refreshList: refreshList,
                              groupListProvider: groupProvider,
                              authProvider: _auth,
                              socket: sockett,
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
                      } else if (groupProvider.groupListStatus ==
                          ListStatus.Failure) {
                        return Center(
                          child: Text(
                            "${groupProvider.errorMsg}",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
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
                  ),
                  //                      bottomNavigationBar: InternetWidget(
                  //  // offline: const Center(child: Text('No Internet')),
                  //   // ignore: avoid_print
                  //   whenOffline: () {
                  //     print('No Internet');
                  //     // setState(() {
                  //     //   isConnected=false;
                  //     // });
                  //     },
                  //   // ignore: avoid_print
                  //   whenOnline: ()  {
                  //     print('Connected to internet');
                  //     // setState(() {
                  //     //     isConnected=true;
                  //     // });

                  //     },
                  //   online:  BottomNavigationBar(items: [ new BottomNavigationBarItem(
                  //         icon: Icon(Icons.thumb_up),
                  //         label: "Connected",
                  //       ),
                  //       new BottomNavigationBarItem(
                  //         icon: Icon(Icons.thumb_up),
                  //         label: "Connected",
                  //       )
                  //       ],)
                  //  // online: Center(child: Text("Internet Connected"),)
                  //   //  MaterialApp(
                  //   //   title: 'Flutter Demo',
                  //   //   theme: ThemeData(
                  //   //     primarySwatch: Colors.blue,
                  //   //   ),
                  //   //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
                  //   // ),
                  //   )
                ),
              ));
      },
      //)
    );
  }
}
