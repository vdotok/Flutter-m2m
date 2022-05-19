// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:vdotok_stream_example/constant.dart';
// import 'package:vdotok_stream_example/src/contactList/contactListAppbar.dart';
// import 'package:vdotok_stream_example/src/core/models/contact.dart';
// import 'package:vdotok_stream_example/src/core/providers/auth.dart';
// import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
// import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
// import 'package:vdotok_stream_example/src/home/CreateGroupPopUp.dart';
// import 'package:provider/provider.dart';

// class ContactList extends StatefulWidget {
//   const ContactList({Key key}) : super(key: key);

//   @override
//   _ContactListState createState() => _ContactListState();
// }

// class _ContactListState extends State<ContactList> {
//   ContactProvider _contactProvider;
//   // GroupListProvider _groupListProvider;
//   AuthProvider _auth;
//   final _searchController = new TextEditingController();
//   bool notmatched = false;
//   List _filteredList = [];
//   List<Contact> _selectedContacts = [];
//   final _groupNameController = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _contactProvider = Provider.of<ContactProvider>(context, listen: false);
//     _auth = Provider.of<AuthProvider>(context, listen: false);
//     // if (_contactProvider.contactList?.users?.length != 0)
//     //   _contactProvider.getContacts(_auth.getUser.auth_token);
//   }

//   Future<Null> refreshList() async {
//     renderList();
//     // rendersubscribe();
//   }

//   renderList() {
//     _contactProvider.getContacts(_auth.getUser.auth_token);
//   }

//   onSearch(value) {
//     print("this is here $value");
//     List temp;
//     temp = _contactProvider.contactList.users
//         .where((element) => element.full_name.toLowerCase().startsWith(value.toLowerCase()))
//         .toList();
//     print("this is filtered list $_filteredList");
//     setState(() {
//       if (temp.isEmpty) {
//         notmatched = true;
//         print("Here in true not matched");
//       } else {
//         print("Here in false matched");
//         notmatched = false;
//         _filteredList = temp;
//       }
//       //_filteredList = temp;
//     });
//   }

//   buildShowDialog(BuildContext context, String errorMessage) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             Future.delayed(Duration(seconds: 2), () {
//               Navigator.of(context).pop(true);
//             });
//             return AlertDialog(
//                 title: Center(
//                     child: Text(
//                   "Error Message",
//                   style: TextStyle(color: counterColor),
//                 )),
//                 content: Text("$errorMessage"),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0)),
//                 elevation: 0,
//                 actions: <Widget>[
//                   Container(
//                     height: 50,
//                     width: 319,
//                   )
//                 ]);
//           });
//         });
//   }

//   backHandler() {
//     setState(() {
//       _selectedContacts = [];
//     });
//     Navigator.pop(context);
//   }

//   handleCreateGroup() {
//     if (_selectedContacts.length == 0)
//       buildShowDialog(
//           context, "Please Select At least one contact to proceed!!!");
//     else if (_selectedContacts.length <= 4) {
//       print("Here in greater than 1");
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return CreateGroupPopUp(
//                 editGroupName: false,
//                 backHandler: backHandler,
//                 groupNameController: _groupNameController,
//                 selectedContacts: _selectedContacts,
//                 authProvider: _auth);
//           });
//     } else {
//       buildShowDialog(context, "Maximum limit is 4!!!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: ContactListAppBar(handleCreateGroup: handleCreateGroup),
//         body: Consumer<ContactProvider>(
//           builder: (context, contactPro, child) {
//             if (contactPro.contactState == ContactStates.Loading)
//               return Center(
//                   child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(chatRoomColor),
//               ));
//             else if (contactPro.contactState == ContactStates.Success)
//               return RefreshIndicator(
//                 onRefresh: refreshList,
//                 child: Container(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 50,
//                         padding: EdgeInsets.only(left: 21, right: 21),
//                         child: TextFormField(
//                           //textAlign: TextAlign.center,
//                           controller: _searchController,
//                           onChanged: (value) {
//                             onSearch(value);
//                           },
//                           validator: (value) =>
//                               value.isEmpty ? "Field cannot be empty." : null,
//                           decoration: InputDecoration(
//                             fillColor: refreshTextColor,
//                             filled: true,
//                             prefixIcon: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: SvgPicture.asset(
//                                 'assets/SearchIcon.svg',
//                                 width: 20,
//                                 height: 20,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide:
//                                     BorderSide(color: searchbarContainerColor)),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: BorderSide(
//                                 color: searchbarContainerColor,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5)),
//                                 borderSide:
//                                     BorderSide(color: searchbarContainerColor)),
//                             hintText: "Search",
//                             hintStyle: TextStyle(
//                                 fontSize: 14.0,
//                                 fontWeight: FontWeight.w400,
//                                 color: searchTextColor,
//                                 fontFamily: secondaryFontFamily),
//                           ),
//                         ),
//                         //),
//                       ),
//                       SizedBox(height: 30),
//                       Expanded(
//                         child: Scrollbar(
//                           child: notmatched == true
//                               ? Text("No data Found")
//                               : ListView.separated(
//                                   shrinkWrap: true,
//                                   padding: const EdgeInsets.all(8),
//                                   cacheExtent: 9999,
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: _searchController.text.isEmpty
//                                       ? contactPro.contactList.users.length
//                                       : _filteredList.length,
//                                   itemBuilder: (context, position) {
//                                     Contact element = _searchController
//                                             .text.isEmpty
//                                         ? contactPro.contactList.users[position]
//                                         : _filteredList[position];

//                                     // return Container(
//                                     //   //width: screenwidth,
//                                     //   height: 50,
//                                     //   child: Row(
//                                     //     children: [
//                                     //       Container(
//                                     //         padding: const EdgeInsets.only(
//                                     //             left: 11.5, right: 13.5),
//                                     //         decoration: BoxDecoration(
//                                     //           borderRadius: BorderRadius.circular(8),
//                                     //         ),
//                                     //         child: SvgPicture.asset('assets/User.svg'),
//                                     //       ),
//                                     //       Expanded(
//                                     //         child: Text(
//                                     //           "${element.full_name}",
//                                     //           style: TextStyle(
//                                     //             color: contactNameColor,
//                                     //             fontSize: 16,
//                                     //             fontFamily: primaryFontFamily,
//                                     //             fontWeight: FontWeight.w500,
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //       Container(
//                                     //         // width: 32,
//                                     //         // height: 32,
//                                     //         child: IconButton(
//                                     //           icon: SvgPicture.asset('assets/call.svg'),
//                                     //           onPressed: () {
//                                     //             // _startCall(
//                                     //             //     [element.ref_id],
//                                     //             //     MediaType.audio,
//                                     //             //     CAllType.one2one,
//                                     //             //     SessionType.call);
//                                     //             // setState(() {
//                                     //             //   callTo = element.full_name;
//                                     //             //   meidaType = MediaType.audio;
//                                     //             //   print("this is callTo $callTo");
//                                     //             // });
//                                     //             // print("three dot icon pressed");
//                                     //           },
//                                     //         ),
//                                     //       ),
//                                     //       Container(
//                                     //         padding: EdgeInsets.only(right: 5.9),
//                                     //         // width: 35,
//                                     //         // height: 35,
//                                     //         child: IconButton(
//                                     //           icon: SvgPicture.asset(
//                                     //               'assets/videocallicon.svg'),
//                                     //           onPressed: () {
//                                     //             //just for testing
//                                     //             // String firstUser =
//                                     //             //     "5a0fab423f72824dbd5f6c52372ad991";
//                                     //             // String secondUser =
//                                     //             //     "bba0bcc3174e200139f9881538ff208d";
//                                     //             // _startCall(
//                                     //             //     // [element.ref_id, secondUser],
//                                     //             //     [
//                                     //             //       element.ref_id,
//                                     //             //       firstUser,
//                                     //             //       secondUser
//                                     //             //     ],
//                                     //             //     MediaType.video,
//                                     //             //     CAllType.many2many,
//                                     //             //     SessionType.call);
//                                     //             // setState(() {
//                                     //             //   callTo = element.full_name;
//                                     //             //   meidaType = MediaType.video;
//                                     //             //   print("this is callTo $callTo");
//                                     //             // });
//                                     //             // print("three dot icon pressed");
//                                     //           },
//                                     //         ),
//                                     //       ),
//                                     //     ],
//                                     //   ),
//                                     // );
//                                     return Column(
//                                       children: [
//                                         ListTile(
//                                           onTap: () {
//                                             if (_selectedContacts.indexWhere(
//                                                     (contact) =>
//                                                         contact.user_id ==
//                                                         element.user_id) !=
//                                                 -1) {
//                                               setState(() {
//                                                 _selectedContacts
//                                                     .remove(element);
//                                               });
//                                             } else {
//                                               setState(() {
//                                                 _selectedContacts.add(element);
//                                               });
//                                             }
//                                           },
//                                           leading: Container(
//                                             margin: const EdgeInsets.only(
//                                                 left: 12, right: 14),
//                                             width: 24,
//                                             height: 24,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             child: SvgPicture.asset(
//                                                 'assets/User.svg'),
//                                           ),
//                                           title: Text(
//                                             "${element.full_name}",
//                                             style: TextStyle(
//                                               color: contactNameColor,
//                                               fontSize: 16,
//                                               fontFamily: primaryFontFamily,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           trailing: Container(
//                                             margin: EdgeInsets.only(right: 35),
//                                             child: _selectedContacts.indexWhere(
//                                                         (contact) =>
//                                                             contact.user_id ==
//                                                             element.user_id) ==
//                                                     -1
//                                                 ? Text("")
//                                                 : SvgPicture.asset(
//                                                     'assets/checkmark-circle.svg'),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                   separatorBuilder:
//                                       (BuildContext context, int index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 14.33, right: 19),
//                                       child: Divider(
//                                         thickness: 1,
//                                         color: listdividerColor,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             return Container();
//           },
//         ));
//   }
// }
