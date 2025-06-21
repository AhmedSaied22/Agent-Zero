import 'dart:math';
import '../models/player_role.dart';
import '../../../../core/utils/game_data_storage.dart';
import '../../../../features/game/data/models/game_card.dart';

class RolesRepository {
  // تخزين أدوار اللاعبين
  static List<PlayerRole> _playerRoles = [];
  // تخزين اسم الفئة المختارة
  static String _selectedCategory = '';
  
  static Future<List<PlayerRole>> generatePlayerRoles(String selectedItem, {CardType? cardType}) async {
    try {
      // الحصول على بيانات اللعبة المحفوظة
      final playerNames = await GameDataStorage.getPlayerNames();
      final spyCount = await GameDataStorage.getSpyCount();
      
      if (playerNames.isEmpty) {
        throw Exception('لا توجد أسماء لاعبين محفوظة');
      }
      
      if (spyCount >= playerNames.length) {
        throw Exception('عدد الجواسيس لا يمكن أن يكون أكبر من أو يساوي عدد اللاعبين');
      }
      
      // تحديد اسم الفئة من نوع الكارت المختار
      if (cardType != null) {
        _selectedCategory = _getCategoryFromCardType(cardType);
      } else {
        // استخدام الطريقة القديمة كاحتياط
        _selectedCategory = _getCategoryFromItem(selectedItem);
      }
      
      final List<PlayerRole> roles = [];
      final random = Random();
      
      // إنشاء قائمة بمؤشرات اللاعبين
      final List<int> playerIndices = List.generate(playerNames.length, (index) => index);
      
      // خلط القائمة لاختيار الجواسيس عشوائياً
      playerIndices.shuffle(random);
      
      // اختيار الجواسيس
      final Set<int> spyIndices = playerIndices.take(spyCount).toSet();
      
      // إنشاء الأدوار
      for (int i = 0; i < playerNames.length; i++) {
        final isSpy = spyIndices.contains(i);
        roles.add(PlayerRole(
          playerName: playerNames[i],
          isSpy: isSpy,
          assignedItem: isSpy ? null : selectedItem, // الجاسوس لا يحصل على العنصر
        ));
      }
      
      // حفظ الأدوار للاستخدام لاحقًا
      _playerRoles = roles;
      
      return roles;
    } catch (e) {
      throw Exception('حدث خطأ أثناء توليد الأدوار: $e');
    }
  }
  
  // الحصول على أدوار اللاعبين المخزنة
  static Future<List<PlayerRole>> getPlayerRoles() async {
    if (_playerRoles.isEmpty) {
      throw Exception('لم يتم توليد أدوار اللاعبين بعد');
    }
    return _playerRoles;
  }
  
  static String getSpyMessage() {
    final List<String> spyMessages = [
      'أنت الجاسوس! 🕵️‍♂️',
      'أنت لجنة يالا! 😈',
      'مهمتك اكتشاف المكان! 🔍',
      'أنت الجاسوس المطلوب! 🎭',
    ];
    
    // دائما إرجاع الرسالة الثانية
    return spyMessages[1];
  }
  static String getNormalPlayerMessage(String assignedItem) {
    final List<String> normalMessages = [
      'أنت راجل طيب على فكرة! 😊',
      'أنت لاعب عادي! 👤',
      'مهمتك اكتشاف الجاسوس! 🔍',
      'أنت من الفريق الطيب! ✨',
    ];
    
    // إرجاع الرسالة بدون اسم الفئة (سيتم عرضها بشكل منفصل)
    return normalMessages[0];
  }
  
  // الحصول على اسم الفئة المختارة
  static String getCategoryName() {
    return _selectedCategory;
  }
  
  // تحديد اسم الفئة من نوع الكارت
  static String _getCategoryFromCardType(CardType cardType) {
    switch (cardType) {
      case CardType.jobs:
        return 'الوظائف';
      case CardType.countries:
        return 'البلدان';
      case CardType.famousPlaces:
        return 'الأماكن المشهورة';
      case CardType.publicPlaces:
        return 'الأماكن العامة';
      case CardType.foods:
        return 'الأطعمة';
      case CardType.footballPlayers:
        return 'لاعبي كرة القدم';
    }
  }
  
  // استخراج اسم الفئة من العنصر المختار (طريقة احتياطية)
  static String _getCategoryFromItem(String selectedItem) {
    // تحسين طريقة تحديد الفئة بناءً على محتوى العنصر
    if (selectedItem.contains('(البرازيل)') || selectedItem.contains('(الأرجنتين)') || 
        selectedItem.contains('(مصر)') || selectedItem.contains('(فرنسا)') || 
        selectedItem.contains('(البرتغال)') || selectedItem.contains('ميسي') || 
        selectedItem.contains('رونالدو') || selectedItem.contains('صلاح')) {
      return 'لاعبي كرة القدم';
    } else if (selectedItem.contains('(فرنسا)') || selectedItem.contains('(أمريكا)') || 
              selectedItem.contains('(مصر)') || selectedItem.contains('(الإمارات)') || 
              selectedItem.contains('(الهند)') || selectedItem.contains('برج') || 
              selectedItem.contains('تمثال') || selectedItem.contains('جبل')) {
      return 'الأماكن المشهورة';
    } else if (selectedItem.contains('صحراء') || selectedItem.contains('غابة') || 
              selectedItem.contains('بحر') || selectedItem.contains('متحف') || 
              selectedItem.contains('مكتبة') || selectedItem.contains('مستشفى')) {
      return 'الأماكن العامة';
    } else if (selectedItem.contains('طبيب') || selectedItem.contains('مهندس') || 
              selectedItem.contains('معلم') || selectedItem.contains('محامي') || 
              selectedItem.contains('طباخ') || selectedItem.contains('سائق')) {
      return 'الوظائف';
    } else if (selectedItem.contains('فول') || selectedItem.contains('طعمية') || 
              selectedItem.contains('برجر') || selectedItem.contains('بيتزا') || 
              selectedItem.contains('شاورما') || selectedItem.contains('كباب')) {
      return 'الأطعمة';
    } else if (selectedItem.contains('مصر') || selectedItem.contains('السعودية') || 
              selectedItem.contains('الإمارات') || selectedItem.contains('الكويت') || 
              selectedItem.contains('قطر') || selectedItem.contains('البحرين')) {
      return 'البلدان';
    }
    
    // إذا لم يتم التعرف على الفئة
    return 'فئة غير معروفة';
  }
}