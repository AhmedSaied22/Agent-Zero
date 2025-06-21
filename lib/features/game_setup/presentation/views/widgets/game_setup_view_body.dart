import 'package:elgassos/core/extensions/font_styles_extensions.dart';
import 'package:elgassos/core/routes/routes_name.dart';
import 'package:elgassos/core/ui/app_colors.dart';
import 'package:elgassos/core/ui/widgets/custom_text_field.dart';
import 'package:elgassos/features/game_setup/presentation/manager/game_setup_cubit.dart';
import 'package:elgassos/features/game_setup/presentation/manager/game_setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameSetupViewBody extends StatelessWidget {
  const GameSetupViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameSetupCubit, GameSetupState>(
      listener: (context, state) {
        // عرض رسائل النجاح والفشل
        if (state is GameSetupSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ بيانات اللعبة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is GameSetupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GameSetupValidationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<GameSetupCubit>();
        
        // عرض مؤشر التحميل أثناء تحميل البيانات
        if (state is GameSetupLoading || state is GameSetupInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // عرض مؤشر التحميل أثناء حفظ البيانات
        if (state is GameSetupSaving) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري حفظ البيانات...'),
              ],
            ),
          );
        }
        
        // عرض واجهة إعداد اللعبة
        if (state is GameSetupLoaded) {
          return _buildGameSetupContent(context, state, cubit);
        }
        
        // التعامل مع حالات الخطأ
        if (state is GameSetupError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<GameSetupCubit>().loadSavedData(),
                  child: Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        
        // حالة افتراضية
        return const Center(child: Text('حدث خطأ غير متوقع'));
      },
    );
  }

  // بناء محتوى صفحة إعداد اللعبة
  Widget _buildGameSetupContent(BuildContext context, GameSetupLoaded state, GameSetupCubit cubit) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // زر العودة
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 20.h),
              // عنوان الصفحة
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.secondaryColor.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'إعداد اللعبة',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              
              // قسم اختيار عدد اللاعبين
              _buildPlayerCountSection(context, state, cubit),
              
              SizedBox(height: 20.h),
              
              // حقول إدخال أسماء اللاعبين
              _buildPlayerNamesSection(context, state, cubit),
              SizedBox(height: 20.h),
              
              // اختيار عدد الجواسيس
              _buildCounterOption(
                title: 'كام جاسوس',
                count: state.spyCount,
                onDecrement: () {
                  if (state.spyCount > 1) {
                    cubit.changeSpyCount(state.spyCount - 1);
                  }
                },
                onIncrement: () {
                  // التحقق من أن عدد الجواسيس لا يتجاوز عدد اللاعبين - 1
                  if (state.spyCount < 6 && state.spyCount < state.playerCount - 1) {
                    cubit.changeSpyCount(state.spyCount + 1);
                  }
                },
              ),
              SizedBox(height: 20.h),
              
              // اختيار مدة اللعبة
              _buildCounterOption(
                title: 'كام دقيقة',
                count: state.gameDuration,
                onDecrement: () {
                  if (state.gameDuration > 1) {
                    cubit.changeGameDuration(state.gameDuration - 1);
                  }
                },
                onIncrement: () {
                  cubit.changeGameDuration(state.gameDuration + 1);
                },
              ),
              SizedBox(height: 30.h),
              
              // زر بدء اللعبة
              Container(
                width: 80.w,
                height: 80.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    size: 40.sp,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    // الانتقال إلى صفحة اختيار نوع اللعبة
                    Navigator.pushNamed(context, RoutesName.gameCards);
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // بناء قسم اختيار عدد اللاعبين
  Widget _buildPlayerCountSection(BuildContext context, GameSetupLoaded state, GameSetupCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: AppColors.secondaryColor),
      ),
      child: Column(
        children: [
          Text(
            'احنا عددنا',
            style: TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: AppColors.secondaryColor),
                onPressed: () {
                  if (state.playerCount > 3) { // الحد الأدنى هو 3 لاعبين
                    cubit.changePlayerCount(state.playerCount - 1);
                  }
                },
              ),
              SizedBox(width: 20.w),
              Text(
                '${state.playerCount}',
                style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20.w),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.secondaryColor),
                onPressed: () {
                  if (state.playerCount < 9) { // الحد الأقصى هو 9 لاعبين
                    cubit.changePlayerCount(state.playerCount + 1);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بناء قسم إدخال أسماء اللاعبين
  Widget _buildPlayerNamesSection(BuildContext context, GameSetupLoaded state, GameSetupCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أسماء اللاعبين',
            style: TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ..._buildPlayerInputFields(context, state, cubit),
          SizedBox(height: 16.h),
          // تم إزالة زر الحفظ لأن الحفظ أصبح تلقائيًا
        ],
      ),
    );
  }

  // بناء حقول إدخال أسماء اللاعبين
  List<Widget> _buildPlayerInputFields(BuildContext context, GameSetupLoaded state, GameSetupCubit cubit) {
    List<Widget> fields = [];
    
    // التحقق من وجود أخطاء في التحقق من صحة الأسماء
    List<int> invalidIndices = [];
    if (context.read<GameSetupCubit>().state is GameSetupValidationError) {
      invalidIndices = (context.read<GameSetupCubit>().state as GameSetupValidationError).invalidIndices;
    }
    
    for (int i = 0; i < state.playerCount; i++) {
      fields.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CustomTextField(
            controller: cubit.playerNameControllers[i],
            hintText: 'أدخل اسم اللاعب ${i + 1}',
            borderRadius: 25.r,
            prefixIcon: Icon(
              Icons.person,
              color: invalidIndices.contains(i) ? Colors.red : AppColors.secondaryColor,
              size: 20.sp,
            ),
            // تغيير لون الحدود إذا كان هناك خطأ في هذا الحقل
            errorText: invalidIndices.contains(i) ? '' : null,
          ),
        ),
      );
    }
    return fields;
  }

  // بناء خيار العداد
  Widget _buildCounterOption({
    required String title,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: AppColors.secondaryColor),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, color: AppColors.secondaryColor),
                onPressed: onDecrement,
              ),
              SizedBox(width: 20.w),
              Text(
                '$count',
                style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20.w),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.secondaryColor),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}