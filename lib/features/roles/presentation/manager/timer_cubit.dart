import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/game_data_storage.dart';
import '../../data/models/player_role.dart';
import '../../data/repo/roles_repository.dart';
import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitial()) {
    _loadGameData();
  }
  
  Timer? _timer;
  int _duration = 0;
  List<PlayerRole> _spies = [];
  
  // تحميل بيانات اللعبة
  Future<void> _loadGameData() async {
    try {
      // الحصول على مدة اللعبة من التخزين
      _duration = await GameDataStorage.getGameDuration();
      
      // تحويل الدقائق إلى ثوانٍ
      _duration = _duration * 60;
      
      // الحصول على أدوار اللاعبين وتحديد الجواسيس
      final playerRoles = await RolesRepository.getPlayerRoles();
      _spies = playerRoles.where((role) => role.isSpy).toList();
      
      emit(TimerReady(
        duration: _duration,
        isRunning: false,
        remainingSeconds: _duration,
        spyRevealed: false,
        spies: _spies,
      ));
    } catch (e) {
      emit(TimerError('حدث خطأ أثناء تحميل بيانات اللعبة: $e'));
    }
  }
  
  // بدء المؤقت
  void startTimer() {
    if (state is TimerReady) {
      final currentState = state as TimerReady;
      
      if (!currentState.isRunning) {
        emit(TimerReady(
          duration: _duration,
          isRunning: true,
          remainingSeconds: currentState.remainingSeconds,
          spyRevealed: currentState.spyRevealed,
          spies: _spies,
        ));
        
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _tickTimer();
        });
      }
    }
  }
  
  // إيقاف المؤقت
  void stopTimer() {
    if (state is TimerReady) {
      final currentState = state as TimerReady;
      
      if (currentState.isRunning) {
        _timer?.cancel();
        _timer = null;
        
        emit(TimerReady(
          duration: _duration,
          isRunning: false,
          remainingSeconds: currentState.remainingSeconds,
          spyRevealed: currentState.spyRevealed,
          spies: _spies,
        ));
      }
    }
  }
  
  // تحديث المؤقت كل ثانية
  void _tickTimer() {
    if (state is TimerReady) {
      final currentState = state as TimerReady;
      
      if (currentState.remainingSeconds > 0) {
        emit(TimerReady(
          duration: _duration,
          isRunning: true,
          remainingSeconds: currentState.remainingSeconds - 1,
          spyRevealed: currentState.spyRevealed,
          spies: _spies,
        ));
      } else {
        _timer?.cancel();
        _timer = null;
        
        emit(TimerReady(
          duration: _duration,
          isRunning: false,
          remainingSeconds: 0,
          spyRevealed: currentState.spyRevealed,
          spies: _spies,
        ));
        
        emit(TimerFinished(spies: _spies));
      }
    }
  }
  
  // إعادة ضبط المؤقت
  void resetTimer() {
    if (state is TimerReady || state is TimerFinished) {
      _timer?.cancel();
      _timer = null;
      
      emit(TimerReady(
        duration: _duration,
        isRunning: false,
        remainingSeconds: _duration,
        spyRevealed: false,
        spies: _spies,
      ));
    }
  }
  
  // كشف هوية الجاسوس
  void revealSpy() {
    if (state is TimerReady) {
      final currentState = state as TimerReady;
      
      emit(TimerReady(
        duration: _duration,
        isRunning: currentState.isRunning,
        remainingSeconds: currentState.remainingSeconds,
        spyRevealed: true,
        spies: _spies,
      ));
    }
  }
  
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}