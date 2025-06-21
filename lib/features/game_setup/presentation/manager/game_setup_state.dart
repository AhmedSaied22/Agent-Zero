import 'package:equatable/equatable.dart';

abstract class GameSetupState extends Equatable {
  const GameSetupState();

  @override
  List<Object?> get props => [];
}

// حالة التحميل الأولي
class GameSetupInitial extends GameSetupState {}

// حالة تحميل البيانات
class GameSetupLoading extends GameSetupState {}

// حالة نجاح تحميل البيانات
class GameSetupLoaded extends GameSetupState {
  final List<String> playerNames;
  final int playerCount;
  final int spyCount;
  final int gameDuration;

  const GameSetupLoaded({
    this.playerNames = const [],
    this.playerCount = 3,
    this.spyCount = 1,
    this.gameDuration = 5,
  });

  GameSetupLoaded copyWith({
    List<String>? playerNames,
    int? playerCount,
    int? spyCount,
    int? gameDuration,
  }) {
    return GameSetupLoaded(
      playerNames: playerNames ?? this.playerNames,
      playerCount: playerCount ?? this.playerCount,
      spyCount: spyCount ?? this.spyCount,
      gameDuration: gameDuration ?? this.gameDuration,
    );
  }

  @override
  List<Object?> get props => [playerNames, playerCount, spyCount, gameDuration];
}

// حالة حفظ البيانات
class GameSetupSaving extends GameSetupState {}

// حالة نجاح حفظ البيانات
class GameSetupSaved extends GameSetupState {}

// حالة فشل (عام)
class GameSetupError extends GameSetupState {
  final String message;

  const GameSetupError(this.message);

  @override
  List<Object?> get props => [message];
}

// حالة خطأ في التحقق من صحة الأسماء
class GameSetupValidationError extends GameSetupState {
  final String message;
  final List<int> invalidIndices; // مؤشرات الحقول التي بها أخطاء

  const GameSetupValidationError({
    required this.message,
    required this.invalidIndices,
  });

  @override
  List<Object?> get props => [message, invalidIndices];
}