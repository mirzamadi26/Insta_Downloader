import 'dart:io';

import 'package:downloader/design.dart';
import 'package:downloader/widgets/bottomNavigation.dart';
import 'package:downloader/widgets/checkBar.dart';
import 'package:downloader/widgets/navigationBar.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

final Shader linearGradient = LinearGradient(colors: <Color>[orange, pink])
    .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Future<String> createFolder(String cow) async {
    final folderName = cow;
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  @override
  void initState() {
    createFolder("InstaDownloader");
    _controller = AnimationController(
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: 2800)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => NavigationBar()));
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/splash_icon.png",
              scale: 3,
            ),
            Text("Downloader",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = linearGradient,
                )),
            SizedBox(
              height: 20,
            ),
            Text("Download Posts, Reels and Profile Pictures",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
