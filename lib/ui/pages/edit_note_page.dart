import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/sql_database.dart';
import 'package:todo/models/note.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/services/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../../services/size_config.dart';

class EditNote extends StatefulWidget {
  final Note note;
  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
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
  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    //SqlDb sqlDb = SqlDb();
    _titleController.text = widget.note.title != null ? widget.note.title! : '';
    _noteController.text = widget.note.note!;
    _selectedRemind = widget.note.remind!;
    _selectedRepeat = widget.note.repeat!;
    selectedDate = DateTime.parse(widget.note.date!);
  }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    label: 'Update Reminder',
                    onTap: () async {
                      if (_noteController.text.isEmpty) {
                        return notValidNoteToast();
                      } else {
                        await addNote();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
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
    int response = await sqlDb.update(
        'notes',
        {
          'title': _titleController.text,
          'note': _noteController.text,
          'isCompleted': '${widget.note.isCompleted}',
          'date': '$selectedDate',
          'startTime': _startTime,
          'endTime': _endTime,
          'remind': '$_selectedRemind',
          'repeat': _selectedRepeat,
        },
        'id = ${widget.note.id}');
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
}
