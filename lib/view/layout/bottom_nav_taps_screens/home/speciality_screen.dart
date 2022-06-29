import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/models/DoctorsModel.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utilities/app_ui.dart';
import 'doctor_details_screen.dart';

class SpecialityScreen extends StatefulWidget {
  final Map<String,dynamic>? dept;
  final String? deptId;
  const SpecialityScreen({Key? key, this.dept,this.deptId}) : super(key: key);

  @override
  _SpecialityScreenState createState() => _SpecialityScreenState();
}

class _SpecialityScreenState extends State<SpecialityScreen> {
  int doctorsCount = 0;

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
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
                CustomText(text: widget.dept!['name'],fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,)
              ],
            ),
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.dept!['image'],
                          placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                          errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                        ),
                        SizedBox(width: AppUtil.responsiveWidth(context)*0.6,child: CustomText(text: "Our ${widget.dept!['name']} section includes $doctorsCount doctors",color: AppUI.whiteColor,fontSize: 17,fontWeight: FontWeight.w500,)),
                      ],
                    ),
                  ],
                ),
              ),color: AppUI.mainColor,
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                CustomText(text: "Doctors",fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<DoctorsModel>>(
                future: getDoctors(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.data!.isEmpty){
                    return const Center(child: CustomText(text: "No Doctors Found",fontSize: 18,));
                  }

                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: List.generate(snapshot.data!.length, (index) {
                      return Column(
                        children: [
                          CustomCard(
                            color: AppUI.backgroundColor,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  height: 50,width: 50,fit: BoxFit.fill,
                                  imageUrl: snapshot.data![index].img!,
                                  placeholder: (context, url) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                  errorWidget: (context, url, error) => SvgPicture.asset("${AppUI.iconPath}dog.svg"),
                                ),
                              ),
                              title: CustomText(text: snapshot.data![index].name,fontSize: 16,color: AppUI.blackColor,fontWeight: FontWeight.w500,),
                              subtitle: CustomText(text: "${snapshot.data![index].price} LE",fontSize: 13,color: AppUI.blackColor,fontWeight: FontWeight.w500,),
                            ),onTap: (){
                              AppUtil.mainNavigator(context, DoctorDetailsScreen(doctor: snapshot.data![index]));
                          },
                          ),
                          const SizedBox(height: 10,)
                        ],
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

  Future<List<DoctorsModel>> getDoctors() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot<Map<String,dynamic>> doctors = await firestore.collection("doctors").where("speciality",isEqualTo: {"id":widget.deptId,"name":widget.dept!['name']}).get();
    List<DoctorsModel> model = [];
    for (var element in doctors.docs) {
      model.add(DoctorsModel(element.data()['name'], element.data()['image'], element.id,email: element.data()['email'],gender: element.data()['gender'],age: element.data()['age'],about: element.data()['about'],speciality: Speciality(element.data()['speciality']['id'], element.data()['speciality']['name']),reservation_count: element.data()['reservation_count'],price: element.data()['price']));
    }
    doctorsCount = model.length;
    setState(() {});
    return model;
  }
}
