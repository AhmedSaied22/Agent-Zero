import 'package:elgassos/core/extensions/font_styles_extensions.dart';
import 'package:elgassos/core/extensions/media_query_extensions.dart';
import 'package:elgassos/core/images/app_images.dart';
import 'package:elgassos/core/routes/routes_name.dart';
import 'package:elgassos/core/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام امتدادات MediaQuery للحصول على أبعاد الشاشة
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;
    final isTablet = screenWidth > 600; // تحديد ما إذا كان الجهاز تابلت
    
    return Stack(
      children: [
        // Background Image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            // استخدام امتدادات MediaQuery بدلاً من MediaQuery.of مباشرة
            height: context.heightPercent(0.6),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.introHomeImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Buttons
        Positioned(
          // استخدام امتدادات MediaQuery وتعديل الموضع بناءً على نوع الجهاز
          top: context.heightPercent(0.6) + (isTablet ? 40.h : 20.h),
          left: 0,
          right: 0,
          child: Padding(
            // تعديل التباعد الأفقي بناءً على نوع الجهاز
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40.w : 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isTablet ? 24.h : 16.h),
                HomeButton(title: 'تعالى أفهمك!', onPressed: () {
                  Navigator.pushNamed(context, RoutesName.gameRules);
                },),
                SizedBox(height: isTablet ? 24.h : 16.h),
               HomeButton(title: 'بدء اللعبة', onPressed: (){
                 Navigator.pushNamed(context, RoutesName.gameSetup);
               },),
                SizedBox(height: isTablet ? 24.h : 16.h),
               HomeButton(title: 'الإعدادات'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key, this.onPressed, required this.title,
  });

  final void Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الجهاز تابلت لتعديل حجم الزر
    final isTablet = context.screenWidth > 600;
    
    return SizedBox(
      // تعديل عرض الزر بناءً على نوع الجهاز
      width: context.widthPercent(isTablet ? 0.4 : 0.5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // تعديل التباعد بناءً على نوع الجهاز
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 15.h : 10.h, 
            horizontal: isTablet ? 20.w : 12.w
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            // إضافة حدود برتقالية خفيفة
            side: BorderSide(
              color: Colors.orange.shade200,
              width: 1.5,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title, 
          style: context.bodyLarge?.copyWith(
            fontSize: isTablet ? 20.sp : 16.sp,
          ),
        ),
      ),
    );
  }
}
