import 'package:ecard/shared/components.dart';
import 'package:flutter/material.dart';
class MyConsultationScreen extends StatefulWidget {
  final List consultation;
  const MyConsultationScreen({Key? key,required this.consultation}) : super(key: key);

  @override
  _MyConsultationScreenState createState() => _MyConsultationScreenState();
}

class _MyConsultationScreenState extends State<MyConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "My Consultation"),
      body: widget.consultation.isNotEmpty?ListView(
        children: List.generate(widget.consultation.length, (index) {
          return Column(
            children: [
              ListTile(
                title: CustomText(text: widget.consultation[index]['doc_email']),
                subtitle: CustomText(text: widget.consultation[index]['consult']),
              ),
              const Divider()
            ],
          );
        }),
      ):const Center(child: CustomText(text: "No Consultation Yet")),
    );
  }
}
