import 'package:flutter/material.dart';
import 'package:elgassos/features/game_rules/presentation/views/widgets/game_rules_view_body.dart';

class GameRulesView extends StatelessWidget {
  const GameRulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GameRulesViewBody(),
    );
  }
}