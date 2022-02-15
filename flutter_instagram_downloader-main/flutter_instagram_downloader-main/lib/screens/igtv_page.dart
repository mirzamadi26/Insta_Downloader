import 'package:downloader/design.dart';
import 'package:downloader/screens/download_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloader/utils/methods.dart';

TextEditingController inputReels = TextEditingController();

class IGTVPage extends StatefulWidget {
  IGTVPage({Key key}) : super(key: key);

  @override
  State<IGTVPage> createState() => _IGTVPageState();
}

class _IGTVPageState extends State<IGTVPage> {
  String usernameState, followerState, followingState, imageUrlState;
  bool _isButtonDisabled;
  Color _setDownloadColor = orange;
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: orange,
    primary: orange,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  int progress = 0;
  String _setDownloadReelsText = "Download";
  bool downloading = false;
  String reelsLink;

  @override
  void initState() {
    super.initState();
    inputReels.clear();
    _isButtonDisabled = false;

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        progress = progress;
      });
    });
  }

  void showToast() => Fluttertoast.showToast(
      msg: "Download Started", fontSize: 18, gravity: ToastGravity.BOTTOM);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("IGTV Download",
            style: TextStyle(color: Colors.white, fontSize: 18)),
       
       
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            top: 30.0,
            left: 20.0,
            right: 20.0,
            child: TextField(
                onChanged: (value) {
                  setState(() {
                    reelsLink = null;
                  });
                },
                controller: inputReels,
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
                    hintText: "Paste URL",
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
            top: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1,
                height: reelsLink == null
                    ? MediaQuery.of(context).size.height / 4.5
                    : MediaQuery.of(context).size.height / 3.5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 15, 1),
                  child: ListView(
                    children: [
                      Container(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: MediaQuery.of(context).size.width / 2.7,
                                height:
                                    MediaQuery.of(context).size.height / 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  side: BorderSide(
                                      color: Color(0xffde2545), width: 3)),
                              onPressed: () {
                                setState(() {
                                  inputReels.clear();
                                });
                              },
                              child: Text(
                                "Paste Link",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: MediaQuery.of(context).size.width / 2.7,
                                height:
                                    MediaQuery.of(context).size.height / 15),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffde2545)),
                              ),
                              onPressed: () async {
                                if (inputReels.text.isEmpty) {
                                  const snackBar = SnackBar(
                                    content: Text('InValid Link!'),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                FocusScope.of(context).nextFocus();
                                setState(() {
                                  _isButtonDisabled = false;
                                  reelsLink = inputReels.text;
                                  print("setState reelsLink: " + reelsLink);
                                });
                                var status = await Permission.storage.status;
                                if (status.isUndetermined) {
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                  ].request();
                                  print(statuses[Permission.storage]);
                                } else {
                                  downloadReels();
                                  setState(
                                    () {
                                      _isButtonDisabled = true;
                                      downloading = true;
                                    },
                                  );
                                  showToast();
                                }
                              },
                              child: Text(
                                "$_setDownloadReelsText",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
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
  String save = DateTime.now().toString();
  void downloadReels() async {
    print("Reels link: " + reelsLink);
    var reelsDownloadLink = await flutterInsta.downloadReels(reelsLink);
    print("reelsDownloadLink: " + reelsDownloadLink);

    taskId = await FlutterDownloader.enqueue(
      url: reelsDownloadLink,
      savedDir: '/sdcard/InstaDownloader',
      showNotification: true,
      fileName: "instadownloader${save}.mp4",
      openFileFromNotification: true,
    ).whenComplete(
      () {
        setState(
          () {
            print("Downloaded");
            downloading = false;
          },
        );
      },
    );
  }
}
