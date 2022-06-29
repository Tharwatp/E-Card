import 'package:ecard/view/layout/bottom_nav_taps_screens/pharmacy/taps/baby_page.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/pharmacy/taps/cosmotics_page.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/pharmacy/taps/drugs_page.dart';
import 'package:flutter/material.dart';

import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import '../../../../utilities/app_util.dart';
import 'cart_screen.dart';
class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  _PharmacyScreenState createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> with SingleTickerProviderStateMixin{
  var tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppUtil.responsiveHeight(context) * 0.05,),
        Row(
          children: [
            // IconButton(onPressed: (){
            //   Navigator.pop(context);
            // }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
            CustomText(text: "Pharmacy",
              fontSize: 34,
              color: AppUI.blackColor,
              fontWeight: FontWeight.w700,),
            const Spacer(),
            IconButton(onPressed: (){
              AppUtil.mainNavigator(context, CartScreen());
            }, icon: const Icon(Icons.shopping_cart))
          ],
        ),
        const SizedBox(height: 30,),
        DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: TabBar(
            controller: tabController,
              indicatorWeight: 2,
              indicatorColor: AppUI.mainColor,
              tabs: <Widget>[
                Tab(child: Text("Drugs",style: TextStyle(color: AppUI.mainColor,fontSize: 12),textAlign: TextAlign.center),),
                Tab(child: Text("Cosmotics",style: TextStyle(color: AppUI.mainColor,fontSize: 12),textAlign: TextAlign.center),),
                Tab(child: Text("Baby",style: TextStyle(color: AppUI.mainColor,fontSize: 12),textAlign: TextAlign.center),),
              ]
          ),
        ),
         Expanded(
          child: TabBarView(
            controller: tabController,
              children: const <Widget> [
                DrugsPage(),
                CosmoticsPage(),
                BabyPage(),
              ]),
        ),
      ],
    );
  }
}
