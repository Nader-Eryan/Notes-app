import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todo/db/sql_database.dart';
import 'package:todo/ui/pages/add_note_page.dart';
import 'package:todo/ui/pages/settings_page.dart';
import 'package:todo/services/theme.dart';
import 'package:todo/ui/widgets/note_tile.dart';

import '../../models/note.dart';
import '../../services/size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Map> notes = [];
String? myImagePath;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    readProfilePic();
    //print('after readNotes=========');
    super.initState();
    readNotes();
    //SqlDb().myDeleteDatabase();
  }

  void readNotes() async {
    SqlDb sqlDb = SqlDb();
    notes = [];
    notes.addAll(await sqlDb.read('notes'));
    setState(() {});
    //print('readNotes=============');
  }

  void readProfilePic() async {
    SqlDb sqlDb = SqlDb();
    List<dynamic> temp = await sqlDb.read('Images');
    //print(temp);
    try {
      myImagePath = await temp[0]['image'];
    } on Error {
      myImagePath = null;
    }
    // print(myImagePath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Column(
        children: [
          _dataBar(),
          //_addDateBar(),
          SizedBox(
            width: SizeConfig.orientation == Orientation.portrait ? 6 : 0,
          ),
          _showNotes(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.isDarkMode ? Colors.lightBlue : Colors.blue,
        onPressed: () async {
          Navigator.of(this.context).push(
              MaterialPageRoute(builder: (context) => const AddNotePage()));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Container _dataBar() {
    return Container(
      height: SizeConfig.orientation == Orientation.portrait ? 40 : 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat().add_yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              // Text(
              //   'Today',
              //   style: headingStyle,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: SizeConfig.orientation == Orientation.portrait ? 50 : 40,
      iconTheme: IconThemeData(
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      actions: [
        CircleAvatar(
          backgroundImage: myImagePath == null
              ? const AssetImage('images/person.jpeg')
              : FileImage(File(myImagePath!)) as ImageProvider,
          radius: 18,
        ),
        const SizedBox(
          width: 20,
        ),
      ],
      leading: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsPage()));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }

  _showNotes() {
    return Expanded(
        child: notes.isEmpty
            ? _noNotesMsg()
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, i) {
                  return NoteTile(
                    note: Note(
                        date: notes[i]['date'],
                        remind: notes[i]['remind'],
                        repeat: notes[i]['repeat'],
                        id: notes[i]['id'],
                        title: notes[i]['title'],
                        note: notes[i]['note'],
                        color: notes[i]['color'],
                        isCompleted: notes[i]['isCompleted'],
                        startTime: notes[i]['startTime'],
                        endTime: notes[i]['endTime']),
                  );
                }));
  }

  _noNotesMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.portrait
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.portrait
                      ? const SizedBox(
                          height: 200,
                        )
                      : Center(
                          child: Container(
                            height: 0,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'images/note.svg',
                      semanticsLabel: 'noNotes',
                      height: SizeConfig.orientation == Orientation.portrait
                          ? 100
                          : 60,
                      color: primaryClr.withOpacity(.6),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'You don\'t have any notes yet!\nAdd new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
          ),
        )
      ],
    );
  }
}
