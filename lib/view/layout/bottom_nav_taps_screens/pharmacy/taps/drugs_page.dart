import 'package:ecard/utilities/app_util.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/components.dart';
class DrugsPage extends StatefulWidget {
  const DrugsPage({Key? key}) : super(key: key);

  @override
  _DrugsPageState createState() => _DrugsPageState();
}

class _DrugsPageState extends State<DrugsPage> {
  List<int> qty = [1,1,1,1,1,1,1,1];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(5),
      crossAxisSpacing: 0,
      childAspectRatio: (150/195),
      children: List.generate(8, (index) {
        return PharmacyCard(qty: qty[index],onIncrement: (){
          setState(() {
            qty[index]++;
          });
        },onDecrment: (){
          setState(() {
            qty[index]--;
          });
        },
        );
      }),
    );
  }
}
