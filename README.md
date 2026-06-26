# Sokrio User Directory

A robust Flutter application built for the Sokrio Technologies technical assignment. This app
fetches, caches, and displays user profiles using a strict Clean Architecture approach.

## Tech Stack

* **Framework:** Flutter
* **State Management:** Riverpod
* **Networking:** Dio (Custom API Client with Interceptors)
* **Local Storage:** Hive CE (Community Edition)

## Setup Instructions

**Important Note on ReqRes API:** ReqRes recently updated their API to require an `x-api-key` for
all `/api/users` endpoints. I have configured the `ApiClient` to pass this header.

1. Clone the repository.
2. Run `flutter pub get`.
3. In `lib/src/core/network/api_client.dart`, ensure you have a valid ReqRes API key in the header
   configuration.
4. Run the app: `flutter run`.

## Architecture Overview

I structured this project using **Feature-First Clean Architecture** to ensure the codebase is
highly scalable and testable.

* **Domain Layer:** Contains pure Dart entities (`UserEntity`) and abstract repository interfaces.
  It has zero knowledge of Flutter or external packages.
* **Data Layer:** Handles API execution via a custom Dio wrapper and implements local caching via
  Hive. Uses `UserModel` for JSON serialization.
* **Presentation Layer:** Completely decoupled UI using Riverpod for dependency injection and state
  management. Controllers are isolated by responsibility (e.g., `user_list_controller.dart` handles
  pagination, `user_search_controller.dart` handles local filtering).

## Problem Scenarios Addressed

I paid close attention to the specific edge cases outlined in the assignment requirements:

* **Offline Support & Caching:** Implemented a fallback mechanism in `UserRepositoryImpl`. If the
  network fails or times out, the app instantly falls back to the most recent data cached in Hive.
* **Slow API Responses:** The network layer enforces a strict `connectTimeout` and `receiveTimeout`.
  If the API hangs, it aborts and serves cached data rather than leaving the user on a loading
  screen indefinitely.
* **Search Edge Cases:** The local search filter uses `RegExp.escape(query)` to safely sanitize
  inputs. This prevents the app from crashing if a user types special characters or regex symbols
  into the search bar.
* **Memory Management:** All Riverpod providers use the `.autoDispose` modifier. This guarantees
  that when the user leaves a feature, the memory is immediately freed, preventing leaks.
* **Empty States & Error UIs:** Handled empty search results, empty API payloads, and offline errors
  with dedicated, user-friendly UI components and retry mechanisms.

## Bonus Features Implemented

* Implemented caching using **Hive CE**.
* Native **Pull-to-Refresh** functionality.
* Pure dependency injection using **Riverpod** (bypassing the need for `get_it`).
* Unit testing for API repository execution using **Mocktail**.