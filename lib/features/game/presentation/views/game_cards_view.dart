import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/game_cubit.dart';
import 'widgets/game_cards_view_body.dart';

class GameCardsView extends StatelessWidget {
  const GameCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit()..loadGameCards(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: const GameCardsViewBody(),
      ),
    );
  }
}