import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/models/DoctorsModel.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:ecard/utilities/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'chat/chat_screen.dart';
class DoctorDetailsScreen extends StatefulWidget {
  final DoctorsModel? doctor;
  const DoctorDetailsScreen({Key? key, this.doctor}) : super(key: key);

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore.collection("orders").snapshots().listen((event) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.backgroundColor,
      body: Stack(
        children: [
          Container(
            color: AppUI.whiteColor,
            height: AppUtil.responsiveHeight(context)*0.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    height: 100,width: 100,fit: BoxFit.fill,
                    imageUrl: widget.doctor!.img!,
                    placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                    errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: AppUtil.responsiveHeight(context)*0.26),
            child: Card(
              elevation: 11,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(45),topRight: Radius.circular(45))
              ),
              child: Container(
                height: AppUtil.responsiveHeight(context)*0.6,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: widget.doctor!.name,fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                      CustomText(text: "Cardiology Specialist",fontSize: 19,color: AppUI.blackColor,),
                      CustomCard(
                        color: AppUI.mainColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: SvgPicture.asset("${AppUI.iconPath}patient.svg",color: AppUI.mainColor,),
                                      backgroundColor: AppUI.whiteColor,
                                    ),
                                    CustomText(text: widget.doctor!.reservation_count.toString(),fontSize: 16,color: AppUI.whiteColor,),
                                    CustomText(text: "Patient",fontSize: 16,color: AppUI.backgroundColor,),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: SvgPicture.asset("${AppUI.iconPath}clock.svg",color: AppUI.mainColor,),
                                      backgroundColor: AppUI.whiteColor,
                                    ),
                                    CustomText(text: "4 +",fontSize: 16,color: AppUI.whiteColor,),
                                    CustomText(text: "Years Experience",fontSize: 16,color: AppUI.backgroundColor,textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       CircleAvatar(
                              //         radius: 30,
                              //         child: SvgPicture.asset("${AppUI.iconPath}article.svg",color: AppUI.mainColor,),
                              //         backgroundColor: AppUI.whiteColor,
                              //       ),
                              //       CustomText(text: "120 +",fontSize: 16,color: AppUI.whiteColor,),
                              //       CustomText(text: "Reviews",fontSize: 16,color: AppUI.backgroundColor,),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomText(text: "About Doctor",fontSize: 18,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                      CustomText(text: widget.doctor!.about.toString(),fontSize: 18,color: AppUI.blackColor,),
                      const SizedBox(height: 20,),
                      CustomText(text: "Price",fontSize: 18,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                      CustomText(text: widget.doctor!.price.toString(),fontSize: 18,color: AppUI.blackColor,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height:60,child: FutureBuilder<Map<String,dynamic>?>(
                future: getOrder(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const SizedBox();
                  }
                  return  snapshot.data!['status']==null?CustomButton(text: "REQUEST CONSULTATION",width: AppUtil.responsiveWidth(context)*0.9,onPressed: () async {
                    var stateController = TextEditingController();
                    dialog(context, "Describe Your State", [
                      CustomInput(controller: stateController, textInputType: TextInputType.text,maxLines: 3,),
                      const SizedBox(height: 10,),
                      CustomButton(text: "Send",width: 90,radius: 7,onPressed: () async {
                        QuerySnapshot<Map<String,dynamic>> userData = await firestore.collection("users").where("email",isEqualTo: auth.currentUser!.email).get();
                        firestore.collection("orders").doc().set({"user_id": userData.docs[0].id,"doctor_id": widget.doctor!.id,"user_email": userData.docs[0].data()['email'],"doctor_email": widget.doctor!.email,"status": "pending","state_text": stateController.text}).then((value) {
                          int i = widget.doctor!.reservation_count!;
                          widget.doctor!.reservation_count = ++i;
                          firestore.collection("doctors").doc(widget.doctor!.id!).update({"reservation_count": widget.doctor!.reservation_count});
                          AppUtil.successToast(context, "Order Sent Successfully");
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          AppUtil.errorToast(context, "Failed Sent Order, Please Try Again Later");
                        });
                        setState(() {});
                      },)
                    ]);
                  },): snapshot.data!['status']=="pending"?CustomButton(text: "WAIT FOR RESPONSE",width: AppUtil.responsiveWidth(context)*0.9,):CustomButton(text: "Go To Chat",width: AppUtil.responsiveWidth(context)*0.9,onPressed: () async {
                    await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: auth.currentUser!.email).get().then((value) {
                      AppUtil.mainNavigator(context, ChatScreen(widget.doctor!.email!,auth.currentUser!.email!,widget.doctor!.name!,value.docs[0].data()["name"]??""));
                    });
                  },);
                }
              ),),
            ),
          )
        ],
      ),
    );
  }


  Future<Map<String, dynamic>?> getOrder() async {
    QuerySnapshot<Map<String, dynamic>> order = await firestore.collection("orders")
        .where("user_email", isEqualTo: auth.currentUser!.email)
        .where("doctor_email", isEqualTo: widget.doctor!.email)
        .get();
    for (var element in order.docs) {
      if(element.data()['status']!="completed" && element.data()['status']!="refused"){
        return element.data();
      }
    }
    return {};
  }
}
