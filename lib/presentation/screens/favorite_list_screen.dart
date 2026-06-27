import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/book_bloc.dart';
import '../../business_logic/bloc/book_event.dart';
import '../../business_logic/bloc/favorite_bloc.dart';
import '../../business_logic/bloc/favorite_state.dart';
import '../../data/repositories/book_repository.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Books')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            final books = state.favorites;
            if (books.isEmpty) {
              return const Center(child: Text('No favorite books yet.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  book: book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => BookBloc(
                            repository: context.read<BookRepository>(),
                          )..add(FetchBookDetail(book.key)),
                          child: BookDetailScreen(book: book),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
