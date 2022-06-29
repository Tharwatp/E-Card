import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/layout/bottom_nav_cubit.dart';
import '../../shared/cash_helper.dart';
import '../../utilities/app_util.dart';
import 'LoginScreen.dart';
import 'confirmation_screen.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var nameController = TextEditingController();
  var idNumController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var rePassController = TextEditingController();
  var specialitiesController = TextEditingController();
  var aboutController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var priceController = TextEditingController();
  bool loading = false;
  var doctor = false;
  QuerySnapshot<Map<String, dynamic>>? speciality;
  XFile? file;

  late String specialityId;

  var formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: CustomText(text: "Welcome",fontSize: 24,fontWeight: FontWeight.bold,color: AppUI.blackColor,),backgroundColor: AppUI.whiteColor,elevation: 0,centerTitle: false,),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      file = (await _picker.pickImage(source: ImageSource.gallery))!;
                      setState(() {});
                    },
                    child: file==null?Container(
                      height: 120,width: 120,
                      color: Colors.grey[400],
                      child: Icon(Icons.photo_camera,size: 70,color: AppUI.whiteColor,),
                    ):Image.file(File(file!.path),height: 120,width: 120,fit: BoxFit.cover,),
                  ),
                ),
                const SizedBox(height: 20,),
                CustomInput(controller: nameController, textInputType: TextInputType.text,hint: "Full Name",),
                const SizedBox(height: 10,),
                CustomInput(controller: idNumController, textInputType: TextInputType.number,hint: "National ID Number"),
                const SizedBox(height: 10,),
                CustomInput(controller: emailController, textInputType: TextInputType.text,hint: "Email address",),
                const SizedBox(height: 10,),
                CustomInput(controller: passController, textInputType: TextInputType.text,obscureText: true,hint: "Password",),
                const SizedBox(height: 10,),
                CustomInput(controller: rePassController, textInputType: TextInputType.text,obscureText: true,hint: "Confirm Password",),
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
                const SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(value: false, groupValue: doctor, onChanged: (bool? v){
                            doctor = v!;

                            setState(() {});
                          },activeColor: AppUI.mainColor),
                          CustomText(text: "Patient",color: AppUI.iconColor,)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(value: true, groupValue: doctor, onChanged: (bool? v){
                            doctor = v!;
                            setState(() {});
                          },activeColor: AppUI.mainColor,),
                          CustomText(text: "Doctor",color: AppUI.iconColor,)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                if(doctor)
                Column(
                  children: [
                    CustomInput(controller: specialitiesController,validation: doctor, textInputType: TextInputType.text,suffixIcon: const Icon(Icons.arrow_drop_down_sharp),hint: "Specialities",readOnly: true,onTap: () async {
                      speciality ??= await firestore.collection("specialities").get();
                        dialog(context, "Specialities", List.generate(speciality!.docs.length, (index) {
                        return InkWell(
                          onTap: (){
                            specialitiesController.text = speciality!.docs[index].data()['name'];
                            specialityId = speciality!.docs[index].id;
                            Navigator.pop(context);
                            },
                            child: CustomText(text: speciality!.docs[index].data()['name']));
                      }));
                    },),
                    const SizedBox(height: 10,),
                    CustomInput(controller: priceController,validation: doctor, textInputType: TextInputType.number,hint: "Price",),
                    const SizedBox(height: 10,),
                    CustomInput(controller: aboutController,validation: doctor, textInputType: TextInputType.text,hint: "About Doctor",maxLines: 4,),
                  ],
                ),
                const SizedBox(height: 25,),
                if(loading)
                  InkWell(
                    onTap: (){
                      setState(() {
                        loading = false;
                      });
                    },
                      child: const LoadingWidget())
                else
                CustomButton(text: "Sign Up",width: double.infinity,onPressed: () async {
                  if(formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    dataValidation();
                  }
                },),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        AppUtil.mainNavigator(context, const LoginScreen());
                      },
                        child: const CustomText(text: "Already have an account",fontWeight: FontWeight.w600,))
                  ],
                ),
                const SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImg() async {
    String imageUrl;

    try {
      final reference = FirebaseStorage.instance.ref().child(
          "images")
          .child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());
      await reference.putFile(File(file == null ? "" : file!.path)).then((
          value) async {
        imageUrl = await value.ref.getDownloadURL();
        uploadData(imageUrl);
      }).onError((error, stackTrace) {
        setState(() {
          loading = true;
        });
        AppUtil.errorToast(
            context, "An Error Happened , Please Try Again Later");
        return Future.error(error.toString());
      });
    }catch(e){
      uploadData("");
    }
  }

   uploadData(String imageUrl) {
    Map<String,dynamic> data;
    if(doctor) {
      data = {
        "image": imageUrl,
        "name": nameController.text,
        "national_id": idNumController.text,
        "email": emailController.text.trim(),
        "gender": genderController.text,
        "age": ageController.text,
        "price": priceController.text,
        "speciality": {
            "name": specialitiesController.text,
            "id": specialityId
        },
        "about": aboutController.text,
        "reservation_count": 0
      };
    }else{
      data = {
        "image": imageUrl,
        "name": nameController.text,
        "national_id": idNumController.text,
        "email": emailController.text.trim(),
        "gender": genderController.text,
        "age": ageController.text,
      };
    }
     firestore.collection(doctor?"doctors":"users").doc().set(data).then((value) {
       createUserWithEmail();
     });

   }
   createUserWithEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passController.text).then((value) {
      setState(() {
        loading = false;
        CashHelper.setSavedString("type", doctor?"doctor":"user");
        context.read<BottomNavCubit>().type = doctor?"doctor":"user";
        AppUtil.successToast(context, "Done created user");
        AppUtil.removeUntilNavigator(context, const ConfirmationScreen());
      });
    }).onError((error, stackTrace) {
      AppUtil.errorToast(context, error.toString().split("]")[1]);
    });
   }

   dataValidation() {
    if(!emailController.text.contains("@") || !emailController.text.contains(".")){
      AppUtil.errorToast(context, "Please Enter A Valid Email Address");
      return;
    }
    if(passController.text.length<6){
      AppUtil.errorToast(context, "Password musn't be less than 6 charactar");
      return;
    }
    if(passController.text != rePassController.text){
      AppUtil.errorToast(context, "Password dosen't match confirmation password");
      return;
    }
    firestore.collection(doctor?"doctors":"users").where("email",isEqualTo: emailController.text.trim()).get().then((value) {
      if(value.docs.isEmpty){
        uploadImg();
      }else{
        createUserWithEmail();
      }
    });

   }
}
