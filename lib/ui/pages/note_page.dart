import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/db/sql_database.dart';
import 'package:todo/services/get_color.dart';
import 'package:todo/services/image_capture.dart';
import 'package:todo/services/theme.dart';
import 'package:todo/ui/pages/home_page.dart';
import '../../models/note.dart';
import '../../services/size_config.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.noteModel}) : super(key: key);
  final Note noteModel;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final List<String> imagesList = [];
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  @override
  void initState() {
    getImages();
    super.initState();
    _noteController.text = widget.noteModel.note!;
    _titleController.text = widget.noteModel.title!;
  }

  void getImages() async {
    List<Map> response = await SqlDb().readData('''
      SELECT * FROM 'images' WHERE noteId = ${widget.noteModel.id}
    ''');
    for (Map it in response) {
      imagesList.add(it['image']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GetColor(clr: widget.noteModel.color!).getBGClr(),
        centerTitle: true,
        elevation: 0,
        title: TextField(
          keyboardType: TextInputType.name,
          onEditingComplete: () async {
            await _editTitle();
            widget.noteModel.title = _titleController.text;
          },
          controller: _titleController,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _editNote();
                _editTitle();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              icon: const Icon(Icons.done))
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage())),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TextField(
                      onEditingComplete: () async {
                        await _editNote();
                        widget.noteModel.note = _noteController.text;
                      },
                      controller: _noteController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Tap to edit your note',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),

                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20), // <-- SEE HERE
                      ),
                      maxLines: 8,
                      minLines: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          imagesList.isEmpty
              ? Expanded(child: _noAttachments(context))
              : Expanded(
                  child: GridView.builder(
                    itemCount: imagesList.length,
                    itemBuilder: (context, index) => Image.file(
                      File(imagesList[index]),
                      height: SizeConfig.screenHeight / 3,
                      width: double.infinity,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 2.0,
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageCapture(
                              noteModel: widget.noteModel,
                            )));
                  },
                  icon: const Icon(Icons.image)),
              SizedBox(
                width: SizeConfig.screenWidth / 15,
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.record_voice_over)),
            ],
          ),
        ],
      ),
    );
  }

  Column _noAttachments(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No attached voices or images\n',
                style: subHeadingStyle,
              ),
              Text(
                '😔😔',
                style: headingStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editNote() async {
    SqlDb sqlDb = SqlDb();
    int response = await sqlDb.update(
        'notes',
        {
          'note': _noteController.text,
        },
        'id = ${widget.noteModel.id}');
  }

  Future<void> _editTitle() async {
    SqlDb sqlDb = SqlDb();
    int response = await sqlDb.update(
        'notes',
        {
          'title': _titleController.text,
        },
        'id = ${widget.noteModel.id}');
  }
}
