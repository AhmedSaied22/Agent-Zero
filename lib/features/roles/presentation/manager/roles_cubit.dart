import 'package:elgassos/features/game/data/models/game_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/player_role.dart';
import '../../data/repo/roles_repository.dart';
import 'roles_state.dart';

class RolesCubit extends Cubit<RolesState> {
  RolesCubit() : super(RolesInitial());
  
  List<PlayerRole> _roles = [];
  int _currentPlayerIndex = 0;
  
  // تحميل أدوار اللاعبين
  Future<void> loadPlayerRoles(String selectedItem, {CardType? cardType}) async {
    try {
      emit(RolesLoading());
      _roles = await RolesRepository.generatePlayerRoles(selectedItem, cardType: cardType);
      _currentPlayerIndex = 0;
      emit(RoleReady(
        currentRole: _roles[_currentPlayerIndex],
        currentPlayerIndex: _currentPlayerIndex,
        totalPlayers: _roles.length,
        isRevealed: false,
      ));
    } catch (e) {
      emit(RolesError('حدث خطأ أثناء تحميل أدوار اللاعبين: $e'));
    }
  }
  
  // كشف دور اللاعب الحالي
  void revealCurrentRole() {
    if (state is RoleReady) {
      final currentState = state as RoleReady;
      if (!currentState.isRevealed) {
        emit(RoleReady(
          currentRole: currentState.currentRole,
          currentPlayerIndex: _currentPlayerIndex,
          totalPlayers: _roles.length,
          isRevealed: true,
        ));
      }
    }
  }
  
  // الانتقال إلى اللاعب التالي
  void nextPlayer() {
    if (_currentPlayerIndex < _roles.length - 1) {
      _currentPlayerIndex++;
      emit(RoleReady(
        currentRole: _roles[_currentPlayerIndex],
        currentPlayerIndex: _currentPlayerIndex,
        totalPlayers: _roles.length,
        isRevealed: false,
      ));
    } else {
      // تم الانتهاء من جميع اللاعبين
      emit(AllRolesRevealed());
    }
  }
  
  // الحصول على رسالة الجاسوس
  String getSpyMessage() {
    return RolesRepository.getSpyMessage();
  }
  
  // الحصول على رسالة اللاعب العادي
  String getNormalPlayerMessage(String assignedItem) {
    return RolesRepository.getNormalPlayerMessage(assignedItem);
  }
  
  // الحصول على اسم الفئة
  String getCategoryName() {
    return RolesRepository.getCategoryName();
  }
}