import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/game_card.dart';
import '../../data/repo/game_data_repository.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  // تحميل الكروت
  void loadGameCards() {
    try {
      emit(GameLoading());
      final cards = GameDataRepository.getGameCards();
      emit(GameCardsLoaded(cards));
    } catch (e) {
      emit(GameError('حدث خطأ أثناء تحميل الكروت: $e'));
    }
  }

  // اختيار كارت معين
  void selectCard(GameCard card) {
    try {
      final randomItem = GameDataRepository.getRandomItem(card.type);
      emit(GameCardSelected(
        selectedCard: card,
        selectedItem: randomItem,
        cardType: card.type,
      ));
    } catch (e) {
      emit(GameError('حدث خطأ أثناء اختيار الكارت: $e'));
    }
  }

  // العودة لعرض الكروت
  void backToCards() {
    loadGameCards();
  }
}