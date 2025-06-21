import 'package:equatable/equatable.dart';
import '../../data/models/player_role.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

// حالة التحميل الأولي
class TimerInitial extends TimerState {}

// حالة جاهزية المؤقت
class TimerReady extends TimerState {
  final int duration;
  final bool isRunning;
  final int remainingSeconds;
  final bool spyRevealed;
  final List<PlayerRole> spies;

  const TimerReady({
    required this.duration,
    required this.isRunning,
    required this.remainingSeconds,
    required this.spyRevealed,
    required this.spies,
  });

  @override
  List<Object?> get props => [duration, isRunning, remainingSeconds, spyRevealed, spies];
}

// حالة انتهاء المؤقت
class TimerFinished extends TimerState {
  final List<PlayerRole> spies;

  const TimerFinished({required this.spies});

  @override
  List<Object?> get props => [spies];
}

// حالة خطأ
class TimerError extends TimerState {
  final String message;

  const TimerError(this.message);

  @override
  List<Object?> get props => [message];
}