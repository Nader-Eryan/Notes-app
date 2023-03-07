import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/services/get_color.dart';
import 'package:todo/services/size_config.dart';
import 'package:todo/services/theme.dart';
import 'package:todo/ui/pages/note_page.dart';

import '../../db/sql_database.dart';
import '../../models/note.dart';

class ImageDialog extends StatelessWidget {
  final String link;
  const ImageDialog(this.link, this.noteModel, this.ImgId, {Key? key})
      : super(key: key);
  final Note noteModel;
  final int ImgId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.05,
          child: TextButton(
              onPressed: () {
                _confirmDeleteImage(context);
              },
              child: Icon(
                Icons.delete,
                color: GetColor(clr: noteModel.color!).getBGClr(),
              )),
        ),
        GestureDetector(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Dialog(
            child: Image.file(
              File(link),
              width: 1000,
              height: SizeConfig.screenHeight * .8,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(
                  'Are you sure you want to delete the selected image? '),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () async {
                    await _deleteImage(context, noteModel.id!);
                  },
                  child: const Text('SUBMIT'),
                ),
              ],
            ));
  }

  Future<void> _deleteImage(BuildContext context, int id) async {
    SqlDb sqlDb = SqlDb();
    int response = await sqlDb.deleteData('''
                                   DELETE FROM images WHERE id = ${ImgId}
                                      ''');
    print(response);
    if (response > 0) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotePage(
              noteModel: noteModel,
            ),
          ),
          (route) => false);
    }
  }
}
