import 'package:elgassos/features/roles/presentation/views/widgets/role_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/ui/app_colors.dart';
import '../../../../../core/routes/routes_name.dart';
import '../../manager/roles_cubit.dart';
import '../../manager/roles_state.dart';
class RolesRevealViewBody extends StatelessWidget {
  const RolesRevealViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RolesCubit, RolesState>(
      listener: (context, state) {
        if (state is RolesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AllRolesRevealed) {
          // الانتقال إلى صفحة المؤقت بعد الانتهاء من كشف جميع الأدوار
          Navigator.pushReplacementNamed(context, RoutesName.timer);
        }
      },
      builder: (context, state) {
        if (state is RolesLoading || state is RolesInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (state is RoleReady) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // العنوان
                  Text(
                    'أدوار اللاعبين',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  
                  // معلومات اللاعب الحالي
                  Text(
                    'اللاعب ${state.currentPlayerIndex + 1} من ${state.totalPlayers}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  
                  // بطاقة الدور
                  Expanded(
                    child: RoleCardWidget(
                      playerRole: state.currentRole,
                      isRevealed: state.isRevealed,
                      onTap: () {
                        if (!state.isRevealed) {
                          context.read<RolesCubit>().revealCurrentRole();
                        } else {
                          // إذا تم كشف الدور بالفعل، انتقل إلى اللاعب التالي عند النقر على البطاقة
                          context.read<RolesCubit>().nextPlayer();
                        }
                      },
                    ),
                  ),
                  
                  // إضافة مساحة في الأسفل
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        }

        // تم تغيير هذا الجزء لإصلاح مشكلة ظهور صفحة الخطأ خلف البوب أب
        if (state is AllRolesRevealed) {
          // عرض شاشة فارغة بدلاً من رسالة الخطأ عندما تكون الحالة هي AllRolesRevealed
          return const SizedBox.shrink();
        }

        return const Center(
          child: Text(
            'حدث خطأ غير متوقع',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}