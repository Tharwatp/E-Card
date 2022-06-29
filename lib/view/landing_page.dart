import 'package:ecard/bloc/layout/bottom_nav_cubit.dart';
import 'package:ecard/shared/cash_helper.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:ecard/utilities/app_util.dart';
import 'package:ecard/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/signup_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String type = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    middleWareAuth();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: "All Your Medical Records Are One Click Away",fontSize: 34,color: AppUI.blackColor,textAlign: TextAlign.center,),
              ],
            )),
            Expanded(child: Image.asset("${AppUI.imgPath}landing.png")),
             Expanded(child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(text: "Get Started",width: double.infinity,onPressed: () async {
                  context.read<BottomNavCubit>().type = await CashHelper.getSavedString("type", "");
                  AppUtil.mainNavigator(context, const SignUpScreen());
                },),
              ],
            )),
          ],
        ),
      ),
    );
  }

   middleWareAuth() async {
     String type = await CashHelper.getSavedString("type", "");
     context.read<BottomNavCubit>().type = type;
     if(type!="") AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
   }
}
