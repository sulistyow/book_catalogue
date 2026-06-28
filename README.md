# Book Explorer

<video src="app_demo.mp4" width="300" controls></video>

Flutter application that allows users to explore, search, and save their favorite books using the public [OpenLibrary API](https://openlibrary.org/).

## Features

* **Real-time Search**: Search for books by title. The search is optimized with debouncing (via `rxdart`) to prevent spamming the API while typing. Requires a minimum of 3 characters to search.
* **Persistent Favorites**: Save your favorite books! Favorites are stored locally on your device using `shared_preferences`, so they persist even when the app is closed.
* **Clean Architecture**: Built with separation of concerns in mind (Data, Business Logic, Presentation layers).
* **State Management**: Fully powered by `flutter_bloc` for predictable and testable state.

## Tech Stack

* **Flutter SDK**: UI Toolkit
* **flutter_bloc & equatable**: State management
* **http**: Network requests
* **rxdart**: Reactive programming (used for search debouncing)
* **shared_preferences**: Local persistent storage
* **cached_network_image**: Efficient image loading and caching

## Getting Started

Follow these steps to run the project locally on your machine.

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
* A working emulator or physical device.

### Installation

1. Clone the repository or download the source code.
2. Open a terminal and navigate to the project directory:
   ```bash
   cd book_explorer
   ```
3. Fetch the required dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Architecture Overview

The project is structured into three main layers inside the `lib/` directory:

* **`data/`**: Handles external data sources and local storage. Includes `BookApiProvider` (OpenLibrary API), `LocalStorageProvider` (Shared Preferences), and `BookRepository`.
* **`business_logic/`**: Contains the BLoCs (`BookBloc`, `FavoriteBloc`) that manage the application state and handle events from the UI.
* **`presentation/`**: Contains the UI widgets and screens (`BookListScreen`, `FavoriteListScreen`, `BookDetailScreen`, and reusable components like `BookCard`).

## API Reference

This app consumes the [OpenLibrary Search API](https://openlibrary.org/dev/docs/api/search).
- Default Books: `https://openlibrary.org/search.json?subject=children&limit=20`
- Search: `https://openlibrary.org/search.json?q={query}&limit=20`
- Book Details: `https://openlibrary.org/works/{key}.json`
