import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/sql_database.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/services/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'dart:ui' as ui;

import '../../services/size_config.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  //final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  ui.TextDirection textDir = ui.TextDirection.rtl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
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
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              'Add Note',
              style: headingStyle,
            ),
            InputField(
              title: 'Title',
              hint: 'Enter title here',
              controller: _titleController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                textDirection: textDir,
                //Then in onChanged method type the following:
                onChanged: (val) {
                  // here this regexp only for English chars so in your case find the suitable regex for the language you want
                  RegExp exp = RegExp('[a-zA-Z]');
                  // simply checking if the last char is an English char and not space make the textDirection left to right
                  if (exp.hasMatch(val.substring(val.length - 1)) &&
                      val.substring(val.length - 1) != ' ') {
                    setState(() {
                      textDir = ui.TextDirection.ltr;
                    });
                  } else if (val.substring(val.length - 1) != ' ' &&
                      !exp.hasMatch(val.substring(val.length - 1))) {
                    setState(() {
                      textDir = ui.TextDirection.rtl;
                    });
                  }
                  // this line is to indicate the change of the last char in the string will print true or false
                  print(exp.hasMatch(val.substring(val.length - 1)).toString());
                },

                controller: _noteController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Enter Note',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),

                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20), // <-- SEE HERE
                ),
                maxLines: 6,
                minLines: 3,
              ),
            ),
            _addDateBar(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showTimePicker(context, true);
                    },
                    child: ListTile(
                      title: Text('Start Time'),
                      subtitle: Text(_startTime),
                      trailing: const Icon(Icons.alarm),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showTimePicker(context, false);
                    },
                    child: ListTile(
                      title: Text('End Time'),
                      subtitle: Text(_endTime),
                      trailing: const Icon(Icons.alarm),
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              title: 'Remind',
              hint: '$_selectedRemind minutes early',
              widget: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                // value: _selectedRemind.toString(),
                dropdownColor: Colors.blueGrey,
                icon: Row(
                  children: const [
                    Icon(Icons.keyboard_arrow_down),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                iconSize: 32,
                elevation: 4,
                underline: Container(
                  height: 0,
                ),
                style: subTitleStyle,
                items: remindList
                    .map<DropdownMenuItem<String>>(
                      (int e) => DropdownMenuItem<String>(
                        value: e.toString(),
                        child: Text(
                          '$e',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRemind = int.parse('$value');
                  });
                },
              ),
            ),
            InputField(
              title: 'Repeat',
              hint: _selectedRepeat,
              widget: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                // value: _selectedRepeat,
                dropdownColor: Colors.blueGrey,
                icon: Row(
                  children: const [
                    Icon(Icons.keyboard_arrow_down),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                iconSize: 32,
                elevation: 4,
                underline: Container(
                  height: 0,
                ),
                style: subTitleStyle,
                items: repeatList
                    .map<DropdownMenuItem<String>>(
                      (String e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRepeat = value!;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Color',
                      style: titleStyle,
                    ),
                    Wrap(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(
                              right: 8, bottom: 10, top: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: CircleAvatar(
                                child: index == _selectedColor
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : null,
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                        ? pinkClr
                                        : orangeClr),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                MyButton(
                  label: 'Create Note',
                  onTap: () async {
                    if (_noteController.text.isEmpty) {
                      return notValidNoteToast();
                    } else {
                      await addNote();
                    }
                  },
                )
              ],
            )
          ],
        )),
      ),
    );
  }

  void _showTimePicker(BuildContext context, bool isStart) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        if (isStart)
          _startTime = value.format(context);
        else
          _endTime = value.format(context);
      });
    });
  }

  Future<bool?> notValidNoteToast() {
    return Fluttertoast.showToast(
        msg: 'Please enter a valid note!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> addNote() async {
    SqlDb sqlDb = SqlDb();
    int response = await sqlDb.insert('notes', {
      'title': _titleController.text,
      'note': _noteController.text,
      'isCompleted': 0,
      'date': '$selectedDate',
      'startTime': _startTime,
      'endTime': _endTime,
      'color': '$_selectedColor',
      'remind': '$_selectedRemind',
      'repeat': _selectedRepeat,
    });
    if (response > 0) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    } else {
      print('some fields are empty!');
    }
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: SizeConfig.orientation == Orientation.portrait ? 100 : 85,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            selectedDate = newDate;
          });
        },
        initialSelectedDate: selectedDate,
        dateTextStyle: GoogleFonts.lato(
          color: Colors.grey[700],
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          color: Colors.grey[700],
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          color: Colors.grey[700],
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
