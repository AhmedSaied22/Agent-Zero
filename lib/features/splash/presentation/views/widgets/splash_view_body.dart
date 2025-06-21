import 'package:elgassos/core/images/app_images.dart';
import 'package:elgassos/features/splash/presentation/views/widgets/splash_image.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashImage(
      imagePath: Assets.splashImage,
    );
  }
}
