// import 'dart:ui';

// import 'package:flutter/material.dart';

// class ScaffoldBackground extends StatelessWidget {
//   const ScaffoldBackground({super.key, required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: Stack(
//         children: [
//           const BlurredImage(),
//           _buildGlowEffect(
//             alignment: const Alignment(-0.8, -0.8),
//             color: AppColors.primaryColor.withValues(alpha: 0.22),
//           ),
//           _buildGlowEffect(
//             alignment: const Alignment(1.2, 0.8),
//             color: AppColors.primaryColor.withValues(alpha: 0.2),
//           ),
//           _buildGlowEffect(
//             alignment: const Alignment(0.5, 0.8),
//             color: AppColors.secondaryColor.withValues(alpha: 0.08),
//           ),
//           _buildGlowEffect(
//             alignment: const Alignment(1.2, 0.5),
//             color: const Color.fromARGB(255, 201, 110, 173)
//                 .withValues(alpha: 0.15),
//           ),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _buildGlowEffect({
//     required Alignment alignment,
//     required Color color,
//   }) {
//     return Positioned.fill(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: RadialGradient(
//             center: alignment,
//             radius: 0.8,
//             colors: [color, Colors.transparent],
//             stops: const [0.1, 1.0],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BlurredImage extends StatelessWidget {
//   const BlurredImage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ImageFiltered(
//         imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
//         child: Opacity(
//           opacity: 0.2,
//           child: Image.asset(
//             Assets.texture,
//             fit: BoxFit.cover,
//             height: context.screenHeight,
//           ),
//         ),
//       ),
//     );
//   }
// }
