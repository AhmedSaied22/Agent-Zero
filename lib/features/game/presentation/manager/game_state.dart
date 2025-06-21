import 'package:equatable/equatable.dart';
import '../../data/models/game_card.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

// حالة التحميل الأولي
class GameInitial extends GameState {}

// حالة تحميل الكروت
class GameLoading extends GameState {}

// حالة عرض الكروت للاختيار
class GameCardsLoaded extends GameState {
  final List<GameCard> cards;

  const GameCardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

// حالة اختيار كارت معين
class GameCardSelected extends GameState {
  final GameCard selectedCard;
  final String selectedItem;
  final CardType cardType;

  const GameCardSelected({
    required this.selectedCard,
    required this.selectedItem,
    required this.cardType,
  });

  @override
  List<Object?> get props => [selectedCard, selectedItem, cardType];
}

// حالة خطأ
class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}