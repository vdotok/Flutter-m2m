import 'package:flutter/foundation.dart';
import 'package:vdotok_stream_example/src/core/models/GroupListModel.dart';
import '../models/GroupModel.dart';
import '../services/server.dart';

enum ListStatus { Scussess, Failure, Loading, CreateGroup }

class GroupListProvider with ChangeNotifier {
  ListStatus _groupListStatus = ListStatus.Loading;
  ListStatus get groupListStatus => _groupListStatus;

  GroupListModel _groupList;
  GroupListModel get groupList => _groupList;

  String _errorMsg;
  String get errorMsg => _errorMsg;

  int _status;
  int get status => _status;

  handleGroupListState(ListStatus state) {
    print("This is handle group list state");
    _groupListStatus = state;
    notifyListeners();
  }

  getGroupList(authToken) async {
    if (_groupListStatus != ListStatus.Loading) {
      _groupListStatus = ListStatus.Loading;
      notifyListeners();
    }
    var currentData = await getAPI("AllGroups", authToken);
    print(
        "Current Data: ${currentData["status"]}......${currentData["groups"]}");
    print(
        "this is model list data ########## ${GroupListModel.fromJson(currentData)}");

    if (currentData["status"] != 200) {
      _groupListStatus = ListStatus.Failure;
      _errorMsg = currentData['message'];
      notifyListeners();
    } else {
      _groupListStatus = ListStatus.Scussess;
      _groupList = GroupListModel.fromJson(currentData);

      // _readmodelList = [];
      notifyListeners();
    }
  }

  addGroup(dynamic groupModel) {
    print("this is add group");
    _groupList.groups.insert(0, GroupModel.fromJson(groupModel));
    notifyListeners();
  }

  Future<dynamic> createGroup(groupName, _selectedContacts, authToken) async {
    List<int> id_List = [];
    for (int i = 0; i < _selectedContacts.length; i++) {
      id_List.add(_selectedContacts[i].user_id);
      print("Here id List: $id_List");
    }
    var newtemp = {
      'group_title': groupName,
      'participants': id_List,
      'auto_created': _selectedContacts.length == 1 ? 1 : 0
    };

    print("newtemp  .... ${newtemp}");
    final response = await callAPI(newtemp, "CreateGroup", authToken);
    print("the current data is: $response");
    return response;
    //  notifyListeners();
  }
}
