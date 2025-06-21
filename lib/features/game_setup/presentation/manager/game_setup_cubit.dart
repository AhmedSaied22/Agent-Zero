import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elgassos/core/utils/game_data_storage.dart';
import 'package:elgassos/features/game_setup/presentation/manager/game_setup_state.dart';

class GameSetupCubit extends Cubit<GameSetupState> {
  // قائمة وحدات تحكم لحقول إدخال أسماء اللاعبين
  List<TextEditingController> playerNameControllers = [];

  GameSetupCubit() : super(GameSetupInitial()) {
    // تحميل البيانات المحفوظة عند إنشاء الـ Cubit
    loadSavedData();
  }

  // تحميل البيانات المحفوظة
  Future<void> loadSavedData() async {
    try {
      emit(GameSetupLoading());
      final spyCount = await GameDataStorage.getSpyCount() ?? 1;
      final gameDuration = await GameDataStorage.getGameDuration() ?? 3;
      final playerNames = await GameDataStorage.getPlayerNames() ?? [];

      // تهيئة وحدات تحكم أسماء اللاعبين
      _initializeControllers(playerNames.length > 0 ? playerNames.length : 3);

      // ملء وحدات التحكم بالأسماء المحفوظة
      for (int i = 0; i < playerNames.length && i < playerNameControllers.length; i++) {
        playerNameControllers[i].text = playerNames[i];
        // إضافة مستمع للتغييرات لكل وحدة تحكم
        _addTextFieldListener(playerNameControllers[i], i);
      }

      emit(GameSetupLoaded(
        playerNames: playerNames,
        playerCount: playerNames.length > 0 ? playerNames.length : 3,
        spyCount: spyCount,
        gameDuration: gameDuration,
      ));
    } catch (e) {
      emit(GameSetupError(e.toString()));
    }
  }

  // إضافة مستمع للتغييرات في حقل النص
  void _addTextFieldListener(TextEditingController controller, int index) {
    controller.addListener(() {
      _autoSavePlayerNames();
    });
  }

  // حفظ جميع البيانات تلقائيًا
  void _autoSaveAllData() {
    if (state is GameSetupLoaded) {
      final currentState = state as GameSetupLoaded;
      final names = playerNameControllers.map((controller) => controller.text).toList();
      
      // حفظ جميع البيانات بدون إظهار رسائل
      GameDataStorage.saveGameData(
        playerNames: names,
        spyCount: currentState.spyCount,
        gameDuration: currentState.gameDuration,
      );
    }
  }

  // حفظ الأسماء تلقائيًا
  void _autoSavePlayerNames() {
    if (state is GameSetupLoaded) {
      final names = playerNameControllers.map((controller) => controller.text).toList();
      
      // تحديث الحالة بدون إظهار رسائل
      GameDataStorage.savePlayerNames(names);
    }
  }

  void _initializeControllers(int count) {
    // التخلص من وحدات التحكم القديمة إذا كانت موجودة
    _disposeControllers();

    // إنشاء وحدات تحكم جديدة
    playerNameControllers = List.generate(count, (_) => TextEditingController());

    // إضافة مستمعين للتغييرات لكل وحدة تحكم
    for (int i = 0; i < playerNameControllers.length; i++) {
      _addTextFieldListener(playerNameControllers[i], i);
    }
  }

  // التخلص من وحدات التحكم
  void _disposeControllers() {
    for (var controller in playerNameControllers) {
      controller.dispose();
    }
    playerNameControllers.clear();
  }

  // تغيير عدد اللاعبين
  void changePlayerCount(int newCount) {
    if (state is GameSetupLoaded) {
      final currentState = state as GameSetupLoaded;
      
      // التحقق من أن العدد الجديد ضمن الحدود المسموح بها
      if (newCount < 3 || newCount > 12) return;

      // تحديث قائمة أسماء اللاعبين
      final currentNames = playerNameControllers.map((controller) => controller.text).toList();
      final newNames = List<String>.from(currentNames);
      
      // إضافة أو إزالة أسماء حسب العدد الجديد
      if (newCount > currentNames.length) {
        // إضافة أسماء جديدة
        for (int i = currentNames.length; i < newCount; i++) {
          newNames.add('لاعب ${i + 1}');
        }
      } else if (newCount < currentNames.length) {
        // إزالة الأسماء الزائدة
        newNames.removeRange(newCount, currentNames.length);
      }

      // تحديث وحدات التحكم في الأسماء
      _initializeControllers(newNames.length);
      for (int i = 0; i < newNames.length; i++) {
        playerNameControllers[i].text = newNames[i];
      }

      // تحديث الحالة
      emit(currentState.copyWith(
        playerCount: newCount,
        playerNames: newNames,
      ));
      
      // حفظ جميع البيانات تلقائيًا
      _autoSaveAllData();
    }
  }

  // تغيير عدد الجواسيس
  void changeSpyCount(int newCount) {
    if (state is GameSetupLoaded) {
      final currentState = state as GameSetupLoaded;
      
      // التحقق من أن العدد الجديد ضمن الحدود المسموح بها
      if (newCount < 1 || newCount > 6) return;

      // تحديث الحالة
      emit(currentState.copyWith(spyCount: newCount));
      
      // حفظ جميع البيانات تلقائيًا
      _autoSaveAllData();
    }
  }

  // تغيير مدة اللعبة
  void changeGameDuration(int newDuration) {
    if (state is GameSetupLoaded) {
      final currentState = state as GameSetupLoaded;
      
      // التحقق من أن المدة الجديدة ضمن الحدود المسموح بها
      if (newDuration < 1) return;

      // تحديث الحالة
      emit(currentState.copyWith(gameDuration: newDuration));
      
      // حفظ جميع البيانات تلقائيًا
      _autoSaveAllData();
    }
  }

  // التحقق من صحة أسماء اللاعبين ومنع التكرار
  bool validatePlayerNames() {
    if (state is GameSetupLoaded) {
      final currentState = state as GameSetupLoaded;
      
      // التحقق من إدخال جميع الأسماء
      List<int> emptyIndices = [];
      for (int i = 0; i < playerNameControllers.length; i++) {
        if (playerNameControllers[i].text.trim().isEmpty) {
          emptyIndices.add(i);
        }
      }

      if (emptyIndices.isNotEmpty) {
        emit(GameSetupValidationError(
          message: 'يرجى إدخال أسماء جميع اللاعبين',
          invalidIndices: emptyIndices,
        ));
        // إعادة الحالة السابقة بعد فترة قصيرة
        Future.delayed(const Duration(seconds: 3), () {
          emit(currentState);
        });
        return false;
      }

      // التحقق من عدم تكرار الأسماء
      final Set<String> uniqueNames = {};
      List<int> duplicateIndices = [];
      for (int i = 0; i < playerNameControllers.length; i++) {
        String name = playerNameControllers[i].text.trim();
        if (uniqueNames.contains(name)) {
          duplicateIndices.add(i);
        } else {
          uniqueNames.add(name);
        }
      }

      if (duplicateIndices.isNotEmpty) {
        emit(GameSetupValidationError(
          message: 'لا يمكن تكرار أسماء اللاعبين',
          invalidIndices: duplicateIndices,
        ));
        // إعادة الحالة السابقة بعد فترة قصيرة
        Future.delayed(const Duration(seconds: 3), () {
          emit(currentState);
        });
        return false;
      }

      return true;
    }
    return false;
  }

  // حفظ بيانات اللعبة (للاستخدام اليدوي فقط إذا لزم الأمر)
  Future<void> saveGameData() async {
    if (state is GameSetupLoaded) {
      // التحقق من صحة الأسماء
      if (!validatePlayerNames()) return;

      final currentState = state as GameSetupLoaded;
      emit(GameSetupSaving());

      try {
        // استخدام دالة الحفظ التلقائي
        _autoSaveAllData();
        
        // إظهار رسالة النجاح
        emit(GameSetupSaved());
        
        // العودة إلى الحالة المحدثة بعد فترة قصيرة
        Future.delayed(const Duration(seconds: 2), () {
          emit(currentState);
        });
      } catch (e) {
        emit(GameSetupError('حدث خطأ أثناء حفظ البيانات: $e'));
        // إعادة الحالة السابقة بعد فترة قصيرة
        Future.delayed(const Duration(seconds: 3), () {
          emit(currentState);
        });
      }
    }
  }

  @override
  Future<void> close() {
    // التخلص من وحدات التحكم عند إغلاق الـ Cubit
    _disposeControllers();
    return super.close();
  }
}