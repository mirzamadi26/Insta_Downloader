import 'dart:io';
import 'package:downloader/design.dart';
import 'package:downloader/screens/download_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloader/utils/methods.dart';

TextEditingController _inputSearch = TextEditingController();

class SearchPage extends StatefulWidget {
  @override
  _SeaState createState() => _SeaState();
}

String usernameState, followerState, followingState, imageUrlState;

class _SeaState extends State<SearchPage> {
  int progress = 0;
  String message = "";
  String path = "";
  String size = "";
  String mimeType = "";
  File imageFile;
  String _setSearchText = "View";
  String _setDownloadText = "Download";
  Color setDownloadColor = orange;
  bool downloading = false;
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();

    _inputSearch.clear();
    _isButtonDisabled = false;
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        progress = progress;
      });
    });
  }

  void showToast() => Fluttertoast.showToast(
      msg: "Download Started", fontSize: 18, gravity: ToastGravity.BOTTOM);

  void cancelToast() => Fluttertoast.cancel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile Download",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            left: 20.0,
            right: 20.0,
            child: TextField(
                onChanged: (value) {
                  setState(() {
                    _setSearchText = "View";
                    _setDownloadText = "Download";
                    setDownloadColor = pink;
                    _isButtonDisabled = false;
                  });
                },
                controller: _inputSearch,
                cursorColor: Colors.green[900],
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(12)),
                    hintText: "Username",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: FaIcon(
                        FontAwesomeIcons.link,
                        color: Colors.black87,
                        size: 19,
                      ),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey))),
          ),
          Positioned(
            top: 110.0,
            left: 20.0,
            right: 20.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1,
                height: flutterInsta.username != null
                    ? MediaQuery.of(context).size.height / 1
                    : MediaQuery.of(context).size.height / 2.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                  child: flutterInsta.username == null
                      ? ListView(
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width:
                                        MediaQuery.of(context).size.width / 2.7,
                                    height: MediaQuery.of(context).size.height /
                                        15),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffde2545)),
                                  ),
                                  child: Text(
                                    "$_setSearchText",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    if (_inputSearch.text.isEmpty) {
                                      const snackBar = SnackBar(
                                        content: Text('InValid Username'),
                                      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    FocusScope.of(context).nextFocus();
                                    instagramuser =
                                        _inputSearch.text.toString();

                                    print("Seacrh " + instagramuser);
                                    try {
                                      await flutterInsta
                                          .getProfileData(instagramuser);
                                    } catch (e) {
                                      print(e);
                                    }
                                    setState(() {
                                      _isButtonDisabled = false;
                                      usernameState = flutterInsta.username;
                                      followerState = flutterInsta.followers;
                                      followingState = flutterInsta.following;
                                      imageUrlState = flutterInsta.imgurl;
                                    });
                                  },
                                )),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 35,
                            ),
                            Container(
                              child: Image.network(
                                flutterInsta.imgurl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(height: 15),
                            ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    height: MediaQuery.of(context).size.height /
                                        15),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffde2545)),
                                  ),
                                  child: Text(
                                    "$_setDownloadText",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: _isButtonDisabled
                                      ? null
                                      : () async {
                                          var status =
                                              await Permission.storage.status;
                                          if (status.isUndetermined) {
                                            Map<Permission, PermissionStatus>
                                                statuses = await [
                                              Permission.storage,
                                            ].request();
                                            print(statuses[Permission.storage]);
                                          } else {
                                            downloadUserProfile(imageUrlState);
                                            showToast();
                                          }
                                        },
                                )),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String taskId;
  void downloadUserProfile(imageUrlState) async {
    taskId = await FlutterDownloader.enqueue(
      url: imageUrlState,
      savedDir: '/sdcard/InstaDownloader',
      showNotification: true,
      openFileFromNotification: true,
      fileName: "instadownloader_$usernameState.jpg",
    ).whenComplete(() {
      setState(() {
        print("Downloaded");
        downloading = false;
      });
    });
  }
}
