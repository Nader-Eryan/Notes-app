import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/db/sql_database.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/ui/pages/note_page.dart';
import '../../services/get_color.dart';
import '../../services/size_config.dart';

import '../../models/note.dart';
import '../pages/edit_note_page.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({Key? key, required this.note}) : super(key: key);
  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotePage(
                noteModel: note,
              ),
            ),
          );
        },
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(
                    SizeConfig.orientation == Orientation.portrait ? 20 : 4)),
            width: SizeConfig.orientation == Orientation.portrait
                ? SizeConfig.screenWidth
                : SizeConfig.screenWidth / 2,
            margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: GetColor(clr: note.color!).getBGClr()),
                  child: Row(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title!,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 17,
                                      color: Colors.grey[300],
                                    ),
                                    Text(
                                      ' ${note.date!.split(' ')[0]}',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.grey[100],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          //print(task.id);
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    content: Text(
                                                        'Are you sure you want to delete the selected note? '),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'CANCEL'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await _deleteNote(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'SUBMIT'),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color:
                                              Color.fromARGB(255, 144, 10, 10),
                                        )),
                                    IconButton(
                                      onPressed: () async {
                                        setState(
                                          () {
                                            note.isCompleted =
                                                note.isCompleted == 1 ? 0 : 1;
                                          },
                                        );
                                        SqlDb sqlDb = SqlDb();
                                        int response =
                                            await sqlDb.updateData('''
                                  UPDATE notes SET 'isCompleted'= ${note.isCompleted} WHERE id = ${note.id}
                                  ''');
                                        if (response > 0) {
                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (context) => const HomePage()));
                                        }
                                      },
                                      icon: Icon(
                                        note.isCompleted == 0
                                            ? Icons.done
                                            : Icons.unpublished_outlined,
                                        color:
                                            const Color.fromARGB(255, 6, 81, 8),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EditNote(
                                              note: note,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.access_alarm),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                ' ${note.startTime} - ${note.endTime}',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: Colors.grey[100],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                note.note!,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        width: 0.5,
                        height: 60,
                        color: Colors.grey[200]!.withOpacity(.7),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          (note.isCompleted == 0 ? 'TODO' : 'Completed'),
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )));
  }

  Future<void> _deleteNote(BuildContext context) async {
    SqlDb sqlDb = SqlDb();
    int response = await sqlDb.deleteData('''
                                   DELETE FROM notes WHERE id = ${note.id}
                                      ''');
    if (response > 0) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    }
  }

  // _getBGClr() {
  //   switch (note.color) {
  //     case 0:
  //       return bluishClr;
  //     case 1:
  //       return pinkClr;
  //     case 2:
  //       return orangeClr;
  //     default:
  //       return bluishClr;
  //   }
  // }
}
