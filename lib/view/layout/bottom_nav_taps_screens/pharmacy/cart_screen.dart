import 'package:ecard/utilities/app_util.dart';
import 'package:flutter/material.dart';

import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import 'checkout_screen.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Cart"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: List.generate(3, (index) {
            return Column(
              children: [
                ListTile(
                  title: const CustomText(text: "53LE"),
                  subtitle: CustomText(text: "Neurovit",color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                  leading:  Image.asset("${AppUI.imgPath}drug.png",height: 80,width: 80,),
                ),
                Divider()
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 55,
        child: CustomButton(text: "Checkout",width: AppUtil.responsiveWidth(context)*0.9,onPressed: (){
          AppUtil.mainNavigator(context, CheckoutScreen());
        },),
      ),
    );
  }
}
