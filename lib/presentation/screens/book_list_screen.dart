import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/bloc/book_bloc.dart';
import '../../business_logic/bloc/book_event.dart';
import '../../business_logic/bloc/book_state.dart';
import '../../data/repositories/book_repository.dart';
import '../widgets/error_view.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(FetchBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Book Explorer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<BookBloc>().add(SearchBooks(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookLoaded) {
                  final books = state.books;
                  if (books.isEmpty) {
                    return const Center(child: Text('No books found.'));
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
                } else if (state is BookError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<BookBloc>().add(FetchBooks());
                    },
                  );
                }
                return const Center(child: Text('Please wait...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
