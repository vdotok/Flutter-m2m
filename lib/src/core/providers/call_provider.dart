import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
// import 'package:vdotok_stream_example/src/home/home.dart';

enum CallStatus { Initial, CallReceive, CallStart, CallDial }

class CallProvider with ChangeNotifier {
  CallStatus _callStatus = CallStatus.Initial;
  // User _user = new User();
  // User get getUser => _user;

  Map<String, RTCVideoRenderer> _remoteRendererList = {};
  Map<String, RTCVideoRenderer> get remoteRendererList => _remoteRendererList;

  CallStatus get callStatus => _callStatus;
  initial() {
    _callStatus = CallStatus.Initial;
    notifyListeners();
  }

  callReceive() {
    _callStatus = CallStatus.CallReceive;
    notifyListeners();
  }

  callStart() {
    _callStatus = CallStatus.CallStart;
    notifyListeners();
  }

  callDial() {
    _callStatus = CallStatus.CallDial;
    notifyListeners();
  }

  addRenderer(String refID, RTCVideoRenderer rtcVideoRenderer) {
    _remoteRendererList[refID] = rtcVideoRenderer;
    notifyListeners();
  }

  removeRenderer(String refID) {
    _remoteRendererList[refID]!.srcObject = null;
    notifyListeners();
  }

  // Map<String, bool> localAudioVideoStates = {
  //   "UnMuteState": false,
  //   "SpeakerState": false,
  //   "CameraState": false,
  //   "ScreenShareState": false,
  //   "isBackCamera": false
  // };
  // Map<String, bool> get getLocalAudioVideoStates => localAudioVideoStates;

  // changeAudioStates(Map<String, bool> state) {
  //   print('this is stateee----- ${state}');
  //   localAudioVideoStates = state;
  //   notifyListeners();
  // }

  // muteMic() {
  //   print('inmuteMiccc');
  //   signalingClient.muteMic(!localAudioVideoStates["UnMuteState"]!);
  // }

  // switchCamera() {
  //   print('In switchCameraaaa');
  //   if (localAudioVideoStates["CameraState"] == true) {
  //     signalingClient.switchCamera(!localAudioVideoStates["isBackCamera"]!);
  //   } else {
  //     Fluttertoast.showToast(msg: "First enable camera");
  //   }
  // }

  // enableCamera() {
  //   print('InEnableCameraaaa');
  //   signalingClient.enableCamera(!localAudioVideoStates["CameraState"]!);
  // }

  // switchSpeaker() {
  //   print('InSwitchSpeakerrrrr');
  //   signalingClient.switchSpeaker(!localAudioVideoStates["SpeakerState"]!);
  // }
}
