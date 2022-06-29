import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/models/DoctorsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import '../../../../utilities/app_util.dart';
import 'chat/chat_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final DoctorsModel? patient;

  final state,orderId;
  const PatientDetailsScreen({Key? key, this.patient,this.state, this.orderId}) : super(key: key);

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var nameController = TextEditingController();
  var idNumController = TextEditingController();
  var emailController = TextEditingController();
  var historyController = TextEditingController();
  var genderController = TextEditingController();


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
    nameController.text = widget.patient!.name!;
    idNumController.text = widget.patient!.national_id!;
    emailController.text = widget.patient!.email!;
    genderController.text = widget.patient!.gender!;
    historyController.text = widget.state!;
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
                    imageUrl: widget.patient!.img!,
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
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
                          CustomText(text: widget.patient!.name,fontSize: 34,color: AppUI.blackColor,fontWeight: FontWeight.w700,),
                          const Spacer(),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.edit,color: AppUI.backgroundColor,)),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomInput(controller: nameController,readOnly: true, textInputType: TextInputType.text,hint: "Full Name",),
                            const SizedBox(height: 10,),
                            CustomInput(controller: idNumController,readOnly: true, textInputType: TextInputType.text,hint: "National ID Number"),
                            const SizedBox(height: 10,),
                            CustomInput(controller: emailController,readOnly: true, textInputType: TextInputType.text,hint: "Email address",),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(width: AppUtil.responsiveWidth(context)*0.4,child: CustomInput(controller: genderController, textInputType: TextInputType.text,hint: "Gender",suffixIcon: const Icon(Icons.arrow_drop_down_sharp),readOnly: true,onTap: (){

                                },)),
                                const Spacer(),
                                SizedBox(width: AppUtil.responsiveWidth(context)*0.4,child: CustomInput(controller: emailController, textInputType: TextInputType.text,hint: "Age",suffixIcon: const Icon(Icons.arrow_drop_down_sharp),readOnly: true,onTap: (){

                                },)),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            CustomInput(controller: historyController,readOnly: true, textInputType: TextInputType.text,hint: "Medical History",maxLines: 4,),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<Map<String,dynamic>?>(
            future: getOrder(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return const SizedBox();
              }
                return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(height:60,child: snapshot.data!['status']=="pending"? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(text: "Accept Request",color: AppUI.activeColor,width: AppUtil.responsiveWidth(context)*0.5,radius: 8,onPressed: ()async{
                        firestore.collection("orders").doc(widget.orderId).update({"status": "accepted"}).then((value) async {
                          AppUtil.successToast(context, "Order Accepted Successfully");
                          await FirebaseFirestore.instance.collection("doctors").where("email",isEqualTo: auth.currentUser!.email).get().then((value) {
                            AppUtil.mainNavigator(context, ChatScreen(widget.patient!.email!,auth.currentUser!.email!,widget.patient!.name!,value.docs[0].data()["name"]??"",orderId: snapshot.data!['id']));
                          });
                        }).onError((error, stackTrace) {
                          AppUtil.errorToast(context, "Failed Accept Order, Please Try Again Later");
                        });
                       setState(() {});
                      },),
                      const SizedBox(width: 7,),
                      CustomButton(text: "Decline",color: AppUI.errorColor,width: AppUtil.responsiveWidth(context)*0.4,radius: 8,onPressed: ()async{
                        firestore.collection("orders").doc(widget.orderId).update({"status": "refused"}).then((value) {
                          AppUtil.successToast(context, "Order Refused Successfully");
                        }).onError((error, stackTrace) {
                          AppUtil.errorToast(context, "Failed Refuse Order, Please Try Again Later");
                        });
                        setState(() {});
                      },),
                    ],
                  ):snapshot.data!['status']=="accepted"?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(text: "Go To Chat",width: AppUtil.responsiveWidth(context)*0.48,onPressed: () async {
                        await FirebaseFirestore.instance.collection("doctors").where("email",isEqualTo: auth.currentUser!.email).get().then((value) {
                          AppUtil.mainNavigator(context, ChatScreen(widget.patient!.email!,auth.currentUser!.email!,widget.patient!.name!,value.docs[0].data()["name"]??"",orderId: snapshot.data!['id']));
                        });
                        },),
                      CustomButton(text: "Finish Order",width: AppUtil.responsiveWidth(context)*0.48,onPressed: () async {
                        var stateController = TextEditingController();
                        dialog(context, "Please write your consultation", [
                          CustomInput(controller: stateController, textInputType: TextInputType.text,maxLines: 3,),
                          const SizedBox(height: 10,),
                          CustomButton(text: "Send",width: 90,radius: 7,onPressed: () async {
                            FirebaseFirestore.instance.collection("orders").doc(widget.orderId).update({"status": "completed"}).then((value) {
                              AppUtil.successToast(context, "Order Finished Successfully");
                            }).onError((error, stackTrace) {
                              AppUtil.errorToast(context, "Failed Finished Order, Please Try Again Later");
                            });
                            FirebaseFirestore.instance.collection("users").where("email", isEqualTo: snapshot.data!['user_email']).get().then((value){
                              FirebaseFirestore.instance.collection("users")
                              .doc(value.docs[0].id).collection('consultation').doc()
                              .update({"doc_email": auth.currentUser!.email, "consult": stateController.text}).catchError((e) {
                                FirebaseFirestore.instance.collection("users")
                                    .doc(value.docs[0].id).collection('consultation').doc()
                                    .set({"doc_email": auth.currentUser!.email, "consult": stateController.text});
                              },);

                            });
                            FirebaseFirestore.instance.collection("Messages").where("idFrom",isEqualTo: widget.patient!.email).get().then((value2) {
                              for (var element in value2.docs) {
                                FirebaseFirestore.instance.collection("Messages").doc(element.id).delete();
                              }
                            });
                            FirebaseFirestore.instance.collection("Messages").where("idTo",isEqualTo: widget.patient!.email).get().then((value2) {
                              for (var element in value2.docs) {
                                FirebaseFirestore.instance.collection("Messages").doc(element.id).delete();
                              }
                            });
                            setState(() {});
                            Navigator.pop(context);

                          },),
                        ]);

                        },),

                    ],
                  ):const SizedBox(),
                  ),
                ),
              );
            }
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> getOrder() async {
      QuerySnapshot<Map<String, dynamic>> order = await firestore.collection("orders")
          .where("doctor_email", isEqualTo: auth.currentUser!.email)
          .where("user_email", isEqualTo: widget.patient!.email)
          .get();
      for (var element in order.docs) {
        if(element.data()['status']!="completed" && element.data()['status']!="refused"){
          Map<String, dynamic>?map = element.data();
          map.addAll({"id": element.id});
          return map;
        }
      }
      return null;
  }
}
