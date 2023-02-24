import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/db/sql_database.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/ui/pages/note_page.dart';

import '../models/note.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  ImageCapture({required this.noteModel, Key? key}) : super(key: key);
  Note noteModel;
  @override
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  XFile? _imageFile;

  /// Cropper plugin
  Future<void> _cropImage({CropStyle cropStyle = CropStyle.rectangle}) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(cropStyle: cropStyle, sourcePath: _imageFile!.path);
    if (croppedImage != null) {
      setState(() {
        _imageFile = XFile(croppedImage.path);
      });
    }
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(File(_imageFile!.path)),
            Row(
              children: <Widget>[
                TextButton(
                  child: const Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                TextButton(
                  child: const Icon(Icons.refresh),
                  onPressed: _clear,
                ),
                TextButton(
                  child: const Icon(Icons.done),
                  onPressed: _saveImage,
                ),
              ],
            ),

            //  Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }

  Future<void> _saveImage() async {
    // await SqlDb()
    //     .update('Images', {'image': _imageFile!.path}, 'id = ${widget.noteId}');
    if (widget.noteModel.id == 0) {
      try {
        await SqlDb().insert('Images', {'id': 0, 'image': _imageFile!.path});
      } on Exception {
        int response = await SqlDb().updateData(''' 
        UPDATE Images
        SET image = '${_imageFile!.path}'
        WHERE id = 0
      ''');
        //print('response: $response');
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      int response = await SqlDb().insert(
          'Images', {'image': _imageFile!.path, 'noteId': widget.noteModel.id});
      //print('response $response');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotePage(
                    noteModel: widget.noteModel,
                  )));
    }

    //await SqlDb().insert('Images', {'image': _imageFile!.path});}
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const HomePage()));
    //print(_imageFile!.path);
  }
}
