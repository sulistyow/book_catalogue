import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/network/network_helper.dart';
import '../../data/repositories/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;
  late final NetworkHelper _networkHelper;
  late final StreamSubscription<bool> _networkSubscription;

  BookBloc({required this.repository, NetworkHelper? networkHelper})
    : super(BookInitial()) {
    _networkHelper = networkHelper ?? NetworkHelper();

    on<FetchBooks>(_onFetchBooks);
    on<SearchBooks>(
      _onSearchBooks,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<FetchBookDetail>(_onFetchBookDetail);
    on<NetworkChanged>(_onNetworkChanged);

    _networkSubscription = _networkHelper.onConnectivityChanged.listen((
      isConnected,
    ) {
      add(NetworkChanged(isConnected));
    });
  }

  @override
  Future<void> close() {
    _networkSubscription.cancel();
    _networkHelper.dispose();
    return super.close();
  }

  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final books = await repository.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      if (e.toString().contains('No Internet connection')) {
        emit(
          const BookError(
            message: 'No Internet connection. Please check your network.',
          ),
        );
      }
    }
  }

  Future<void> _onSearchBooks(SearchBooks event, Emitter<BookState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty || query.length < 3) {
      add(FetchBooks());
      return;
    }
    
    emit(BookLoading());
    try {
      final books = await repository.searchBooks(query);
      emit(BookLoaded(books: books));
    } catch (e) {
      if (e.toString().contains('No Internet connection')) {
        emit(
          const BookError(
            message: 'No Internet connection. Please check your network.',
          ),
        );
      } else {
        emit(BookError(message: 'Failed to search books: $e'));
      }
    }
  }


  void _onNetworkChanged(NetworkChanged event, Emitter<BookState> emit) {
    if (!event.isConnected) {
      emit(
        const BookError(
          message: 'No Internet connection. Please check your network.',
        ),
      );
    }
  }

  Future<void> _onFetchBookDetail(
    FetchBookDetail event,
    Emitter<BookState> emit,
  ) async {
    emit(BookDetailLoading());
    try {
      final bookDetail = await repository.getBookDetail(event.key);
      emit(BookDetailLoaded(bookDetail: bookDetail));
    } catch (e) {
      if (e.toString().contains('No Internet connection')) {
        emit(
          const BookDetailError(
            message: 'No Internet connection. Please check your network.',
          ),
        );
      } else {
        emit(
          BookDetailError(message: e.toString().replaceAll('Exception: ', '')),
        );
      }
    }
  }
}
