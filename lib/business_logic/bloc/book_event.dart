import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class FetchBooks extends BookEvent {}

class SearchBooks extends BookEvent {
  final String query;
  const SearchBooks(this.query);

  @override
  List<Object> get props => [query];
}

class FetchBookDetail extends BookEvent {
  final String key;
  const FetchBookDetail(this.key);

  @override
  List<Object> get props => [key];
}

class NetworkChanged extends BookEvent {
  final bool isConnected;
  const NetworkChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}
