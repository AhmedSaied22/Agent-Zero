import 'package:elgassos/features/game_setup/presentation/manager/game_setup_cubit.dart';
import 'package:elgassos/features/game_setup/presentation/views/widgets/game_setup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSetupView extends StatelessWidget {
  const GameSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameSetupCubit(),
      child: const Scaffold(
        body: GameSetupViewBody(),
      ),
    );
  }
}