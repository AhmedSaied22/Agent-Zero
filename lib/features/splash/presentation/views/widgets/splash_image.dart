import 'package:elgassos/core/extensions/media_query_extensions.dart';
import 'package:elgassos/core/routes/routes_name.dart';
import 'package:elgassos/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashImage extends StatefulWidget {
  const SplashImage({
    super.key,
    required this.imagePath,
    this.imageHeight,
  });
  final String imagePath;
  final double? imageHeight;
  @override
  State<SplashImage> createState() => _SplashImageState();
}

class _SplashImageState extends State<SplashImage> {
  @override
  void initState() {
    super.initState();
    // تايمر للانتقال التلقائي إلى صفحة الهوم بعد 3 ثواني
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الصورة تملأ الشاشة بالكامل
        SizedBox(
          width: context.screenWidth,
          height: context.screenHeight,
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // النص العربي في أعلى الصورة
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  AppStrings.splashSubTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // زر للانتقال المباشر إلى صفحة الهوم
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RoutesName.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'ابدأ الآن',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
