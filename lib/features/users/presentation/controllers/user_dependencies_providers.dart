import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

final userCacheBoxProvider = Provider<Box>((ref) {
  return Hive.box('user_cache_box');
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(userCacheBoxProvider);
  return UserRepositoryImpl(apiClient: client, cacheBox: cache);
});