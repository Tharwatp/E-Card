
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utilities/app_ui.dart';
import '../utilities/app_util.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double? radius;
  final List<Color>? gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({Key? key,
    @required this.radius,
    @required this.gradientColors,
    this.strokeWidth = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius!),
      painter: GradientCircularProgressPainter(
        radius: radius!,
        gradientColors: gradientColors!,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    @required this.radius,
    @required this.gradientColors,
    @required this.strokeWidth,
  });
  final double? radius;
  final List<Color>? gradientColors;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius!);
    double offset = strokeWidth! / 2;
    Rect rect = Offset(offset, offset) &
    Size(size.width - strokeWidth!, size.height - strokeWidth!);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;
    paint.shader =
        SweepGradient(colors: gradientColors!, startAngle: 0.0, endAngle: 2 * pi)
            .createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


AppBar customAppBar ({required title,Widget? leading,List<Widget>? actions,int elevation = 0,Widget? bottomChild,Color? backgroundColor,bottomChildHeight,leadingWidth,bool centerTitle = true}){
  return AppBar(
    backgroundColor: backgroundColor??AppUI.mainColor,
    elevation: double.parse(elevation.toString()),
    title: title is Widget? title : CustomText(text: title, fontSize: 18.0,color: AppUI.whiteColor,fontWeight: FontWeight.w600,),
    centerTitle: centerTitle,
    leading: leading,
    leadingWidth: leadingWidth??110,
    actions: actions,
    bottom: bottomChild==null?null:PreferredSize(preferredSize: Size.fromHeight(bottomChildHeight??120),child: bottomChild,),
  );
}


class CustomText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  const CustomText({Key? key,@required this.text,this.fontSize = 14,this.textAlign = TextAlign.left,this.fontWeight = FontWeight.w400,this.color,this.textDecoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text!,textAlign: textAlign,style: TextStyle(color: color??AppUI.mainColor,fontSize: fontSize,fontWeight: fontWeight,decoration: textDecoration));
  }
}



class CustomButton extends StatelessWidget {
  final Color? color;
  final int radius;
  final String text;
  final Color? textColor,borderColor;
  final Function()? onPressed;
  final double? width,height;
  final Widget? child;
  const CustomButton({Key? key,required this.text,this.onPressed,this.color,this.borderColor,this.radius = 15,this.textColor = Colors.white,this.width,this.child,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: height??AppUtil.responsiveHeight(context)*0.015,horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(double.parse("$radius")),
            color: color??AppUI.mainColor,
            border: borderColor==null?null:Border.all(color: borderColor!)
          ),
          alignment: width!=null?Alignment.center:null,
          child: child??CustomText(text: text, fontSize: 16.0,fontWeight: FontWeight.w600,color: textColor,)),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height,width;
  final Color? color;
  final double? elevation,horizontal,vertical;
  final Color? border;
  final Function()? onTap;
  const CustomCard({Key? key,required this.child,this.height,this.width,this.color,this.elevation,this.border,this.onTap,this.horizontal,this.vertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        elevation: elevation??7,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontal??15,vertical: vertical??7),
          width: width??double.infinity,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            border: border!=null?Border.all(color: border!):null,
            color: color??AppUI.whiteColor,
          ),
          child: child,
        ),
      ),
    );
  }
}



class CustomInput extends StatelessWidget {
  final String? hint,lable;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function()? onTap;
  final Function(String v)? onChange;
  final bool obscureText,readOnly,autofocus,validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines , maxLength;
  final double radius;
  final TextAlign? textAlign;
  final Color? borderColor,fillColor;
  const CustomInput({Key? key,required this.controller,this.hint,this.lable,required this.textInputType,this.obscureText = false,this.prefixIcon,this.suffixIcon,this.onTap,this.onChange,this.maxLines,this.textAlign,this.readOnly = false,this.autofocus = false,this.radius = 10.0,this.maxLength,this.validation=true,this.borderColor,this.fillColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      // maxLength: maxLength,
      textAlign: textAlign!=null?textAlign!:TextAlign.left,
      onChanged: onChange,
      validator: validation?(v){
        if(v!.isEmpty) {
          return "This field required";
        }
        return null;
      }:null,
      autofocus: autofocus,
      maxLines: maxLines??1,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: suffixIcon,
        ),
        labelText: lable,
        labelStyle: TextStyle(color: AppUI.mainColor),
        filled: true,
        fillColor: fillColor??AppUI.whiteColor,
        suffixIconConstraints: const BoxConstraints(
            minWidth: 63
        ),
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: AppUtil.responsiveHeight(context)*0.0153),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius),bottomLeft: Radius.circular(radius),bottomRight: Radius.circular(radius),topRight: Radius.circular(radius) ),
            borderSide: BorderSide(color: borderColor??AppUI.mainColor,width: 0.5)
        ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius),bottomLeft: Radius.circular(radius),bottomRight: Radius.circular(radius),topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor??AppUI.mainColor,width: 0.5)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius),bottomLeft: Radius.circular(radius),bottomRight: Radius.circular(radius),topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor??AppUI.iconColor,width: 0.5)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius),bottomLeft: Radius.circular(radius),bottomRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor??AppUI.mainColor,width: 0.5)
        ),

      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Function()? onTap;
  final String? offer;
  final dynamic doctorData;
  const DoctorCard({Key? key,this.onTap,this.offer, this.doctorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap??(){
        // AppUtil.mainNavigator(context, const DoctorDetailsScreen());
      },
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: doctorData!.profilePhoto!,
                      placeholder: (context, url) => Image.asset("${AppUI.imgPath}profile.png",height: 100,),
                      errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}profile.png",height: 100,),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  if(doctorData!.isOffer==1)
                    CustomButton(text: doctorData!.offerTitle!,borderColor: AppUI.blackColor,width: AppUtil.responsiveWidth(context)*0.3,height: 4,color: AppUI.whiteColor,textColor: AppUI.blackColor,)
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10,),
                  CustomText(text: doctorData!.clinicName== ""? "عيادة الأمل للعلاج الطبيعي":doctorData!.clinicName,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
                  CustomText(text: doctorData!.name,fontWeight: FontWeight.bold,color: AppUI.blackColor),
                  CustomText(text: doctorData!.specialties!.isEmpty?"علاج طبيعي لحالات الأعصاب":doctorData!.specialties![0].title,color: AppUI.iconColor,),
                  Row(
                    children: [
                      CustomText(text: "(${doctorData!.clinicReviewsCount.toString()})",color: AppUI.iconColor,),
                      const SizedBox(width: 15,),
                      // RatingBar(
                      //   initialRating: double.parse(doctorData!.rate!),
                      //   minRating: 1,
                      //   ignoreGestures: true,
                      //   direction: Axis.horizontal,
                      //   allowHalfRating: true,
                      //   itemCount: 5,
                      //   itemSize: 25,
                      //   unratedColor: AppUI.iconColor,
                      //   onRatingUpdate: (rating) {
                      //
                      //   }, ratingWidget: RatingWidget(
                      //     empty: const Icon(Icons.star_border,size: 30,color: Colors.amber,),
                      //   half: const Directionality(textDirection: ui.TextDirection.ltr,
                      //   child: Icon(Icons.star_half,size: 30,color: Colors.amber,)),
                      //   full: const Icon(Icons.star,size: 30,color: Colors.amber,)
                      // ),
                      // ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class DoctorCardSimmer extends StatelessWidget {

  const DoctorCardSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset("${AppUI.imgPath}profile.png",height: 100,),
              ),
              const SizedBox(height: 10,),
              // if(offer==null)
              CustomButton(text: "          ",borderColor: AppUI.blackColor,width: AppUtil.responsiveWidth(context)*0.3,height: 4,color: AppUI.whiteColor,textColor: AppUI.blackColor,)
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(width: AppUtil.responsiveWidth(context)*0.3,height: 15,color: AppUI.shimmerColor,),
              const SizedBox(height: 20,),
              Container(width: AppUtil.responsiveWidth(context)*0.35,height: 15,color: AppUI.shimmerColor,),
              const SizedBox(height: 20,),
              Container(width: AppUtil.responsiveWidth(context)*0.3,height: 15,color: AppUI.shimmerColor,),
              const SizedBox(height: 20,),
              Row(
                children: [
                  CustomText(text: "(100)",color: AppUI.iconColor,),
                  const SizedBox(width: 15,),
                  // RatingBar(
                  //   initialRating: 3.5,
                  //   minRating: 1,
                  //   ignoreGestures: true,
                  //   direction: Axis.horizontal,
                  //   allowHalfRating: true,
                  //   itemCount: 5,
                  //   itemSize: 25,
                  //   unratedColor: AppUI.iconColor,
                  //   onRatingUpdate: (rating) {
                  //
                  //   }, ratingWidget: RatingWidget(
                  //     empty: const Icon(Icons.star_border,size: 30,color: Colors.amber,),
                  //   half: const Directionality(textDirection: ui.TextDirection.ltr,
                  //   child: Icon(Icons.star_half,size: 30,color: Colors.amber,)),
                  //   full: const Icon(Icons.star,size: 30,color: Colors.amber,)
                  // ),
                  // ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/lottie/loading.json', height: 90, fit: BoxFit.fill),
    );
  }
}

// Show dialog
dialog(context,title,List<Widget> dialogBody,{barrierDismissible=true})async{
  return await showDialog(context: context,barrierDismissible: barrierDismissible, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      title: CustomText(text: title,textAlign: TextAlign.center,fontWeight: FontWeight.bold,),
      content: SingleChildScrollView(
        child: ListBody(
          children: dialogBody,
        ),
      ),
    );
  });
}

class PharmacyCard extends StatelessWidget {
  final qty,onDecrment,onIncrement;
  const PharmacyCard({Key? key,required this.qty,required this.onIncrement,required this.onDecrment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("${AppUI.imgPath}drug.png",height: 80,width: double.infinity,),
          const Divider(),
          const CustomText(text: "53LE"),
          CustomText(text: "Neurovit",color: AppUI.blackColor,fontWeight: FontWeight.w700,),
          CustomText(text: "68 in stock",color: AppUI.iconColor,),
          Row(
            children: [
              InkWell(
                onTap: onDecrment,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppUI.mainColor.withOpacity(0.2),
                  child: CustomText(text: "-",color: AppUI.blackColor,),
                ),
              ),
              const SizedBox(width: 5,),
              CustomText(text: "$qty"),
              const SizedBox(width: 5,),
              InkWell(
                onTap: onIncrement,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppUI.mainColor.withOpacity(0.2),
                  child: CustomText(text: "+",color: AppUI.blackColor,),
                ),
              ),
              const Spacer(),
              const CustomButton(text: "Buy",radius: 5,height: 3,width: 50,)
            ],
          )
        ],
      ),
    );
  }
}
