import 'package:equatable/equatable.dart';

enum CardType {
  jobs,
  countries,
  famousPlaces,
  publicPlaces,
  foods,
  footballPlayers,
}

class GameCard extends Equatable {
  final String id;
  final String title;
  final CardType type;
  final List<String> items;

  const GameCard({
    required this.id,
    required this.title,
    required this.type,
    required this.items,
  });

  @override
  List<Object?> get props => [id, title, type, items];
}