import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/bloc/layout/bottom_nav_cubit.dart';
import 'package:ecard/models/DoctorsModel.dart';
import 'package:ecard/shared/cash_helper.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/components.dart';
import '../../../../utilities/app_util.dart';
import 'my_consultation_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameController = TextEditingController();
  var idNumController = TextEditingController();
  var emailController = TextEditingController();
  var historyController = TextEditingController();
  var genderController = TextEditingController();
  var ageController = TextEditingController();
  bool editState = false;
  DoctorsModel? model ;
  List consultation = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData().then((value) {
      setData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DoctorsModel>(
      future: getProfileData(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppUtil.responsiveHeight(context)*0.05,),
              Row(
                children: [
                  // IconButton(onPressed: (){
                  //   Navigator.pop(context);
                  // }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
                  CustomText(text: "Profile",fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                  const Spacer(),
                  IconButton(onPressed: () async {
                    await FirebaseFirestore.instance.collection(context.read<BottomNavCubit>().type=="doctor"?"doctors":"users").where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async {
                      await FirebaseFirestore.instance.collection(context.read<BottomNavCubit>().type=="doctor"?"doctors":"users").doc(value.docs[0].id).update(context.read<BottomNavCubit>().type=="doctor"?{
                        "name": nameController.text,
                        "national_id": idNumController.text,
                        "gender": genderController.text,
                        "age": ageController.text,
                        "about": historyController.text
                      }:{
                        "name": nameController.text,
                        "national_id": idNumController.text,
                        "gender": genderController.text,
                        "age": ageController.text,
                      });
                      setState(() {

                      });
                      AppUtil.successToast(context, "Edited Successfully");
                    });
                  }, icon: Icon(Icons.edit,color: AppUI.backgroundColor,)),
                ],
              ),
              const SizedBox(height: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!.img!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset("${AppUI.imgPath}profile.png",height: 100,width: 100,fit: BoxFit.fill,),
                  errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}profile.png",height: 100,width: 100,fit: BoxFit.fill,),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomInput(controller: nameController, textInputType: TextInputType.text,hint: "Full Name",),
                    const SizedBox(height: 10,),
                    CustomInput(controller: idNumController, textInputType: TextInputType.text,hint: "National ID Number"),
                    // const SizedBox(height: 10,),
                    // CustomInput(controller: emailController, textInputType: TextInputType.text,hint: "Email address",),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(width: AppUtil.responsiveWidth(context)*0.45,child: CustomInput(controller: genderController, textInputType: TextInputType.text,hint: "Gender",suffixIcon: const Icon(Icons.arrow_drop_down_sharp),readOnly: true,onTap: (){
                          dialog(context, "Gender", [
                            InkWell(onTap: (){
                              genderController.text = "Male";
                              Navigator.pop(context);
                            },child: const CustomText(text: "Male")),
                            const Divider(),
                            InkWell(
                              onTap: (){
                                genderController.text = "Female";
                                Navigator.pop(context);
                              },
                                child: const CustomText(text: "Female")),
                          ]);
                        },)),
                        const Spacer(),
                        SizedBox(width: AppUtil.responsiveWidth(context)*0.45,child: CustomInput(controller: ageController, textInputType: TextInputType.text,hint: "Birth Date",suffixIcon: const Icon(Icons.arrow_drop_down_sharp),readOnly: true,onTap: () async {
                          DateTime? date =  await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year-100), lastDate: DateTime.now(),);
                          if(date!=null) {
                            ageController.text = "${date.year}-${date.month}-${date.day}";
                          }
                        },)),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    if(context.read<BottomNavCubit>().type=="doctor")
                    CustomInput(controller: historyController, textInputType: TextInputType.text,hint: "Medical History",maxLines: 4,)
                    else
                      CustomButton(text: "MY CONSULTATIONS",width: double.infinity,onPressed: (){
                        AppUtil.mainNavigator(context, MyConsultationScreen(consultation: consultation,));
                      },),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            CashHelper.logOut(context);
                          },
                            child: CustomText(text: "Logout",fontSize: 18,color: AppUI.mainColor,textDecoration: TextDecoration.underline,))
                      ],
                    ),
                    const SizedBox(height: 30,),
                    CustomButton(text: "Edit".toUpperCase(),width: double.infinity,onPressed: () async {
                      await FirebaseFirestore.instance.collection(context.read<BottomNavCubit>().type=="doctor"?"doctors":"users").where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async {
                        await FirebaseFirestore.instance.collection(context.read<BottomNavCubit>().type=="doctor"?"doctors":"users").doc(value.docs[0].id).update(context.read<BottomNavCubit>().type=="doctor"?{
                          "name": nameController.text,
                          "national_id": idNumController.text,
                          "gender": genderController.text,
                          "age": ageController.text,
                          "about": historyController.text
                        }:{
                          "name": nameController.text,
                          "national_id": idNumController.text,
                          "gender": genderController.text,
                          "age": ageController.text,
                        });
                        setState(() {

                        });
                        AppUtil.successToast(context, "Edited Successfully");
                      });
                    },),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Future<DoctorsModel> getProfileData() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    QuerySnapshot<Map<String,dynamic>> doctors = await firestore.collection(context.read<BottomNavCubit>().type=="doctor"?"doctors":"users").where("email",isEqualTo: auth.currentUser!.email).get();
    if(context.read<BottomNavCubit>().type!="doctor") {
      model = DoctorsModel(
          doctors.docs[0].data()['name'], doctors.docs[0].data()['image'],
          doctors.docs[0].id, email: doctors.docs[0].data()['email'],
          national_id: doctors.docs[0].data()['national_id'],
          gender: doctors.docs[0].data()['gender'],
          age: doctors.docs[0].data()['age']);
      doctors.docs[0].reference.collection("consultation").get().then((value) {
        consultation.clear();
        for (var element in value.docs) {
            consultation.add({"consult": element.data()['consult'],"doc_email": element.data()['doc_email']});
            // print('consultation : $consultation');
        }
      });
    }else{
      model = DoctorsModel(
          doctors.docs[0].data()['name'], doctors.docs[0].data()['image'],
          doctors.docs[0].id, email: doctors.docs[0].data()['email'],
          national_id: doctors.docs[0].data()['national_id'],
          gender: doctors.docs[0].data()['gender'],
          age: doctors.docs[0].data()['age'],about: doctors.docs[0].data()['about'],speciality: Speciality(doctors.docs[0].data()['speciality']['id'], doctors.docs[0].data()['speciality']['name']));
    }

    return model!;
  }

  void setData() {
    nameController.text = model!.name ?? "";
    idNumController.text = model!.national_id ?? "";
    genderController.text = model!.gender ?? "";
    historyController.text = model!.about ?? "";
    ageController.text = model!.age ?? "";
    setState(() {

    });
  }
}
