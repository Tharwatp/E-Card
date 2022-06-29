import 'package:ecard/shared/cash_helper.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:ecard/view/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/layout/bottom_nav_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit(),),
      ],
      child: MaterialApp(
        title: 'Aqua Fizz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppUI.whiteColor,
          appBarTheme: const AppBarTheme(color: Colors.white,iconTheme: IconThemeData(color: Colors.black)),
          primarySwatch: AppUI.mainColor,
          primaryColor: AppUI.mainColor,
          textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme).copyWith(
            bodyText1: GoogleFonts.cairo(textStyle: Theme.of(context).textTheme.bodyText1),
          ),
        ),
        home: const LandingPage(),
      ),
    );
  }
}
