import 'package:elgassos/features/game/data/models/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/routes/routes_name.dart';
import '../manager/roles_cubit.dart';
import 'widgets/roles_reveal_view_body.dart';

class RolesRevealView extends StatelessWidget {
  final String selectedItem;
  final CardType cardType;
  
  const RolesRevealView({
    super.key,
    required this.selectedItem,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolesCubit()..loadPlayerRoles(selectedItem, cardType: cardType),
      child: WillPopScope(
        // منع الرجوع بزر الرجوع الافتراضي لتجنب الكراش
        onWillPop: () async {
          // التنقل إلى الصفحة الرئيسية بدلاً من الرجوع
          Navigator.pushNamedAndRemoveUntil(
            context, 
            RoutesName.home, 
            (route) => false
          );
          return false; // منع السلوك الافتراضي للرجوع
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // التنقل إلى الصفحة الرئيسية
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  RoutesName.home, 
                  (route) => false
                );
              },
            ),
          ),
          body: const RolesRevealViewBody(),
        ),
      ),
    );
  }
}