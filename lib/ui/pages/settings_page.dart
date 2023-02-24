import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/services/theme.dart';

import '../../models/note.dart';
import '../../services/image_capture.dart';
import '../../services/theme_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Note noteModel = Note(id: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Change your Theme ',
                style: subHeadingStyle,
              ),
              IconButton(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  ThemeServices().switchTheme();
                },
                icon: Get.isDarkMode
                    ? const Icon(
                        Icons.wb_sunny_outlined,
                      )
                    : const Icon(Icons.nightlight_round_outlined),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageCapture(
                    noteModel: noteModel,
                  ),
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Update your Avatar',
                    style: subHeadingStyle,
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
