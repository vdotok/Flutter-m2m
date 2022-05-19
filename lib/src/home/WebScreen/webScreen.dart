import 'package:flutter/material.dart';



class WebScreen extends StatefulWidget {
  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          // resizeToAvoidBottomInset: false,
          // backgroundColor: logoBckgroundColor,
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(100.0),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Image(
          //           width: 40,
          //           image: AssetImage(
          //             'assets/logo.png',
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             signalingClient.unRegister(registerRes["mcToken"]);
          //             _auth.logout();
          //           },
          //           child: Row(
          //             children: <Widget>[
          //               // SvgPicture.asset('assets/logo.svg'),

          //               Text(
          //                 'Logout ${_auth.getUser.full_name}',
          //                 style: TextStyle(
          //                   color: attachmentNameColor,
          //                   fontSize: 14,
          //                   fontFamily: primaryFontFamily,
          //                   fontWeight: FontWeight.w700,
          //                   letterSpacing: 0.90,
          //                 ),
          //               ),
          //               SizedBox(width: 20),
          //               Icon(Icons.logout),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // body: Consumer<GroupListProvider>(
          //   builder: (context, groupListProvid, child) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 40),
          //       child: Column(
          //         children: [
          //           Expanded(
          //             child: Container(
          //               margin: ResponsiveWidget.isSmallScreen(context)
          //                   ? const EdgeInsets.only(
          //                       right: 0,
          //                       bottom: 10,
          //                     )
          //                   : const EdgeInsets.only(
          //                       bottom: 20,
          //                     ),
          //               color: logoBckgroundColor,
          //               child: Row(
          //                 children: [
          //                   //left Section
          //                   groupListProvid.groupListStatus ==
          //                           ListStatus.CreateGroup
          //                       ? Container(
          //                           decoration: BoxDecoration(
          //                             borderRadius:
          //                                 BorderRadius.all(Radius.circular(20)),
          //                             color: Colors.white,
          //                           ),
          //                           height:
          //                               ResponsiveWidget.isSmallHeight(context)
          //                                   ? MediaQuery.of(context)
          //                                           .size
          //                                           .height +
          //                                       1000
          //                                   : MediaQuery.of(context)
          //                                           .size
          //                                           .height +
          //                                       1,
          //                           width:
          //                               ResponsiveWidget.isSmallScreen(context)
          //                                   ? MediaQuery.of(context)
          //                                           .size
          //                                           .width -
          //                                       125
          //                                   : 370,
          //                           margin: const EdgeInsets.only(right: 34),
          //                           child: Column(
          //                             children: [
          //                               Container(
          //                                 child: Align(
          //                                   alignment: Alignment.topLeft,
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 20,
          //                                             vertical: 20),
          //                                     child: Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment
          //                                               .spaceBetween,
          //                                       children: [
          //                                         IconButton(
          //                                           onPressed: () {
          //                                             _groupListProvider
          //                                                 .handleGroupListState(
          //                                                     ListStatus
          //                                                         .Scussess);
          //                                           },
          //                                           icon: Icon(
          //                                             Icons.arrow_back,
          //                                             color: chatRoomwebColor,
          //                                           ),
          //                                         ),
          //                                         Row(
          //                                           children: [
          //                                             Container(
          //                                               child: Text(
          //                                                 "Create Group",
          //                                                 style: TextStyle(
          //                                                   color:
          //                                                       chatRoomwebColor,
          //                                                   fontSize: 14,
          //                                                   fontFamily:
          //                                                       primaryFontFamily,
          //                                                   fontWeight:
          //                                                       FontWeight.w700,
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                             Text(
          //                                               "CREATE",
          //                                               style: TextStyle(
          //                                                 color:
          //                                                     chatRoomwebColor,
          //                                                 fontSize: 14,
          //                                                 fontFamily:
          //                                                     primaryFontFamily,
          //                                                 fontWeight:
          //                                                     FontWeight.w700,
          //                                               ),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         IconButton(
          //                                           icon: SvgPicture.asset(
          //                                               'assets/checkmark.svg'),
          //                                           onPressed: _selectedContacts
          //                                                       .length ==
          //                                                   0
          //                                               ? () async {
          //                                                   buildShowDialog(
          //                                                       context,
          //                                                       "Please Select At least one contact to proceed!!!");
                                                           
          //                                                 }
          //                                               : _selectedContacts
          //                                                           .length <=
          //                                                       4
          //                                                   ? () {
          //                                                       print(
          //                                                           "Here in greater than 1");
          //                                                       showDialog(
          //                                                           context:
          //                                                               context,
          //                                                           builder:
          //                                                               (BuildContext
          //                                                                   context) {
          //                                                             return ListenableProvider<
          //                                                                 GroupListProvider>.value(
          //                                                               value:
          //                                                                   _groupListProvider,
          //                                                               child: CreateGroupPopUp(
          //                                                                   editGroupName: false,
          //                                                                   backHandler: backHandler,
          //                                                                   groupNameController: _groupNameController,
          //                                                                   selectedContacts: _selectedContacts,
          //                                                                   // groupListProvider: groupListProvider,
          //                                                                   authProvider: _auth),
          //                                                             );
          //                                                           });
          //                                                     }
          //                                                   : () {
          //                                                       buildShowDialog(
          //                                                           context,
          //                                                           "Maximum limit is 4!!!");
          //                                                     },
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                               SizedBox(height: 10),
          //                               Expanded(
          //                                 child: groupListProvid
          //                                             .groupListStatus ==
          //                                         ListStatus.CreateGroup
          //                                     ? Consumer<ContactProvider>(
          //                                         builder: (context, contactp,
          //                                             child) {
          //                                           if (contactp.contactState ==
          //                                               ContactStates.Loading)
          //                                             return Center(
          //                                               child: Container(
          //                                                 child:
          //                                                     CircularProgressIndicator(
          //                                                   valueColor:
          //                                                       AlwaysStoppedAnimation<
          //                                                               Color>(
          //                                                           chatRoomColor),
          //                                                 ),
          //                                               ),
          //                                             );
          //                                           else if (contactp
          //                                                   .contactState ==
          //                                               ContactStates.Success) {
          //                                             if (contactp.contactList
          //                                                     .users.length ==
          //                                                 0)
          //                                               return noContactFound(
          //                                                   context);
          //                                             else
          //                                               return ContactListScreen(refreshcontactList: refreshList,searchController: _searchController, selectedContact: _selectedContacts,state: contactp,);
          //                                              // return contactList(
          //                                                 //  contactp);
          //                                           } else
          //                                             return Container(
          //                                               child: Text(
          //                                                   "no contacts found"),
          //                                             );
          //                                         },
          //                                       )
          //                                     : Consumer<GroupListProvider>(
          //                                         builder: (context, contact,
          //                                             child) {
          //                                           if (contact
          //                                                   .groupListStatus ==
          //                                               ListStatus.Loading)
          //                                             return Center(
          //                                               child: Container(
          //                                                 child:
          //                                                     CircularProgressIndicator(
          //                                                   valueColor:
          //                                                       AlwaysStoppedAnimation<
          //                                                               Color>(
          //                                                           chatRoomColor),
          //                                                 ),
          //                                               ),
          //                                             );
          //                                           else if (contact
          //                                                   .groupListStatus ==
          //                                               ListStatus.Scussess) {
          //                                             if (contact.groupList
          //                                                     .groups.length ==
          //                                                 0)
          //                                               return noContactFound(
          //                                                   context);
          //                                             else
          //                                               return groupList(
          //                                                   contact.groupList);
          //                                           } else
          //                                             return Container(
          //                                               child: Text(
          //                                                   "no contacts found"),
          //                                             );
          //                                         },
          //                                       ),
          //                               )
          //                             ],
          //                           ))
          //                       : Container(
          //                           decoration: BoxDecoration(
          //                             borderRadius:
          //                                 BorderRadius.all(Radius.circular(20)),
          //                             color: Colors.white,
          //                           ),
          //                           height: ResponsiveWidget
          //                                   .isSmallHeight(context)
          //                               ? MediaQuery.of(context).size.height +
          //                                   1000
          //                               : MediaQuery.of(context).size.height +
          //                                   1,
          //                           width: ResponsiveWidget.isSmallScreen(
          //                                   context)
          //                               ? MediaQuery.of(context).size.width -
          //                                   125
          //                               : 370,
          //                           margin: const EdgeInsets.only(right: 34),
          //                           child: Column(
          //                             children: [
          //                               Container(
          //                                 child: Align(
          //                                   alignment: Alignment.topLeft,
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 20,
          //                                             vertical: 20),
          //                                     child: Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment
          //                                               .spaceBetween,
          //                                       children: [
          //                                         Container(
          //                                           child: Text(
          //                                             "Group List ",
          //                                             style: TextStyle(
          //                                               color: chatRoomwebColor,
          //                                               fontSize: 14,
          //                                               fontFamily:
          //                                                   primaryFontFamily,
          //                                               fontWeight:
          //                                                   FontWeight.w700,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         Row(
          //                                           children: [
          //                                             Text(
          //                                               "CREATE",
          //                                               style: TextStyle(
          //                                                 color:
          //                                                     chatRoomwebColor,
          //                                                 fontSize: 14,
          //                                                 fontFamily:
          //                                                     primaryFontFamily,
          //                                                 fontWeight:
          //                                                     FontWeight.w700,
          //                                               ),
          //                                             ),
          //                                             IconButton(
          //                                               icon: const Icon(
          //                                                 Icons.add,
          //                                                 size: 24,
          //                                                 color: chatRoomColor,
          //                                               ),
          //                                               onPressed: () {
          //                                                 setState(() {
          //                                                   handleGroupState();
          //                                                 });
          //                                                 print(
          //                                                     "chat room add icon pressed");
          //                                               },
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                               SizedBox(height: 10),
          //                               Expanded(
          //                                 child: groupListProvid
          //                                             .groupListStatus ==
          //                                         ListStatus.CreateGroup
          //                                     ? Consumer<ContactProvider>(
          //                                         builder: (context, contactp,
          //                                             child) {
          //                                           if (contactp.contactState ==
          //                                               ContactStates.Loading)
          //                                             return Center(
          //                                               child: Container(
          //                                                 child:
          //                                                     CircularProgressIndicator(
          //                                                   valueColor:
          //                                                       AlwaysStoppedAnimation<
          //                                                               Color>(
          //                                                           chatRoomColor),
          //                                                 ),
          //                                               ),
          //                                             );
          //                                           else if (contactp
          //                                                   .contactState ==
          //                                               ContactStates.Success) {
          //                                             if (contactp.contactList
          //                                                     .users.length ==
          //                                                 0)
          //                                               return noContactFound(
          //                                                   context);
          //                                             else
          //                                               return ContactListScreen(refreshcontactList: refreshList,searchController: _searchController, selectedContact: _selectedContacts,state: contactp,);
          //                                               // return contactList(
          //                                               //     contactp);
          //                                           } else
          //                                             return Container(
          //                                               child: Text(
          //                                                   "no contacts found"),
          //                                             );
          //                                         },
          //                                       )
          //                                     : Consumer<GroupListProvider>(
          //                                         builder: (context, contact,
          //                                             child) {
          //                                           if (contact
          //                                                   .groupListStatus ==
          //                                               ListStatus.Loading)
          //                                             return Center(
          //                                               child: Container(
          //                                                 child:
          //                                                     CircularProgressIndicator(
          //                                                   valueColor:
          //                                                       AlwaysStoppedAnimation<
          //                                                               Color>(
          //                                                           chatRoomColor),
          //                                                 ),
          //                                               ),
          //                                             );
          //                                           else if (contact
          //                                                   .groupListStatus ==
          //                                               ListStatus.Scussess) {
          //                                             if (contact.groupList
          //                                                     .groups.length ==
          //                                                 0)
          //                                               return noContactFound(
          //                                                   context);
          //                                             else
          //                                               return groupList(
          //                                                   contact.groupList);
          //                                           } else
          //                                             return Container(
          //                                               child: Text(
          //                                                   "no contacts found"),
          //                                             );
          //                                         },
          //                                       ),
          //                               )
          //                             ],
          //                           )),
          //                   ResponsiveWidget.isSmallScreen(context)
          //                       ? SizedBox(height: 3, width: 3)
          //                       :
          //                       //rightSection
          //                       Expanded(
          //                           flex: 3,
          //                           child: Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.all(
          //                                   Radius.circular(20)),
          //                               color: Colors.white,
          //                             ),
          //                             child: Consumer<CallProvider>(
          //                               builder:
          //                                   (context, callProvider, child) {
          //                                 print(
          //                                     "this is callStatus ${callProvider.callStatus}");
          //                                 if (callProvider.callStatus ==
          //                                     CallStatus.CallReceive)
          //                                     return CallReceiveScreen(authprovider: _auth,callprovider: callProvider,callingto: callingTo,
          //                                     incomingfrom: incomingfrom,registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,
          //                                     mediatype: meidaType,stopRinging: stopRinging,);
          //                                 //  return callReceive();
          //                                 // return Container(
          //                                 //   child: Text("test"),
          //                                 // );

          //                                 if (callProvider.callStatus ==
          //                                     CallStatus.CallStart)
                                          
          //                                 if (ResponsiveWidget.isSmallScreen(
          //                                     context))
          //                                  // return callStart();
          //                                  return CallSttartScreen(callto: callTo,switchmute: switchMute,switchspeaker: switchSpeaker,enablecamera: enableCamera,
          //                                  registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,onRemotestream: onRemoteStream,pressduration: _pressDuration,
          //                                  incomingfrom: incomingfrom,stopcall: stopCall,mediatype: meidaType,contactprovider: _contactProvider,);
          //                                 else
          //                                   return callStartWeb();
          //                                 if (callProvider.callStatus ==
          //                                     CallStatus.CallDial)
          //                                     return CallDialScreen(callingto: callingTo,mediatype: meidaType,registerRes: registerRes,rendererListWithRefid: rendererListWithRefID,callprovider: callProvider,);
          //                                   //return callDial();
          //                                 // return Container(
          //                                 //   child: Text("test"),
          //                                 // );
          //                                 else if (callProvider.callStatus ==
          //                                     CallStatus.Initial)
          //                                   return SafeArea(
          //                                     child: GestureDetector(
          //                                         onTap: () {
          //                                           FocusScopeNode currentFous =
          //                                               FocusScope.of(context);
          //                                           if (!currentFous
          //                                               .hasPrimaryFocus) {
          //                                             return currentFous
          //                                                 .unfocus();
          //                                           }
          //                                         },
          //                                         child: NoGroupScreen(
          //                                           handleRefresh: refreshList,
          //                                           handleNewCreate:
          //                                               handleGroupState,
          //                                         )),
          //                                   );
          //                                 return Container(
          //                                   child: Text("test"),
          //                                 );
          //                               },
          //                             ),
          //                           )),

          //                   // rightSection()
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
         // )
          );
  }
}