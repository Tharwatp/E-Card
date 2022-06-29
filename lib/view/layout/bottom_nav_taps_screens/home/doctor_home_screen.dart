import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/home/patient_details_screen.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/home/scan_qr_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/DoctorsModel.dart';
import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import '../../../../utilities/app_util.dart';
class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> states=[];
  List<String> orderIds=[];
  List<String> userIds=[];
  List<String> states2=[];
  List<String> orderIds2=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppUtil.responsiveHeight(context)*0.05,),
            Row(
              children: [
                CustomText(text: "Patients",fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                const Spacer(),
                IconButton(onPressed: (){
                  AppUtil.mainNavigator(context, ScanQrScreen());
                }, icon: const Icon(Icons.document_scanner_outlined))
              ],
            ),
            const SizedBox(height: 10,),
            FutureBuilder<List<DoctorsModel>>(
                future: getPatients(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.data!.isEmpty){
                    return const Center(child: CustomText(text: "No Patients Yet",fontSize: 18,));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(snapshot.data!.length, (index) {
                        return InkWell(
                          onTap: (){
                            // AppUtil.mainNavigator(context, DoctorDetailsScreen(doctor: snapshot.data![index],));
                          },
                          child: Row(
                            children: [
                              CustomCard(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data![index].img!,
                                      placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                      errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                          color: Colors.grey[200]
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(text: snapshot.data![index].name,fontSize: 16,fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                                          // CustomText(text: snapshot.data![index].speciality!.name!,fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey,),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),height: 140,width: 185,color: AppUI.mainColor,horizontal: 0,vertical: 0,onTap: (){
                                AppUtil.mainNavigator(context, PatientDetailsScreen(patient: snapshot.data![index],state: states[index],orderId: orderIds[index]));
                              },),
                              const SizedBox(width: 20,),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                CustomText(text: "Requests",fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<DoctorsModel>>(
                  future: getRequests(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(snapshot.data!.isEmpty){
                      return const Center(child: CustomText(text: "No Requests Found",fontSize: 18,));
                    }

                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: List.generate(snapshot.data!.length, (index) {
                        return InkWell(
                          onTap: (){
                            AppUtil.mainNavigator(context, PatientDetailsScreen(patient: snapshot.data![index],state: states2[index],orderId: orderIds2[index]));
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CachedNetworkImage(
                                        height: 50,width: 50,fit: BoxFit.fill,
                                        imageUrl: snapshot.data![index].img!,
                                        placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                        errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    CustomText(text: snapshot.data![index].name!.toUpperCase(),color: AppUI.blackColor,),
                                    // const Spacer(),
                                    // CircleAvatar(
                                    //   backgroundColor: AppUI.activeColor,
                                    //   radius: 14,
                                    //   child: Icon(Icons.check,color: AppUI.whiteColor,),
                                    // ),
                                    // const SizedBox(width: 10,),
                                    // CircleAvatar(
                                    //   backgroundColor: AppUI.errorColor,
                                    //   radius: 14,
                                    //   child: Icon(Icons.close,color: AppUI.whiteColor,),
                                    // ),
                                  ],
                                ),
                              ),
                              const Divider(height: 10,)
                            ],
                          ),
                        );
                      }),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<DoctorsModel>> getPatients() async {
    List<DoctorsModel> model = [];
    states.clear();
    orderIds.clear();
    userIds.clear();
    QuerySnapshot<Map<String,dynamic>> orders = await firestore.collection("orders").where("doctor_email",isEqualTo: auth.currentUser!.email).get();
    for (var element in orders.docs) {
      orderIds.add(element.id);
      states.add(element.data()['state_text']);
      DocumentSnapshot<Map<String,dynamic>> users = await firestore.collection("users").doc(element.data()['user_id']).get();
      if(!userIds.contains(element.data()['user_id'])) {
        model.add(DoctorsModel(users.data()!['name'], users.data()!['image'],element.data()['user_id'],age: users.data()!['age'],email: users.data()!['email'],gender: users.data()!['gender'],national_id: users.data()!['national_id']));
      }
      userIds.add(element.data()['user_id']);
    }
    return model;
  }

  Future<List<DoctorsModel>> getRequests() async {
    List<DoctorsModel> model = [];
    states2.clear();
    orderIds2.clear();
    QuerySnapshot<Map<String,dynamic>> orders = await firestore.collection("orders").where("doctor_email",isEqualTo: auth.currentUser!.email).where("status",isEqualTo: "pending").get();
    for (var element in orders.docs) {
      orderIds2.add(element.id);
      states2.add(element.data()['state_text']);
      DocumentSnapshot<Map<String,dynamic>> users = await firestore.collection("users").doc(element.data()['user_id']).get();
        model.add(DoctorsModel(users.data()!['name'], users.data()!['image'],element.data()['user_id'],age: users.data()!['age'],email: users.data()!['email'],gender: users.data()!['gender'],national_id: users.data()!['national_id']));
    }
    return model;
  }

}
