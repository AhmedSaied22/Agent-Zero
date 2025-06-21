import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameDataStorage {
  static const String _playerNamesKey = 'player_names';
  static const String _spyCountKey = 'spy_count';
  static const String _gameDurationKey = 'game_duration';

  // حفظ أسماء اللاعبين
  static Future<bool> savePlayerNames(List<String> playerNames) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(_playerNamesKey, playerNames);
    } catch (e) {
      print('Error saving player names: $e');
      return false;
    }
  }

  // استرجاع أسماء اللاعبين
  static Future<List<String>> getPlayerNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_playerNamesKey) ?? [];
    } catch (e) {
      print('Error getting player names: $e');
      return [];
    }
  }

  // حفظ عدد الجواسيس
  static Future<bool> saveSpyCount(int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_spyCountKey, count);
    } catch (e) {
      print('Error saving spy count: $e');
      return false;
    }
  }

  // استرجاع عدد الجواسيس
  static Future<int> getSpyCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_spyCountKey) ?? 1;
    } catch (e) {
      print('Error getting spy count: $e');
      return 1;
    }
  }

  // حفظ مدة اللعبة
  static Future<bool> saveGameDuration(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_gameDurationKey, minutes);
    } catch (e) {
      print('Error saving game duration: $e');
      return false;
    }
  }

  // استرجاع مدة اللعبة
  static Future<int> getGameDuration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_gameDurationKey) ?? 5;
    } catch (e) {
      print('Error getting game duration: $e');
      return 5;
    }
  }

  // حفظ جميع بيانات اللعبة
  static Future<bool> saveGameData({
    required List<String> playerNames,
    required int spyCount,
    required int gameDuration,
  }) async {
    try {
      await savePlayerNames(playerNames);
      await saveSpyCount(spyCount);
      await saveGameDuration(gameDuration);
      return true;
    } catch (e) {
      print('Error saving game data: $e');
      return false;
    }
  }
}