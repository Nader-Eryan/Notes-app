// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo/services/size_config.dart';
import 'package:todo/services/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.widget,
    this.controller,
    this.edgeInsets,
  }) : super(key: key);
  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;
  final EdgeInsets? edgeInsets;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            //height: 55,
            alignment: Alignment.center,
            child: TextField(
              autofocus: false,
              readOnly: widget == null ? false : true,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              controller: controller,
              style: subTitleStyle,
              decoration: InputDecoration(
                contentPadding:
                    edgeInsets ?? const EdgeInsets.fromLTRB(12, 24, 12, 16),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                isDense: true,
                hintText: hint,
                hintStyle: subTitleStyle,
                suffixIcon: widget,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: context.theme.backgroundColor, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              maxLines: 5,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
