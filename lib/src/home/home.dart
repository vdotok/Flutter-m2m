import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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
import 'dart:io' show Platform;
import '../../constant.dart';
import '../core/providers/auth.dart';
import '../core/providers/call_provider.dart';
import '../core/providers/contact_provider.dart';
 SignalingClient signalingClient = SignalingClient.instance;
class Home extends StatefulWidget {
  final state;
  Home({this.state});
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Contact> _selectedContacts = [];
  List<String> strArr = [];
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
    }  }
  GlobalKey forsmallView = new GlobalKey();
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  String incomingfrom;
  CallProvider _callProvider;
  AuthProvider _auth;
  bool enableCamera = true;
  bool switchMute = true;
  bool switchSpeaker = true;
  bool secondRemoteVideo = false;
  String callTo = "";
  var number;
  final _searchController = new TextEditingController();
  bool sockett = true;
  bool isSocketregis = false;
  List<int> vibrationList = [ 500, 1000,500, 1000,  500,1000,500,  1000,   500,  1000,  500,  1000,  500,  1000, 500,  1000,  500,  1000,  500,  1000,  500,  1000,500,1000,500,1000, 500,1000, 500, 1000, 500,1000,500, 1000,500,1000,500,1000,500,1000,500, 1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000,500,1000];
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
  @override
  void initState() {
    super.initState();
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
      if (res == "connected") {
        sockett = true;
      }
      signalingClient.register(_auth.getUser.toJson(), project_id);
    };
    signalingClient.onError = (code, res) {
      if (code == 1002 || code == 1001) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
        isdev = false;
      } else {}
      if (code == 1005) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
        isdev = false;
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
          _time = _callTime;
          iscallReConnected = false;
        }
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
    };
    signalingClient.onReceiveCallFromUser =
        (receivefrom, type, isonetone) async {
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
    };
    signalingClient.onParticipantsLeft = (refID) async {
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
      inCall = true;
      _callProvider.callStart();
    };
    signalingClient.onCallHungUpByUser = (isLocal) {
      inCall = false;
      setState(() {
        _pressDuration = "";
        upstream = 0;
        downstream = 0;
      });
      _callProvider.initial();
      disposeAllRenderer();
      stopRinging();   };
    signalingClient.onCallBusyCallback = () {
      _callProvider.initial();
      final snackBar =
          SnackBar(content: Text('User is busy with another call.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
      });
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
  void checkConnectivity() async {
    isDeviceConnected = false;
    if (!kIsWeb) {
      DataConnectionChecker().onStatusChange.listen((status) async {
        isDeviceConnected = await DataConnectionChecker().hasConnection;
        if (isDeviceConnected == true) {
          setState(() {
            isdev = true;
          });
        } else {
          setState(() {
            isdev = false;
          });
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
    if (rendererListWithRefID.length > 1) {
      rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));
    }
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
    to.participants.forEach((element) {
      if (_auth.getUser.ref_id != element.ref_id)
        groupRefIDS.add(element.ref_id.toString());
    });

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
    _ticker.cancel();
    super.dispose();
  }
  Future<Null> refreshList() async {
    renderList();
    return;
  }
 Future<bool> _onWillPop() async {
    print("this is string last ${strArr.last}");
    if(strArr.last=="ContactList"){
       _groupListProvider.handleGroupListState(ListStatus.Scussess);
    }
    else{
      Navigator.pop(context);
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
    if (isdev == true && sockett == false) {
      if (inCall == true) {
        iscallReConnected = true;
      }
      if (isSocketregis == false) {
        isSocketregis = true;
        signalingClient.connect(project_id, _auth.completeAddress);
        signalingClient.register(_auth.getUser.toJson(), project_id);
        isPushed = false;
        signalingClient.onRegister = (res) {
          setState(() {
            registerRes = res;
          });
        };
      }
    }
    if (!ResponsiveWidget.isSmallScreen(context))
    return WebScreen();
    else
      return Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          if (callProvider.callStatus == CallStatus.CallReceive)
             return CallReceiveScreen(authprovider: _auth,callprovider: callProvider,callingto: callingTo,incomingfrom: incomingfrom,registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,mediatype: meidaType,stopRinging: stopRinging,);
          if (callProvider.callStatus == CallStatus.CallStart) {
             return CallSttartScreen(callto: callTo,switchmute: switchMute,switchspeaker: switchSpeaker,enablecamera: enableCamera,registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,onRemotestream: onRemoteStream,pressduration: _pressDuration,incomingfrom: incomingfrom,stopcall: stopCall,mediatype: meidaType,contactprovider: _contactProvider,);}
          if (callProvider.callStatus == CallStatus.CallDial)
             return CallDialScreen(callingto: callingTo,mediatype: meidaType,registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,callprovider: callProvider,);
          else
             return WillPopScope(onWillPop: _onWillPop,
             child:
               SafeArea( child: Scaffold(resizeToAvoidBottomInset: true,backgroundColor: chatRoomBackgroundColor,
                  appBar: CustomAppBar(handlePress: handleCreateGroup,),
                  body: Consumer2<ContactProvider, GroupListProvider>(
                    builder: (context, contact, groupProvider, child) {
                      if (groupProvider.groupListStatus == ListStatus.Loading)
                        return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(chatRoomColor),));
                      else if (groupProvider.groupListStatus == ListStatus.Scussess) {
                        if (groupProvider.groupList.groups.length == 0)
                        {
                          strArr.add("Home");
                          return NoContactsScreen(isConnect: sockett,state: widget.state,refreshList: renderList,groupListProvider: groupProvider,authProvider: _auth,newChatHandler: handleGroupState);}
                        else
                        {
                          strArr.add("Home");
                         return GroupListScreen(authprovider: _auth, registerRes: registerRes,isdev: isdev,sockett: sockett,state: groupProvider.groupList,startCall: _startCall,showdialogdeletegroup: _showDialogDeletegroup,mediatype: meidaType,grouplistprovider: _groupListProvider,groupNameController: _groupNameController,refreshList: refreshList,);}
                      } 
                      //Create group Screen
                      else
                      {
                        strArr.add("ContactList");
                       return ContactListScreen(refreshcontactList: refreshList,searchController: _searchController, selectedContact: _selectedContacts,state: contact,);}
                    },
                  )),
               )  );
        },
      );
  } 
}