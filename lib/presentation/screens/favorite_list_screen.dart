import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/book_bloc.dart';
import '../../business_logic/bloc/book_event.dart';
import '../../business_logic/bloc/favorite_bloc.dart';
import '../../business_logic/bloc/favorite_state.dart';
import '../../data/repositories/book_repository.dart';
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
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: book.coverUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.book),
                  ),
                  title: Text(book.title),
                  subtitle: Text(
                    '${book.authors.isNotEmpty ? book.authors.first : 'Unknown Author'}'
                    '${book.firstPublishYear != null ? ' (${book.firstPublishYear})' : ''}',
                  ),
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
