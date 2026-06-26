// lib/src/features/users/presentation/controller/user_search_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokrio_user_explorer/features/users/domain/entities/user.dart';
import 'package:sokrio_user_explorer/features/users/presentation/controllers/user_list_controller.dart';


final userSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final userSearchControllerProvider = Provider.autoDispose<List<UserEntity>>((ref) {
  final state = ref.watch(usersListControllerProvider);
  final query = ref.watch(userSearchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) return state.users;

  final safeRegex = RegExp(RegExp.escape(query));

  return state.users.where((user) {
    final targetName = user.fullName.toLowerCase();
    final targetEmail = user.email.toLowerCase();
    return safeRegex.hasMatch(targetName) || safeRegex.hasMatch(targetEmail);
  }).toList();
});