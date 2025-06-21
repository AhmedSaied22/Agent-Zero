import 'package:elgassos/core/routes/routes_gen.dart';
import 'package:elgassos/core/routes/routes_name.dart';
import 'package:elgassos/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        // تحديث إعدادات ScreenUtilInit لتحسين الاستجابة للأجهزة المختلفة
        designSize: const Size(390, 844), // حجم تصميم iPhone 13 كمرجع
        minTextAdapt: true, // تكييف حجم النص تلقائيًا
        splitScreenMode: true, // دعم وضع تقسيم الشاشة
        useInheritedMediaQuery: true, // استخدام MediaQuery المُورث
        // إضافة إعدادات للتكيف مع الأجهزة المختلفة
        builder: (_, child) {
          // تعيين اتجاه النص من اليمين إلى اليسار بشكل افتراضي
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              title: 'Agent Zero - العميل صفر',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              initialRoute: RoutesName.splash,
              navigatorKey: navigatorKey,
              onGenerateRoute: RouteGenerator.generateRoute,
              // إعدادات اللغة العربية
              locale: const Locale('ar', 'EG'),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ar', 'EG'), // Arabic
              ],
            ),
          );
        });
  }
}
