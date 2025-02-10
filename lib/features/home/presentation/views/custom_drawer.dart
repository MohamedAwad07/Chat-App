import 'dart:developer';

import 'package:chat_app/core/service%20locator/service_locator.dart';
import 'package:chat_app/core/utils/app_colors.dart';
import 'package:chat_app/features/Auth/presentation/controller/auth_cubit.dart';
import 'package:chat_app/features/home/presentation/views/widgets/cusom_user_tile.dart';
import 'package:chat_app/features/home/presentation/views/widgets/custom_user_list.dart';
import 'package:chat_app/features/home/presentation/views/widgets/skeletonizer_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  final List<SampleListModel> drawerItems = [];
  final DrawerStateManager drawerState = DrawerStateManager();

  @override
  void initState() {
    super.initState();
    // Fetch and log chat IDs for the current user
    _initializeDrawerItems();
  }

  void _initializeDrawerItems() {
    drawerItems.addAll([
      SampleListModel(
        title: "Home",
        icon: Icons.home,
        launchWidget: BuildUserList(),
      ),
      SampleListModel(
        title: "Chats",
        icon: Icons.chat_bubble_outline,
        launchWidget: CurrentChatsScreen(),
      ),
      SampleListModel(
        title: "Notification",
        icon: Icons.notifications_none,
        launchWidget: Center(child: Text("Notification")),
      ),
      SampleListModel(
        title: "Settings",
        icon: Icons.settings,
        launchWidget: SettingsScreen(),
      ),
    ]);
  }

  @override
  void dispose() {
    drawerState.closeDrawer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildDrawerContent(),
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Container(
      color: AppColor.drawerBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserProfile(),
          SizedBox(height: 24),
          ...drawerItems.map((item) => _buildDrawerItem(item)),
          Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle, color: Colors.white, size: 50),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AuthCubit.get(context).currentUser?.username ?? "User Name", style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(AuthCubit.get(context).currentUser?.email ?? "Manga@example.com", style: TextStyle(color: Colors.white54, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(SampleListModel item) {
    return ListTile(
      title: Text(
        item.title ?? "",
        style: TextStyle(
          color: drawerState.isSelected(drawerItems.indexOf(item)) ? Colors.white : Colors.white54,
        ),
      ),
      leading: Icon(
        item.icon,
        color: drawerState.isSelected(drawerItems.indexOf(item)) ? Colors.white : Colors.white54,
      ),
      onTap: () {
        drawerState.selectItem(drawerItems.indexOf(item));
        drawerState.closeDrawer();
        setState(() {});
      },
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 24),
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 5),
            Text("Logout", style: TextStyle(color: Colors.white)),
          ],
        ),
        onTap: () async {
          try {
            sl<AuthCubit>().logout();
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: drawerState.isOpen ? BorderRadius.circular(16) : BorderRadius.circular(0),
      ),
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(drawerState.xOffset, drawerState.yOffset, 0)..scale(drawerState.scaleFactor),
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          color: AppStore().scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildSelectedContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(drawerState.isOpen ? Icons.arrow_back : Icons.menu, size: 24),
          onPressed: () {
            if (drawerState.isOpen) {
              drawerState.closeDrawer();
            } else {
              drawerState.openDrawer();
            }
            setState(() {});
          },
        ),
        Spacer(),
        Text(
          drawerItems[drawerState.selectedIndex].title ?? "View",
          style: GoogleFonts.pacifico(
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        // Spacer to balance the Row
        Spacer(),
        SizedBox(width: 48),
      ],
    );
  }

  Widget _buildSelectedContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        drawerItems[drawerState.selectedIndex].launchWidget ?? SizedBox(),
        SizedBox(height: 16),
      ],
    );
  }
}

class CurrentChatsScreen extends StatelessWidget {
  const CurrentChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: Stream.fromFuture(getChats(context, AuthCubit.get(context).currentUser!.uid)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonizerUserList();
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final users = snapshot.data!;
        log(users.toString());
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserTile(
                  username: "username",
                  status: "status",
                  userId: "userId",
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future<List<String>> getChats(BuildContext context, String currentUserId) async {
  log("Getting Chats ********************************************");
  final chatCollection = sl.get<FirebaseFirestore>().collection('chat_rooms');

  // Fetch all chat rooms from Firestore
  final snapshot = await chatCollection.get();

  // Log snapshot data (iterating over docs and logging their IDs and data)
  log("Snapshot size: ${snapshot.size}");
  List<String> chatIds = [];

  for (var doc in snapshot.docs) {
    log("Document ID: ${doc.id}"); // Log the document ID
    log("Document Data: ${doc.data()}"); // Log the actual data of the document

    // Assuming 'roomId' is the chat room ID, which contains the sorted user IDs
    String roomId = doc.id;

    // Extract the user IDs from the roomId and check if currentUserId is part of the chat
    List<String> roomUsers = roomId.split('-');
    log("Room Users: $roomUsers");

    if (roomUsers.contains(currentUserId)) {
      chatIds.add(doc.id);
      log("Chat ID: ${doc.id}");
    }
  }

  log(" ******************************************** ");
  return chatIds; // Return a list of chat IDs that contain the currentUserId
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Dark Mode",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        CupertinoSwitch(
          value: _isSwitched,
          onChanged: (value) {
            setState(() {
              _isSwitched = !_isSwitched;
            });
          },
        ),
      ]),
    );
  }
}

class DrawerStateManager {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isOpen = false;
  int selectedIndex = 0;

  void openDrawer() {
    xOffset = 200;
    yOffset = 80;
    scaleFactor = 0.8;
    isOpen = true;
    _setStatusBarColor(AppColor.drawerBackground);
  }

  void closeDrawer() {
    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isOpen = false;
    _setStatusBarColor(AppStore().scaffoldBackground!);
  }

  void selectItem(int index) {
    selectedIndex = index;
  }

  bool isSelected(int index) {
    return selectedIndex == index;
  }

  Future<void> _setStatusBarColor(Color statusBarColor) async {
    await Future.delayed(Duration(milliseconds: 200));
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}

class SampleListModel {
  final String? title;
  final IconData? icon;
  final Widget? launchWidget;

  SampleListModel({this.title, this.icon, this.launchWidget});
}

class AppColor {
  static Color drawerBackground = AppColors.primary;
}

class AppStore {
  Color? textPrimaryColor;
  Color? scaffoldBackground;
  Color? scaffoldBackgroundColor;

  AppStore() {
    textPrimaryColor = Color(0xFF212121);
    scaffoldBackground = Color(0xFFEBF2F7);
    scaffoldBackgroundColor = Colors.white;
  }
}
