import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/ui/app_colors.dart';
import '../../manager/timer_cubit.dart';
import '../../manager/timer_state.dart';

class TimerViewBody extends StatelessWidget {
  const TimerViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listener: (context, state) {
        if (state is TimerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is TimerFinished) {
          _showTimerFinishedDialog(context, state);
        }
      },
      builder: (context, state) {
        if (state is TimerInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (state is TimerReady) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // العنوان
                  Text(
                    'الوقت المتبقي',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  
                  // المؤقت
                  _buildTimerDisplay(state),
                  SizedBox(height: 40.h),
                  
                  // أزرار التحكم
                  _buildControlButtons(context, state),
                  SizedBox(height: 40.h),
                  
                  // قسم كشف الجاسوس
                  _buildSpyRevealSection(context, state),
                ],
              ),
            ),
          );
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

  // بناء عرض المؤقت
  Widget _buildTimerDisplay(TimerReady state) {
    final minutes = (state.remainingSeconds / 60).floor();
    final seconds = state.remainingSeconds % 60;
    
    return Container(
      width: 200.w,
      height: 200.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: state.isRunning ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  // بناء أزرار التحكم
  Widget _buildControlButtons(BuildContext context, TimerReady state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر البدء/الإيقاف
        ElevatedButton(
          onPressed: () {
            if (state.isRunning) {
              context.read<TimerCubit>().stopTimer();
            } else {
              context.read<TimerCubit>().startTimer();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: state.isRunning ? Colors.red : AppColors.primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
              vertical: 12.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            state.isRunning ? 'إيقاف' : 'بدء',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 20.w),
        
        // زر إعادة الضبط
        ElevatedButton(
          onPressed: () => context.read<TimerCubit>().resetTimer(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
              vertical: 12.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            'إعادة ضبط',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // بناء قسم كشف الجاسوس
  Widget _buildSpyRevealSection(BuildContext context, TimerReady state) {
    // التحقق مما إذا كان قد مر نصف الوقت
    bool canRevealSpy = state.remainingSeconds <= (state.duration / 2);
    
    return Column(
      children: [
        Text(
          'من هو الجاسوس؟',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        
        // زر كشف الجاسوس - يظهر فقط بعد مرور نصف الوقت
        if (canRevealSpy)
          ElevatedButton(
            onPressed: () => context.read<TimerCubit>().revealSpy(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'كشف الجاسوس',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        else
          // رسالة عندما لا يمكن كشف الجاسوس بعد
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'يمكن كشف الجاسوس بعد مرور نصف الوقت',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        // عرض هوية الجاسوس إذا تم الكشف عنها
        if (state.spyRevealed && state.spies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    'الجاسوس هو:',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...state.spies.map((spy) => Text(
                    spy.playerName,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // عرض حوار انتهاء المؤقت
  void _showTimerFinishedDialog(BuildContext context, TimerFinished state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryColor,
        title: const Text(
          'انتهى الوقت!',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'هل اكتشفتم من هو الجاسوس؟',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              'الجاسوس هو:',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            ...state.spies.map((spy) => Text(
              spy.playerName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TimerCubit>().resetTimer();
            },
            child: const Text(
              'حسناً',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}