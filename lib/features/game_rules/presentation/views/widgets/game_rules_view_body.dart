import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameRulesViewBody extends StatelessWidget {
  const GameRulesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر العودة
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // عنوان الصفحة
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.3), width: 1),
              ),
              child: Text(
                'قواعد اللعبة',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // قائمة القواعد
            Expanded(
              child: ListView(
                children: const [
                  RuleItem(
                    icon: '❗',
                    text: 'لا يجوز توجيه أكثر من سؤالين متتاليين لنفس اللاعب.',
                  ),
                  RuleItem(
                    icon: '🕵️‍♂️',
                    text: 'الجاسوس يحاول معرفة المكان من خلال الأسئلة والإجابات.',
                  ),
                  RuleItem(
                    icon: '🎭',
                    text: 'إذا شك أحد في لاعب، يمكنه اقتراح اسمه للتصويت.',
                  ),
                  RuleItem(
                    icon: '🗳️',
                    text: 'عند التصويت، إذا اتفق الأغلبية، يتم كشف اللاعب.',
                  ),
                  RuleItem(
                    icon: '🚫',
                    text: 'إذا كان بريئًا، تستمر اللعبة. إذا كان الجاسوس، تنتهي الجولة.',
                  ),
                  RuleItem(
                    icon: '💥',
                    text: 'يمكن للجاسوس قطع اللعبة في أي وقت ليحاول تخمين المكان.',
                  ),
                  RuleItem(
                    icon: '🏆',
                    text: 'إذا نجح الجاسوس في التخمين، يفوز! وإذا فشل، يخسر فورًا.',
                  ),
                  RuleItem(
                    icon: '🔄',
                    text: 'اسأل بذكاء، أجب بحذر، وراقب كل التفاصيل...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final String icon;
  final String text;

  const RuleItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h),
      child: Container(
        padding: EdgeInsets.all(12.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}