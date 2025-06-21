import 'package:equatable/equatable.dart';
import '../../data/models/player_role.dart';

abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

// حالة التحميل الأولي
class RolesInitial extends RolesState {}

// حالة تحميل الأدوار
class RolesLoading extends RolesState {}

// حالة جاهزية عرض دور لاعب
class RoleReady extends RolesState {
  final PlayerRole currentRole;
  final int currentPlayerIndex;
  final int totalPlayers;
  final bool isRevealed;

  const RoleReady({
    required this.currentRole,
    required this.currentPlayerIndex,
    required this.totalPlayers,
    required this.isRevealed,
  });

  @override
  List<Object?> get props => [currentRole, currentPlayerIndex, totalPlayers, isRevealed];
}

// حالة الانتهاء من كشف جميع الأدوار
class AllRolesRevealed extends RolesState {}

// حالة خطأ
class RolesError extends RolesState {
  final String message;

  const RolesError(this.message);

  @override
  List<Object?> get props => [message];
}