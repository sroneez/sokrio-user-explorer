import 'package:sokrio_user_explorer/features/users/domain/entities/user.dart';


class UsersState {
  final List<UserEntity> users;
  final int currentPage;
  final bool isLoading;
  final bool hasReachedMax;
  final String? exceptionMessage;

  const UsersState({
    this.users = const [],
    this.currentPage = 1,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.exceptionMessage,
  });

  UsersState copyWith({
    List<UserEntity>? users,
    int? currentPage,
    bool? isLoading,
    bool? hasReachedMax,
    String? exceptionMessage,
  }) {
    return UsersState(
      users: users ?? this.users,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      exceptionMessage: exceptionMessage,
    );
  }
}