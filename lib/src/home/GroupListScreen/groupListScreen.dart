import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream_example/constant.dart';
import 'package:vdotok_stream_example/src/core/models/GroupListModel.dart';
import 'package:vdotok_stream_example/src/core/models/GroupModel.dart';
import 'package:vdotok_stream_example/src/core/providers/auth.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'package:vdotok_stream_example/src/home/CreateGroupPopUp.dart';
import 'package:vdotok_stream_example/src/home/home.dart';

class GroupListScreen extends StatefulWidget {
  GroupListModel state;
  AuthProvider authprovider;
  String mediatype;
  final refreshList;

  GroupListProvider grouplistprovider;
  final groupNameController;
  final startCall;
  var registerRes;
  bool sockett;
  bool isdev;
  final showdialogdeletegroup;
  GroupListScreen(
      {required this.authprovider,
      required this.mediatype,
      required this.state,
      this.refreshList,
      required this.grouplistprovider,
      this.groupNameController,
      this.startCall,
      this.registerRes,
      required this.isdev,
      required this.sockett,
      this.showdialogdeletegroup});
  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  bool groupnotmatched = false;
  List _groupfilteredList = [];
  final _GroupListsearchController = new TextEditingController();
  onSearch(value) {
    print("this is here $value");
    List temp;
    temp = widget.state.groups!
        .where((element) =>
            element!.group_title.toLowerCase().startsWith(value.toLowerCase()))
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
    });
  }

  Future buildShowDialog(
      BuildContext context, String mesg, String errorMessage) {
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
                  "${mesg}",
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: widget.refreshList,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 21, right: 21),
                child: TextFormField(
                  controller: _GroupListsearchController,
                  onChanged: (value) {
                    onSearch(value);
                  },
                  validator: (value) =>
                      value!.isEmpty ? "Field cannot be empty." : null,
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
                              ? widget.state.groups!.length
                              : _groupfilteredList.length,
                          itemBuilder: (context, position) {
                            GroupModel element =
                                _GroupListsearchController.text.isEmpty
                                    ? widget.state.groups![position]
                                    : _groupfilteredList[position];
                            return Container(
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
                                    child: IconButton(
                                        icon:
                                            SvgPicture.asset('assets/call.svg'),
                                        onPressed: !widget.isdev
                                            ? () {}
                                            : isPressed
                                                ? () {}
                                                : () {
                                                    groupName =
                                                        element.group_title;
                                                    widget.startCall(
                                                        element,
                                                        MediaType.audio,
                                                        CAllType.many2many,
                                                        SessionType.call);
                                                    setState(() {
                                                      callTo =
                                                          element.group_title;
                                                      widget.mediatype =
                                                          MediaType.audio;
                                                    });
                                                    print(
                                                        "three dot icon pressed");
                                                  }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 5.9),
                                    child: IconButton(
                                        icon: SvgPicture.asset(
                                            'assets/videocallicon.svg'),
                                        onPressed: !widget.isdev
                                            ? () {}
                                            : isPressed
                                                ? () {}
                                                : () {
                                                    groupName =
                                                        element.group_title;
                                                    widget.startCall(
                                                        element,
                                                        MediaType.video,
                                                        CAllType.many2many,
                                                        SessionType.call);
                                                    setState(() {
                                                      callTo =
                                                          element.group_title;

                                                      widget.mediatype =
                                                          MediaType.video;
                                                    });
                                                    print(
                                                        "three dot icon pressed");
                                                  }),
                                  ),
                                  Consumer<GroupListProvider>(
                                      builder: (context, listProvider, child) {
                                    return Container(
                                      height: 24,
                                      width: 24,
                                      margin: EdgeInsets.only(
                                          right: 19, bottom: 15),
                                      child: PopupMenuButton(
                                          offset: Offset(8, 30),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          icon: const Icon(
                                            Icons.more_horiz,
                                            size: 24,
                                            color: horizontalDotIconColor,
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                                PopupMenuItem(
                                                  enabled: (listProvider
                                                                  .groupList
                                                                  .groups![
                                                                      position]!
                                                                  .participants
                                                                  .length ==
                                                              1 ||
                                                          listProvider
                                                                  .groupList
                                                                  .groups![
                                                                      position]!
                                                                  .participants
                                                                  .length ==
                                                              2)
                                                      ? false
                                                      : true,
                                                  padding: EdgeInsets.only(
                                                      right: 12, left: 12),
                                                  value: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
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
                                                                .circular(8)),
                                                    child: Text(
                                                      "Edit Group Name",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: font_Family,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: personNameColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                    padding: EdgeInsets.only(
                                                        right: 12, left: 12),
                                                    value: 2,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 14,
                                                            left: 16,
                                                          ),
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
                                                            "Delete",
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
                                                              color: Colors
                                                                  .red[700],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                          onSelected: (menu) {
                                            if (menu == 1) {
                                              print(
                                                  "i am in edit group name press");
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ListenableProvider<
                                                            GroupListProvider>.value(
                                                        value: widget
                                                            .grouplistprovider,
                                                        child: CreateGroupPopUp(
                                                          editGroupName: true,
                                                          groupid: listProvider
                                                              .groupList
                                                              .groups![
                                                                  position]!
                                                              .id,
                                                          controllerText:
                                                              listProvider
                                                                  .groupList
                                                                  .groups![
                                                                      position]!
                                                                  .group_title,
                                                          groupNameController:
                                                              widget
                                                                  .groupNameController,
                                                          // publishMessage:
                                                          //   publishMessage,
                                                          authProvider: widget
                                                              .authprovider,
                                                        ));
                                                  });
                                              print("i am after here");
                                            } else if (menu == 2) {
                                              widget.showdialogdeletegroup(
                                                  listProvider.groupList
                                                      .groups![position]!.id,
                                                  listProvider.groupList
                                                      .groups![position]);
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
                              child: TextButton(
                                onPressed: () {
                                  if (isRegisteredAlready) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    isRegisteredAlready = false;
                                  }
                                  signalingClient.unRegister(
                                      widget.registerRes["mcToken"]);
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
                                color: widget.sockett && widget.isdev
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            errorcode != ""
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    child: Text('$errorcode'))
                                : Container()
                          ]),
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Text(widget.authprovider.getUser.full_name))
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
