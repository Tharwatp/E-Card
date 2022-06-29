import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecard/shared/components.dart';
import 'package:ecard/utilities/app_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/layout/bottom_nav_cubit.dart';
import '../../../../../utilities/app_util.dart';
class ChatScreen extends StatefulWidget {
  String uploaderUid,myUid,uploaderUserName,myUserName;

  ChatScreen(this.uploaderUid, this.myUid, this.uploaderUserName,this.myUserName, {orderId});

  @override
  _ChatScreenState createState() => _ChatScreenState(this.uploaderUid, this.myUid, this.uploaderUserName,this.myUserName);
}

class _ChatScreenState extends State<ChatScreen> {
  String toUid,fromUid,toUserName,fromUserName;
  List<String> messagesList = [];
  List<String> idFromList = [];
  String docImg ="",userImg="";
  // FirebaseAuth auth = FirebaseAuth.instance;
  String onlineState= "";
  var msgController = TextEditingController();

  var listScrolleController = ScrollController();

  _ChatScreenState(this.toUid, this.fromUid, this.toUserName,this.fromUserName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatData();
    print(fromUserName);
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      listScrolleController.jumpTo(0.0);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUI.mainColor,
        title: Column(
          children: [
            Text(toUserName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            // Text(onlineState,style: const TextStyle(color: Colors.white,fontSize: 12),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          controller: listScrolleController,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .77,
              child:messagesList.isEmpty ? const SizedBox(): ListView.builder(
                  shrinkWrap: true,
                  controller: listScrolleController,
                  itemCount: messagesList.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return ChatCardUi(messagesList[index],index,idFromList[index]);
                  }
              ),
            ),



            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: (){
                      sendMsg();
                    },
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      // height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(65)),
                          color: AppUI.mainColor
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.send,textDirection: TextDirection.rtl,color: Colors.white,),
                    ),
                  ),
                ),

                const SizedBox(width: 2,),

                Expanded(
                  flex: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      color: Color(0xffF2F2F2),
                    ),
                    child: TextFormField(
                      controller: msgController,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Write a message ..",
                        hintStyle: TextStyle(color: Color(0xff707070)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(27)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(27)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(27)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(27)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendMsg()  async {
    if(msgController.text!=""){
      var msgRef = await FirebaseFirestore.instance.collection("Messages").doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction)async{
        await transaction.set(msgRef, {
          "idFrom":   fromUid,
          "idTo": toUid,
          "userFrom": fromUserName,
          "userTo": toUserName,
          "msgTime": DateTime.now().millisecondsSinceEpoch.toString(),
          "msg":msgController.text,
          "docImg": docImg,
          "userImg": userImg
        });
      }).then((value) {
        msgController.text="";
        listScrolleController.jumpTo(0.0);
      });

      FirebaseFirestore.instance.collection("Uploaders").doc(toUid)
          .set({'messageNotification': true,'msgBody':msgController.text},SetOptions(merge: true)).whenComplete(() {

      });


    }
  }

  Widget ChatCardUi(String doc, int index,String idFrom) {
    // print(index);
    // print(doc.get('idFrom')+doc.get('idTo'));
    // print(fromUid+toUid);
    // print(toUid+fromUid);
    if (idFrom == fromUid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: AppUI.mainColor
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width * .7),
              child: Text(
                doc, style: const TextStyle(color: Colors.white),

              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: Colors.grey
            ),
            child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * .7),
                child: Text(doc, style: const TextStyle(color: Colors.white),)),
          ),
        ],
      );
    }
  }

Future<void> getChatData() async {
  var myImg = await FirebaseFirestore.instance.collection(context
      .read<BottomNavCubit>()
      .type == "doctor"?"doctors":"users").where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email).get();

  print("toId : $toUid");
    var anotherImg = await FirebaseFirestore.instance.collection(context
      .read<BottomNavCubit>()
      .type == "doctor"?"users":"doctors").where("email",isEqualTo: toUid).get();

  // try {
    docImg = context
        .read<BottomNavCubit>()
        .type == "doctor" ? myImg.docs[0].data()['image'] : anotherImg.docs[0]
        .data()['image'];
  // }catch(e){}
  // try {
    userImg = context
        .read<BottomNavCubit>()
        .type != "doctor" ? myImg.docs[0].data()['image'] : anotherImg.docs[0]
        .data()['image'];
  // }catch(e){}
    await FirebaseFirestore.instance.collection("Messages").snapshots().listen((event) async {
      await FirebaseFirestore.instance.collection("Messages")
          .orderBy("msgTime",descending: true).get().then((value) async {
        messagesList.clear();
        idFromList.clear();
        for(int i = 0 ; i< value.docs.length ; i++) {
          var msg = await value.docs[i].get('msg');
          var idFrom = await value.docs[i].get('idFrom');
          if (value.docs[i].get('idFrom') + value.docs[i].get('idTo') ==
              fromUid + toUid ||
              value.docs[i].get('idFrom') + value.docs[i].get('idTo') ==
                  toUid + fromUid) {
            setState(() {
              messagesList.add(msg);
              idFromList.add(idFrom);
            });
          }
        }

      });
    });
  if(messagesList.isEmpty){
    msgController.text = "Hello";
    sendMsg();
  }

}
// Future<Map> retriveUserData(String uid) async{
//   var data = await FirebaseFirestore.instance.collection("Uploaders")
//       .where("uid" , isEqualTo: uid).get();
//   return data.docs[0].data();
// }
// checkOnline() async {
//   await retriveUserData(toUid).then((data) => {
//     setState((){
//       onlineState = data['online'];
//     })
//   }).catchError((onError){
//     setState((){
//       onlineState = "";
//     });
//   });
// }
}

