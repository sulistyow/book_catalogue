import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Book> favorites;

  const FavoriteLoaded({required this.favorites});

  bool isFavorite(String key) {
    return favorites.any((book) => book.key == key);
  }

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
