import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {
  final String imgUrl;

  ImageView({@required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _save();
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                        ),
                        Container(
                          height: 50.0,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white54, width: 1.0),
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(colors: [
                                Color(0x36FFFFFF),
                                Color(0x0FFFFFFF),
                              ])),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Download Wallpaper",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white70),
                              ),
                              Text(
                                "Image will be saved in Gallery",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white70),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          "Cancel", style: TextStyle(color: Colors.white))),
                  SizedBox(
                    height: 50.0,
                  )
                ],
              ))
        ],
      ),
    );
  }

  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }

    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);


    Navigator.pop(context);
  }

  _askPermission() async {
    try {
      if (Platform.isIOS) {
        await PermissionHandler().requestPermissions([PermissionGroup.photos]);
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.photos);
        if (permission == PermissionStatus.granted) {} else {
          throw 'denied';
        }
      } else if (Platform.isAndroid) {
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
        if (permission == PermissionStatus.granted) {} else {
          throw 'denied';
        }
      }
      //await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    } catch (e) {
      throw e;
    }
  }
}
