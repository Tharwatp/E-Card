import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/bloc/layout/bottom_nav_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import '../../../../utilities/app_util.dart';
import '../home/chat/chat_screen.dart';
class ConsultingScreen extends StatefulWidget {
  const ConsultingScreen({Key? key}) : super(key: key);

  @override
  _ConsultingScreenState createState() => _ConsultingScreenState();
}

class _ConsultingScreenState extends State<ConsultingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppUtil.responsiveHeight(context) * 0.05,),
          Row(
            children: [
              // IconButton(onPressed: (){
              //   Navigator.pop(context);
              // }, icon: Icon(Icons.arrow_back_ios,color: AppUI.blackColor,)),
              CustomText(text: "Consultation",
                fontSize: 34,
                color: AppUI.blackColor,
                fontWeight: FontWeight.w700,),
            ],
          ),
          const SizedBox(height: 30,),
          CustomText(text: "Chats",
            fontSize: 28,
            color: AppUI.blackColor,
            fontWeight: FontWeight.w700,),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>?>>(
                future: getChats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: CustomText(
                      text: "No Chats Yet", fontSize: 18,));
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: List.generate(snapshot.data!.length, (index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              if (context
                                  .read<BottomNavCubit>()
                                  .type == "doctor") {
                                await FirebaseFirestore.instance.collection(
                                    "doctors")
                                    .where(
                                    "email", isEqualTo: auth.currentUser!.email)
                                    .get()
                                    .then((value) {
                                  AppUtil.mainNavigator(context, ChatScreen(
                                      auth.currentUser!.email==snapshot.data![index]!['idTo']!?snapshot.data![index]!['idFrom']!:snapshot.data![index]!['idTo']!,
                                      auth.currentUser!.email!,
                                      auth.currentUser!.email==snapshot.data![index]!['idTo']!?snapshot.data![index]!['userFrom']!:snapshot.data![index]!['userTo']!,
                                      value.docs[0].data()["name"] ?? ""));
                                });
                              } else {
                                await FirebaseFirestore.instance.collection(
                                    "users")
                                    .where(
                                    "email", isEqualTo: auth.currentUser!.email)
                                    .get()
                                    .then((value) {
                                  AppUtil.mainNavigator(context, ChatScreen(
                                      auth.currentUser!.email==snapshot.data![index]!['idTo']!?snapshot.data![index]!['idFrom']!:snapshot.data![index]!['idTo']!,
                                      auth.currentUser!.email!,
                                      auth.currentUser!.email==snapshot.data![index]!['idTo']!?snapshot.data![index]!['userFrom']!:snapshot.data![index]!['userTo']!,
                                      value.docs[0].data()["name"] ?? ""));
                                });
                              }
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                height: 50,width: 50,fit: BoxFit.fill,
                                imageUrl: snapshot.data![index]![context
                                    .read<BottomNavCubit>()
                                    .type == "doctor"?'userImg':'docImg']!,
                                placeholder: (context, url) => Image.asset("${AppUI.iconPath}profile.png"),
                                errorWidget: (context, url, error) => Image.asset("${AppUI.iconPath}profile.png"),
                              ),
                            ),
                            title: CustomText(
                              text: snapshot.data![index]!['idFrom'] ==
                                  auth.currentUser!.email ? snapshot
                                  .data![index]!['userTo'] : snapshot
                                  .data![index]!['userFrom'],
                              fontSize: 16,
                              color: AppUI.blackColor,),
                            subtitle: CustomText(
                              text: snapshot.data![index]!['idFrom'] ==
                                  auth.currentUser!.email ? snapshot
                                  .data![index]!['idTo'] : snapshot
                                  .data![index]!['idFrom'],
                              fontSize: 11,
                              color: AppUI.blackColor,),
                          ),
                          const Divider()
                        ],
                      );
                    }),
                  );
                }
            ),
          )
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>?>> getChats() async {
    var snapshot = await FirebaseFirestore.instance.collection("Messages")
        .where("idFrom", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    var snapshot2 = await FirebaseFirestore.instance.collection("Messages")
        .where("idTo", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    List<Map<String, dynamic>?> chatList = [];
    List<String> idsList = [];

    for (var element in snapshot2.docs) {
      print("idTo ${element.data()['idFrom']}");
      if (!idsList.contains(element.data()['idFrom']) || !idsList.contains(element.data()['idTo'])) {
        chatList.add(element.data());
      }
      idsList.add(element.data()['idFrom']);
      idsList.add(element.data()['idTo']);
    }

      for (var element in snapshot.docs) {
        print("idFrom ${element.data()['idFrom']}");
        if (!idsList.contains(element.data()['idFrom']) || !idsList.contains(element.data()['idTo'])) {
          chatList.add(element.data());
        }
        idsList.add(element.data()['idFrom']);
        idsList.add(element.data()['idTo']);
    }
    print(chatList);
    return chatList;
  }
}
