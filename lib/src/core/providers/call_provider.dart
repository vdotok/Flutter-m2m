import 'package:flutter/foundation.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

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
    _remoteRendererList[refID].srcObject = null;
    notifyListeners();
  }
}
