import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:ecard/utilities/app_util.dart';
import 'package:ecard/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:flutter/material.dart';
class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomText(text: "Please pick up your card at closest vendor",textAlign: TextAlign.center,fontSize: 34,fontWeight: FontWeight.w700,color: AppUI.blackColor,),
          ),
          const SizedBox(height: 20,),
          CustomButton(text: "Confirm",width: AppUtil.responsiveWidth(context)*0.9,onPressed: (){
            AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
          },),
          const Spacer(),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: AppUtil.responsiveHeight(context)*0.4,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(200),topRight: Radius.circular(200),),
                  color: AppUI.mainColor.withOpacity(0.2)
                ),
              ),
              Center(child: Image.asset("${AppUI.imgPath}congrate.png",height: AppUtil.responsiveHeight(context)*0.5,fit: BoxFit.fill,),),
            ],
          )
        ],
      ),
    );
  }
}
