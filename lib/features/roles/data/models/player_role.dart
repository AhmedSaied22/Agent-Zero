import 'package:equatable/equatable.dart';

class PlayerRole extends Equatable {
  final String playerName;
  final bool isSpy;
  final String? assignedItem; // العنصر المخصص للاعب (مكان، طعام، إلخ)
  final bool isRevealed; // هل تم كشف الدور

  const PlayerRole({
    required this.playerName,
    required this.isSpy,
    this.assignedItem,
    this.isRevealed = false,
  });

  PlayerRole copyWith({
    String? playerName,
    bool? isSpy,
    String? assignedItem,
    bool? isRevealed,
  }) {
    return PlayerRole(
      playerName: playerName ?? this.playerName,
      isSpy: isSpy ?? this.isSpy,
      assignedItem: assignedItem ?? this.assignedItem,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [playerName, isSpy, assignedItem, isRevealed];
}