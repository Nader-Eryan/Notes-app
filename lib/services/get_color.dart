// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo/services/theme.dart';

class GetColor {
  int clr;
  GetColor({
    required this.clr,
  });
  getBGClr() {
    switch (clr) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
