import 'package:ecard/view/layout/bottom_nav_taps_screens/consulting/consulting_screen.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/pharmacy/pharmacy_screen.dart';
import 'package:ecard/view/layout/bottom_nav_taps_screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/layout/bottom_nav_cubit.dart';
import '../../../bloc/layout/bottom_nav_states.dart';
import '../bottom_nav_taps_screens/home/doctor_home_screen.dart';
import '../bottom_nav_taps_screens/home/home_screen.dart';
import 'bottom_nav_widget.dart';

class BottomNavTabsScreen extends StatefulWidget {
  const BottomNavTabsScreen({Key? key}) : super(key: key);

  @override
  _BottomNavTabsScreenState createState() => _BottomNavTabsScreenState();
}

class _BottomNavTabsScreenState extends State<BottomNavTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: context.watch<BottomNavCubit>().currentIndex==0?context.watch<BottomNavCubit>().type == "doctor"?const DoctorHomeScreen():const HomeScreen():context.watch<BottomNavCubit>().currentIndex==2?const PharmacyScreen():context.watch<BottomNavCubit>().currentIndex==1?const ConsultingScreen():const ProfileScreen(),
      bottomNavigationBar: BlocConsumer<BottomNavCubit,BottomNavState>(
        listener: (context,index){},
        builder: (context, state,) {
          var bottomNavProvider = BottomNavCubit.get(context);
          return BottomNavBar(currentIndex: bottomNavProvider.currentIndex,
            onTap0: (){
            bottomNavProvider.setCurrentIndex(0);
          },
            onTap1: (){
              bottomNavProvider.setCurrentIndex(1);
            },
            onTap2: (){
              bottomNavProvider.setCurrentIndex(2);
            },

            onTap3: (){
              bottomNavProvider.setCurrentIndex(3);
            }, type: context.read<BottomNavCubit>().type!,

          );
        }
      ),
    );
  }
}
