import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/ui/app_colors.dart';
import '../../../data/models/player_role.dart';
import '../../manager/roles_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleCardWidget extends StatefulWidget {
  final PlayerRole playerRole;
  final bool isRevealed;
  final VoidCallback onTap;

  const RoleCardWidget({
    super.key,
    required this.playerRole,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  State<RoleCardWidget> createState() => _RoleCardWidgetState();
}

class _RoleCardWidgetState extends State<RoleCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addListener(() {
      if (_animation.value > 0.5 && _showFront) {
        setState(() {
          _showFront = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(RoleCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed != oldWidget.isRevealed && widget.isRevealed) {
      _controller.forward();
    }
    if (!widget.isRevealed && oldWidget.isRevealed) {
      _controller.reset();
      setState(() {
        _showFront = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _showFront ? _buildFrontCard() : _buildBackCard(),
          );
        },
      ),
    );
  }

  // بناء الوجه الأمامي للبطاقة (اسم اللاعب)
  Widget _buildFrontCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // اسم اللاعب
          Text(
            widget.playerRole.playerName,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          
          // رسالة للاعب
          Text(
            'اضغط على الكارد لمعرفة دورك',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          
          // أيقونة للإشارة إلى الضغط
          SizedBox(height: 20.h),
          Icon(
            Icons.touch_app,
            size: 50.sp,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  // بناء الوجه الخلفي للبطاقة (دور اللاعب)
  Widget _buildBackCard() {
    final rolesCubit = context.read<RolesCubit>();
    final isSpy = widget.playerRole.isSpy;
    final assignedItem = widget.playerRole.assignedItem;
    
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSpy ? Colors.red.shade900 : AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اسم اللاعب
            Text(
              widget.playerRole.playerName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            
            // دور اللاعب
            if (isSpy) ...[  // إذا كان جاسوس
              Icon(
                Icons.remove_red_eye,
                size: 60.sp,
                color: Colors.white,
              ),
              SizedBox(height: 20.h),
              Text(
                'أنت جاسوس',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              // إضافة عرض الفئة للجاسوس
              Text(
                'الفئة:',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                rolesCubit.getCategoryName(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                rolesCubit.getSpyMessage(),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[  // إذا كان لاعب عادي
              Text(
                'طيب',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                'الكلمة السرية:',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                assignedItem ?? 'غير معروف',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Column(
                children: [
                  Text(
                    rolesCubit.getNormalPlayerMessage(assignedItem ?? 'غير معروف'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}