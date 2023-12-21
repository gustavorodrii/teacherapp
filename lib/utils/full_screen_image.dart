// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import 'package:http/http.dart' as http;

import '../../model/expense_model.dart';

class FullScreenImage extends StatefulWidget {
  final Expense expense;
  const FullScreenImage({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

bool isLoading = false;

class _FullScreenImageState extends State<FullScreenImage> {
  Future<void> shareImage(BuildContext context) async {
    final PermissionStatus storage = await Permission.storage.request();
    if (storage.isGranted) {
      setState(() {
        isLoading = true;
      });
      final response =
          await get(Uri.parse(widget.expense.image as String)); // <--2
      final documentDirectory = await getApplicationDocumentsDirectory();
      final firstPath = "${documentDirectory.path}/images";
      final filePathAndName = '${documentDirectory.path}/images/pic.jpg';
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      final File file2 = File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3

      final XFile xfile = XFile(file2.path);

      setState(() {
        isLoading = false;
      });

      await Share.shareXFiles([xfile]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () => shareImage(context),
            child: Icon(Icons.share),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PhotoView(
              imageProvider: NetworkImage(
                widget.expense.image as String,
              ),
            ),
          ),
          if (widget.expense.descriptionAttach != null &&
              widget.expense.descriptionAttach != "")
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.7),
                padding: EdgeInsets.only(
                  bottom: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.expense.descriptionAttach as String,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
