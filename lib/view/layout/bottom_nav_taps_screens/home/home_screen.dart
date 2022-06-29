import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:ecard/utilities/app_util.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/home/doctor_details_screen.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/home/scan_qr_screen.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/home/speciality_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/DoctorsModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: FutureBuilder<DoctorsModel>(
          future: recommendationDoctor(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40,),
                Row(
                  children: [
                    CustomText(text: "Hello",fontSize: 34,fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                    const Spacer(),
                    IconButton(onPressed: (){
                      AppUtil.mainNavigator(context, ScanQrScreen());
                    }, icon: const Icon(Icons.document_scanner_outlined))
                  ],
                ),
                const SizedBox(height: 10,),
                CustomCard(
                  color: AppUI.mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Our recommendations",fontSize: 20,fontWeight: FontWeight.w700,color: AppUI.whiteColor,),
                        CustomText(text: "${snapshot.data!.name} is a general practitioner who can help you!",fontSize: 15,fontWeight: FontWeight.w500,color: AppUI.whiteColor,),
                        const SizedBox(height: 12,),
                        CustomButton(text: "View",color: AppUI.whiteColor,textColor: AppUI.mainColor,width: double.infinity,height: 3,radius: 9,onPressed: (){
                          AppUtil.mainNavigator(context, DoctorDetailsScreen(doctor: snapshot.data!,));
                        },),
                        const SizedBox(height: 7,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                CustomText(text: "Specialties",fontSize: 34,fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                SizedBox(
                  height: 111,
                  child: FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
                    future: firestore.collection("specialities").get(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(snapshot.data!.docs.length, (index) {
                            return Row(
                              children: [
                                CustomCard(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data!.docs[index].data()['image'],
                                      height: 40,color: AppUI.whiteColor,
                                      placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                      errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomText(text: snapshot.data!.docs[index].data()['name'],textAlign: TextAlign.center,fontSize: 12.0,color: AppUI.whiteColor,)
                                  ],
                                ),height: 111,width: 100,color: AppUI.mainColor,onTap: (){
                                  AppUtil.mainNavigator(context, SpecialityScreen(dept: snapshot.data!.docs[index].data(),deptId: snapshot.data!.docs[index].id));
                                },),
                                const SizedBox(width: 20,),
                              ],
                            );
                          }),
                        ),
                      );
                    }
                  ),
                ),
                const SizedBox(height: 20,),
                CustomText(text: "Top Doctors",fontSize: 34,fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                SizedBox(
                  height: 143,
                  child: FutureBuilder<List<DoctorsModel>>(
                    future: getTopDoctors(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(snapshot.data!.length, (index) {
                            return InkWell(
                              onTap: (){
                                AppUtil.mainNavigator(context, DoctorDetailsScreen(doctor: snapshot.data![index],));
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
                                              CustomText(text: snapshot.data![index].speciality!.name!,fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey,),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),height: 140,width: 185,color: AppUI.mainColor,horizontal: 0,vertical: 0,),
                                  const SizedBox(width: 20,),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<List<DoctorsModel>> getTopDoctors() async {
    QuerySnapshot<Map<String,dynamic>> doctors = await firestore.collection("doctors").get();
    List<DoctorsModel> model = [];
    for (var element in doctors.docs) {
      if(element.data()['reservation_count']!=0) {
        model.add(DoctorsModel(element.data()['name'], element.data()['image'], element.id,email: element.data()['email'],gender: element.data()['gender'],age: element.data()['age'],about: element.data()['about'],speciality: Speciality(element.data()['speciality']['id'], element.data()['speciality']['name']),reservation_count: element.data()['reservation_count'],price: element.data()['price']));
      }
    }
    model.sort((b, a) => a.reservation_count!.compareTo(b.reservation_count!));
    return model;
  }

  Future<DoctorsModel> recommendationDoctor() async{
    QuerySnapshot<Map<String,dynamic>> doctors = await firestore.collection("doctors").get();
    List<DoctorsModel> model = [];
    List<int> reservation_count = [];
    for (var element in doctors.docs) {
      reservation_count.add(element.data()['reservation_count']);
      model.add(DoctorsModel(element.data()['name'], element.data()['image'], element.id,email: element.data()['email'],gender: element.data()['gender'],age: element.data()['age'],speciality: Speciality(element.data()['speciality']['id'], element.data()['speciality']['name'])));
    }
    int maxIndex = reservation_count.indexOf(reservation_count.reduce(max));
    return model[maxIndex];
  }
}
