import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/shared/cash_helper.dart';
import 'package:ecard/view/auth/signup_screen.dart';
import 'package:ecard/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/layout/bottom_nav_cubit.dart';
import '../../shared/components.dart';
import '../../utilities/app_ui.dart';
import '../../utilities/app_util.dart';
import 'confirmation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var doctor = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: CustomText(text: "Welcome Back",fontSize: 22,fontWeight: FontWeight.bold,color: AppUI.blackColor,),backgroundColor: AppUI.whiteColor,elevation: 0,centerTitle: false,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            CustomInput(controller: emailController, textInputType: TextInputType.emailAddress,hint: "Email"),
            const SizedBox(height: 10,),
            CustomInput(controller: passController, textInputType: TextInputType.text,obscureText: true,hint: "Password",),
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
            const Spacer(),
            CustomButton(text: "Log In",width: double.infinity,onPressed: () async {
              QuerySnapshot<Map<String,dynamic>> userData;
              if(doctor){
                userData = await firestore.collection("doctors").where("email",isEqualTo: emailController.text.trim()).get();
              }else{
               userData = await firestore.collection("users").where("email",isEqualTo: emailController.text.trim()).get();
              }
              if(userData.docs.isEmpty){
                return AppUtil.errorToast(context, "Invalid Data");
              }
              FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passController.text).then((value) {
                CashHelper.setSavedString("type", doctor?"doctor":"user");
                context.read<BottomNavCubit>().type = doctor?"doctor":"user";
                AppUtil.successToast(context, "Login Successfully");
                  AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
              }).onError((error, stackTrace) {
                AppUtil.errorToast(context, error.toString().split("]")[1]);
              });
            },),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: (){
                      AppUtil.mainNavigator(context, const SignUpScreen());
                    },
                    child: const CustomText(text: "Create new account",fontWeight: FontWeight.w600,))
              ],
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
