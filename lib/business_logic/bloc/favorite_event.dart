import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Book book;

  const ToggleFavorite(this.book);

  @override
  List<Object> get props => [book];
}
