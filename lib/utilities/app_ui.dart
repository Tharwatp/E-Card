import 'package:flutter/material.dart';

class AppUI{

  static MaterialColor mainColor = const MaterialColor(0xff274D9B,{
    50:Color.fromRGBO(4,131,184, .1),
    100:Color.fromRGBO(4,131,184, .2),
    200:Color.fromRGBO(4,131,184, .3),
    300:Color.fromRGBO(4,131,184, .4),
    400:Color.fromRGBO(4,131,184, .5),
    500:Color.fromRGBO(4,131,184, .6),
    600:Color.fromRGBO(4,131,184, .7),
    700:Color.fromRGBO(4,131,184, .8),
    800:Color.fromRGBO(4,131,184, .9),
    900:Color.fromRGBO(4,131,184, 1),
  });

  static Color whiteColor = const Color(0xffffffff);
  static Color iconColor = const Color(0xff828282);
  static Color titleColor = const Color(0xff091355);
  static Color backgroundColor = const Color(0xffDDE0F2);
  static Color activeColor = Colors.green;
  static Color shimmerColor = Colors.grey[350]!;
  static Color errorColor = Colors.red;
  static Color blackColor = Colors.black;

  static String googleApiAndroid = "AIzaSyD38YQy10FmPig_gdVZAaFmbYh9znMoPds";
  static String googleApiIOS = "AIzaSyCT0kQS59FPeZtL9tRvshyGDz1iToySVo0";

  static String imgPath = "assets/images/";
  static String iconPath = "assets/icons/";
}