
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokrio_user_explorer/features/users/presentation/controllers/user_dependencies_providers.dart';

import 'users_state.dart';

import '../../domain/repositories/user_repository.dart';

final usersListControllerProvider = AutoDisposeNotifierProvider<UsersListController, UsersState>(() {
  return UsersListController();
});

class UsersListController extends AutoDisposeNotifier<UsersState> {
  late final UserRepository _repository;

  @override
  UsersState build() {
    _repository = ref.watch(userRepositoryProvider);

    Future.microtask(() => fetchNextPage());
    return const UsersState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true, exceptionMessage: null);

    try {
      final newUsers = await _repository.fetchPaginatedUsers(
        page: state.currentPage,
        perPage: 10,
      );

      if (newUsers.isEmpty) {
        state = state.copyWith(isLoading: false, hasReachedMax: true);
      } else {
        state = state.copyWith(
          users: [...state.users, ...newUsers],
          currentPage: state.currentPage + 1,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        exceptionMessage: 'Failed to fetch data. Please verify your connection and try again.',
      );
    }
  }

  Future<void> refresh() async {
    state = const UsersState();
    await fetchNextPage();
  }
}