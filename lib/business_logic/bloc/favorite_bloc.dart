import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/book_model.dart';
import '../../data/providers/local_storage_provider.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final LocalStorageProvider localStorageProvider;

  FavoriteBloc({required this.localStorageProvider}) : super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favorites = await localStorageProvider.getFavorites();
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to load favorites: $e'));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoriteState> emit) async {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      final List<Book> currentFavorites = List.from(currentState.favorites);
      
      final isFavorite = currentFavorites.any((b) => b.key == event.book.key);
      
      if (isFavorite) {
        currentFavorites.removeWhere((b) => b.key == event.book.key);
      } else {
        currentFavorites.add(event.book);
      }
      
      try {
        await localStorageProvider.saveFavorites(currentFavorites);
        emit(FavoriteLoaded(favorites: currentFavorites));
      } catch (e) {
        emit(FavoriteError(message: 'Failed to save favorite: $e'));
      }
    }
  }
}
