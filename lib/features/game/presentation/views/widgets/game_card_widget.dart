import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/game_card.dart';
import '../../../../../core/ui/app_colors.dart';

class GameCardWidget extends StatelessWidget {
  final GameCard card;
  final VoidCallback onTap;

  const GameCardWidget({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getCardColors(card.type),
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(
                      _getCardIcon(card.type),
                      size: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Title
                  Text(
                    card.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // Items count
                  Text(
                    '${card.items.length} عنصر',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tap effect overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: onTap,
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCardColors(CardType type) {
    switch (type) {
      case CardType.jobs:
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
      case CardType.countries:
        return [const Color(0xFFf093fb), const Color(0xFFf5576c)];
      case CardType.famousPlaces:
        return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
      case CardType.publicPlaces:
        return [const Color(0xFF43e97b), const Color(0xFF38f9d7)];
      case CardType.foods:
        return [const Color(0xFFfa709a), const Color(0xFFfee140)];
      case CardType.footballPlayers:
        return [const Color(0xFFf09578), const Color(0xFFfe7802)];
    }
  }

  IconData _getCardIcon(CardType type) {
    switch (type) {
      case CardType.jobs:
        return Icons.work;
      case CardType.countries:
        return Icons.public;
      case CardType.famousPlaces:
        return Icons.location_city;
      case CardType.publicPlaces:
        return Icons.place;
      case CardType.foods:
        return Icons.restaurant;
      case CardType.footballPlayers:
        return Icons.sports;
    }
  }
}