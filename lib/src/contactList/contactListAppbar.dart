import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../src/core/providers/auth.dart';
import '../../constant.dart';

class ContactListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContactListAppBar({
    this.handleCreateGroup,
    Key key,
  }) : super(key: key);
  final handleCreateGroup;
  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: chatRoomColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        backgroundColor: chatRoomBackgroundColor,
        elevation: 0.0,
        title: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 10),
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
                this.handleCreateGroup();
              },
              icon: SvgPicture.asset(
                'assets/checkmark.svg',
              ),
            ),
          ),
        ]);
  }
}
