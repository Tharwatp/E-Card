import 'package:flutter/material.dart';

import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentPage = 0;
  final creditCardNum = TextEditingController();
  final cvv = TextEditingController();
  final expiryDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
                CustomText(text: "Checkout",
                  fontSize: 34,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w700,),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppUI.mainColor,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppUI.whiteColor,
                  ),
                ),
                Container(width: 30,height: 1,color: AppUI.mainColor,),
                CircleAvatar(
                  backgroundColor: currentPage==2 || currentPage==1?AppUI.mainColor:AppUI.mainColor.withOpacity(0.2),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppUI.whiteColor,
                  ),
                ),
                Container(width: 30,height: 1,color: currentPage==2 || currentPage==1?AppUI.mainColor:AppUI.mainColor.withOpacity(0.2),),
                CircleAvatar(
                  backgroundColor: currentPage==2?AppUI.mainColor:AppUI.mainColor.withOpacity(0.2),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppUI.whiteColor,
                  ),
                ),
              ],
            ),
            currentPage==0?Column(
              children: [
                CustomText(text: "Confirm Address",
                  fontSize: 34,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w700,),
                const SizedBox(height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(text: "fayrous Ahmed"),
                        Spacer(),
                        CustomText(text: "Mansoura, Egypt"),
                      ],
                    ),
                    CustomText(text: "Hay El-gammaa, Mansoura",
                      fontSize: 17,
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w700,),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(text: "fayrous Ahmed"),
                        Spacer(),
                        CustomText(text: "Mansoura, Egypt"),
                      ],
                    ),
                    CustomText(text: "Hay El-gammaa, Mansoura",
                      fontSize: 17,
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w700,),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(text: "fayrous Ahmed"),
                        Spacer(),
                        CustomText(text: "Mansoura, Egypt"),
                      ],
                    ),
                    CustomText(text: "Hay El-gammaa, Mansoura",
                      fontSize: 17,
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w700,),
                  ],
                ),
                Divider(),
                
              ],
            ):currentPage == 1?Column(
              children: [
                CustomText(text: "Payment",
                  fontSize: 34,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w700,),
                const SizedBox(height: 30,),
                CustomInput(controller: creditCardNum,hint: "Credit Card Number", textInputType: TextInputType.number),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(child: CustomInput(controller: cvv,hint: "CVV", textInputType: TextInputType.number)),
                    const SizedBox(width: 10,),
                    Expanded(child: CustomInput(controller: expiryDate, hint: "Expiry Date",textInputType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    CustomText(text: "Total Price"),
                    Spacer(),
                    CustomText(text: "125,200"),
                  ],
                )
              ],
            ):Column(
              children: [
                CustomText(text: "Success",
                  fontSize: 34,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w700,),
                const SizedBox(height: 30,),
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.check,color: AppUI.whiteColor,size: 60,),
                ),
                CustomText(text: "Thank you !",
                  fontSize: 34,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w700,),
              ],
            ),
            const SizedBox(height: 30,),
            CustomButton(text: currentPage!=2?"Next":"Continue Shopping",width: double.infinity,onPressed: (){
              if(currentPage!=2){
                currentPage++;
                setState(() {});
              }else{
                Navigator.pop(context);
              }
            },)
          ],
        ),
      ),
    );
  }
}
