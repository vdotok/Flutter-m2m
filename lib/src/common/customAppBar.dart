import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutterm2m/src/core/providers/groupListProvider.dart';
// import 'package:flutterm2m/src/home/home.dart';
// import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'package:provider/provider.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'package:vdotok_stream_example/src/home/home.dart';
// import 'package:vdotok_stream_example/src/home/home.dart';
import '../../src/core/providers/auth.dart';
import '../../constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.handlePress, this.isConnect})
      : super(key: key);
  final handlePress;
  final isConnect;

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    print("utdfdfgd $isRegisteredAlready  $isConnect");
    return Consumer<GroupListProvider>(
      builder: (context, groupProvider, child) {
        if (groupProvider.groupListStatus == ListStatus.CreateGroup)
          return AppBar(
              centerTitle: false,
              backgroundColor: chatRoomBackgroundColor,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: chatRoomColor),
                onPressed: () {
                  groupProvider.handleGroupListState(ListStatus.Scussess);
                },
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Create Group",
                  style: TextStyle(
                    color: chatRoomColor,
                    fontSize: 20,
                    fontFamily: primaryFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: !isConnect
                          ? (!isRegisteredAlready)
                              ? () {}
                              : () {}
                          : isRegisteredAlready
                              ? () {}
                              : () {
                                  handlePress(groupProvider.groupListStatus);
                                  // Navigator.pushNamed(context, "/contactList");
                                },
                      icon: SvgPicture.asset(
                        'assets/checkmark.svg',
                      ),
                    )),
              ]);
        else
          return AppBar(
              centerTitle: false,
              backgroundColor: chatRoomBackgroundColor,
              elevation: 0.0,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Group List",
                  style: TextStyle(
                    color: chatRoomColor,
                    fontSize: 20,
                    fontFamily: primaryFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: () {
                        handlePress(groupProvider.groupListStatus);
                        // Navigator.pushNamed(context, "/contactList");
                      },
                      icon: SvgPicture.asset(
                        'assets/plus.svg',
                      ),
                    )),
              ]);
      },
    );
  }
}
