import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'business_logic/bloc/book_bloc.dart';
import 'business_logic/bloc/favorite_bloc.dart';
import 'business_logic/bloc/favorite_event.dart';
import 'data/providers/book_api_provider.dart';
import 'data/repositories/book_repository.dart';
import 'data/providers/local_storage_provider.dart';
import 'presentation/screens/book_list_screen.dart';
import 'presentation/screens/favorite_list_screen.dart';

void main() {
  final http.Client httpClient = http.Client();
  final BookApiProvider apiProvider = BookApiProvider(client: httpClient);
  final BookRepository repository = BookRepository(apiProvider: apiProvider);
  final LocalStorageProvider localStorageProvider = LocalStorageProvider();

  runApp(MyApp(
    repository: repository,
    localStorageProvider: localStorageProvider,
  ));
}

class MyApp extends StatelessWidget {
  final BookRepository repository;
  final LocalStorageProvider localStorageProvider;

  const MyApp({
    super.key,
    required this.repository,
    required this.localStorageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        RepositoryProvider.value(value: localStorageProvider),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BookBloc(repository: repository)),
          BlocProvider(
            create: (context) => FavoriteBloc(
              localStorageProvider: localStorageProvider,
            )..add(LoadFavorites()),
          ),
        ],
        child: MaterialApp(
          title: 'Book Explorer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orangeAccent,
              primary: Colors.orange,
              secondary: Colors.lightBlue,
              surface: Colors.orange[50]!,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey[400],
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          home: const MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BookListScreen(),
    FavoriteListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
