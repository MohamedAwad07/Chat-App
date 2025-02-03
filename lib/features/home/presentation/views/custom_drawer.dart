import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  final List<SampleListModel> drawerItems = [];
  final DrawerStateManager drawerState = DrawerStateManager();

  @override
  void initState() {
    super.initState();
    _initializeDrawerItems();
    _initializeDrawer();
  }

  void _initializeDrawerItems() {
    drawerItems.addAll([
      SampleListModel(
        title: "Home",
        icon: Icons.home,
        launchWidget: Center(child: Text("Home View", style: boldTextStyle)),
      ),
      SampleListModel(
        title: "Profile",
        icon: Icons.account_box_rounded,
        launchWidget: Center(child: Text("Profile View", style: boldTextStyle)),
      ),
      SampleListModel(
        title: "Notification",
        icon: Icons.notifications_none,
        launchWidget: Center(child: Text("Notification View", style: boldTextStyle)),
      ),
      SampleListModel(
        title: "Settings",
        icon: Icons.settings,
        launchWidget: Center(child: Text("Settings View", style: boldTextStyle)),
      ),
    ]);
  }

  void _initializeDrawer() async {
    await Future.delayed(Duration(seconds: 1));
    drawerState.openDrawer();
    setState(() {});
  }

  @override
  void dispose() {
    drawerState.closeDrawer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildDrawerContent(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Container(
      color: AppColors.drawerBackground,
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
              Text('Mohamed Awad', style: TextStyle(color: Colors.white, fontSize: 20)),
              Text('Software Engineer', style: TextStyle(color: Colors.white54, fontSize: 16)),
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
        onTap: () {
          drawerState.closeDrawer();
          setState(() {});
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return GestureDetector(
      onTap: () {
        drawerState.closeDrawer();
        setState(() {});
      },
      child: AnimatedContainer(
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
      ),
      onPanUpdate: (_) {
        drawerState.closeDrawer();
        setState(() {});
      },
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
        SizedBox(width: 8),
        Text(drawerItems[drawerState.selectedIndex].title ?? "View", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSelectedContent() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          drawerItems[drawerState.selectedIndex].launchWidget ?? SizedBox(),
          SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(AppStore().textPrimaryColor!),
              padding: WidgetStateProperty.all(const EdgeInsets.only(left: 15, right: 15)),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Go Back',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
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
    _setStatusBarColor(AppColors.drawerBackground);
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

class AppColors {
  static const Color drawerBackground = Color(0xff335a5a);
}

class AppStore {
  Color? textPrimaryColor;
  Color? scaffoldBackground;
  Color? scaffoldBackgroundColor;

  AppStore() {
    textPrimaryColor = Color(0xFF212121);
    scaffoldBackground = Color(0xFFEBF2F7);
    scaffoldBackgroundColor = Color(0xFFEFEFEF);
  }
}
