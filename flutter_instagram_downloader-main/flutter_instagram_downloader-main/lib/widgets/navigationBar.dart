import 'package:downloader/screens/download_page.dart';
import 'package:downloader/screens/igtv_page.dart';
import 'package:downloader/screens/reels_page.dart';
import 'package:downloader/screens/search_page.dart';
import 'package:downloader/screens/video.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _page = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Color(0xffde2545),
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Colors
                          .yellow))), // sets the inactive color of the `BottomNavigationBar`
          child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (index) {
              this._pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            backgroundColor: Color(0xffde2545),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: "Profile",
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.movie_outlined), label: "Reels"),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.video_library), label: "Videos"),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv_rounded), label: "IGTV"),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.download), label: "Download"),
            ],
          )),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: [
          SearchPage(),
          ReelsPage(),
          VideoPage(),
          IGTVPage(),
          DownloadPage()
        ],
      ),
    );
  }
}
