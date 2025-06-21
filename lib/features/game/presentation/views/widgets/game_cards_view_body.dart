import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/ui/app_colors.dart';
import '../../../../../core/routes/routes_name.dart';
import '../../manager/game_cubit.dart';
import '../../manager/game_state.dart';
import 'game_card_widget.dart';

class GameCardsViewBody extends StatelessWidget {
  const GameCardsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GameCardSelected) {
          // عند اختيار نوع اللعبة، انتقل إلى صفحة كشف الأدوار
          Navigator.pushNamed(
            context, 
            RoutesName.rolesReveal,
            arguments: {
              'selectedItem': state.selectedItem,
              'cardType': state.cardType,
            },
          );
        }
      },
      builder: (context, state) {
        if (state is GameLoading || state is GameInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (state is GameCardsLoaded) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'اختر نوع اللعبة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 48.w), // للتوازن
                    ],
                  ),
                  SizedBox(height: 40.h),
                  
                  // Cards Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.w,
                        mainAxisSpacing: 20.h,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        return GameCardWidget(
                          card: card,
                          onTap: () => context.read<GameCubit>().selectCard(card),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GameError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => context.read<GameCubit>().loadGameCards(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
}