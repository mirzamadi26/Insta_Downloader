import 'package:downloader/screens/download_page.dart';
import 'package:downloader/screens/igtv_page.dart';
import 'package:downloader/screens/reels_page.dart';
import 'package:downloader/screens/search_page.dart';
import 'package:downloader/screens/video.dart';
import 'package:downloader/widgets/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProvidedStylesExample extends StatefulWidget {
  final BuildContext menuScreenContext;
  ProvidedStylesExample({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _ProvidedStylesExampleState createState() => _ProvidedStylesExampleState();
}

class _ProvidedStylesExampleState extends State<ProvidedStylesExample> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [SearchPage(), ReelsPage(), VideoPage(), IGTVPage(), DownloadPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle_outlined),
        title: "Profile",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.movie_outlined),
        title: ("Reels"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.video_library),
        title: ("Video"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.live_tv_rounded),
        title: ("IGTV"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.download),
        title: ("Download"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(scrollDirection: Axis.horizontal, children: [
        PersistentTabView(
          context,
          controller: _controller,

          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Color(0xffde2545),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          hideNavigationBarWhenKeyboardShows: true,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 0.0,

          selectedTabScreenContext: (context) {
            //testContext = context;
          },

          decoration: NavBarDecoration(
            colorBehindNavBar: Colors.redAccent,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style13,
          screens:
              _buildScreens(), // Choose the nav bar style with this property
        ),
      ]),
    );
  }
}
