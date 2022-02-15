import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  Future<List> createFolder() async {
    List downloadfilesPath = [];
    final Directory appfolder = Directory("storage/emulated/0/InstaDownloader");
    List<FileSystemEntity> downloadedFiles = List();
    downloadedFiles = await appfolder.list().toList();
    downloadedFiles.forEach((element) {
      if (element is File) {
        downloadfilesPath.add(element.path);
      } else {
        return;
      }
    });
    downloadfilesPath.forEach((element) {
      print(element);
    });
    return downloadfilesPath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Downloads",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: createFolder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List split = snapshot.data[index].toString().split('.');
                      if (split.last == 'jpg') {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    width:
                                        MediaQuery.of(context).size.width / 9,
                                    child:
                                        Image.file(File(snapshot.data[index]))),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    snapshot.data[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ],
                        );
                      } else if (split.last == 'mp4') {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xffde2545),
                                  child: Icon(
                                    Icons.videocam,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    snapshot.data[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ],
                        );
                      }
                    });
              } else
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
            }));
  }
}
