import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utilities/app_ui.dart';

class BottomNavBar extends StatelessWidget {
  final Function() onTap0,onTap1,onTap2,onTap3;
  final int currentIndex;
  final String type;
  const BottomNavBar({Key? key,required this.currentIndex,required this.onTap0,required this.onTap1,required this.onTap2,required this.onTap3,required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
              color: Colors.grey[200]
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTap0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        SvgPicture.asset("${AppUI.iconPath}home.svg",height: 30,width: 30,color: currentIndex==0?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),),
                        // const SizedBox(height: 3,),
                        // CustomText(text: "home",textAlign: TextAlign.center,color: currentIndex==0?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onTap1,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        SvgPicture.asset("${AppUI.iconPath}chat.svg",height: 30,width: 30,color: currentIndex==1?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),),
                        // CustomText(text: "appointments".tr(),textAlign: TextAlign.center,color: currentIndex==1?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),)
                      ],
                    ),
                  ),
                  if(type!="doctor")
                  InkWell(
                    onTap: onTap2,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        SvgPicture.asset("${AppUI.iconPath}pills.svg",height: 30,width: 30,color: currentIndex==2?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),),
                        // const SizedBox(height: 3,),
                        // CustomText(text: "offer".tr(),textAlign: TextAlign.center,color: currentIndex==2?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onTap3,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        SvgPicture.asset("${AppUI.iconPath}user.svg",height: 30,width: 30,color: currentIndex==3?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),),
                        // const SizedBox(height: 3,),
                        // CustomText(text: "more".tr(),textAlign: TextAlign.center,color: currentIndex==3?AppUI.mainColor:Colors.grey[400]!.withOpacity(0.8),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
