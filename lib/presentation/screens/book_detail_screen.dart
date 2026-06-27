import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/book_bloc.dart';
import '../../business_logic/bloc/book_state.dart';
import '../../business_logic/bloc/book_event.dart';
import '../../business_logic/bloc/favorite_bloc.dart';
import '../../business_logic/bloc/favorite_event.dart';
import '../../business_logic/bloc/favorite_state.dart';
import '../../data/models/book_model.dart';
import '../widgets/error_view.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Detail"),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoaded) {
                final isFav = state.isFavorite(book.key);
                return IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  color: isFav ? Colors.red : null,
                  onPressed: () {
                    context.read<FavoriteBloc>().add(ToggleFavorite(book));
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  height: 300,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'By: ${book.authors.isNotEmpty ? book.authors.join(", ") : "Unknown Author"}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailContent(context, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, BookState state) {
    if (state is BookDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is BookDetailError || state is BookError) {
      final message = state is BookDetailError
          ? state.message
          : (state as BookError).message;
      return ErrorView(
        message: message,
        onRetry: () {
          context.read<BookBloc>().add(FetchBookDetail(book.key));
        },
      );
    } else if (state is BookDetailLoaded) {
      final detail = state.bookDetail;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            detail.description.isNotEmpty
                ? detail.description
                : 'No description available.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (detail.subjects.isNotEmpty) ...[
            const Text(
              'Subjects',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: detail.subjects
                  .map((subject) => Chip(label: Text(subject)))
                  .toList(),
            ),
          ],
        ],
      );
    }
    return const SizedBox.shrink(); // Initial state
  }
}
