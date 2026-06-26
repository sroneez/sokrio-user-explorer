// lib/src/features/users/domain/repositories/user_repository.dart
import 'package:sokrio_user_explorer/features/users/domain/entities/user.dart';


abstract class UserRepository {
  Future<List<UserEntity>> fetchPaginatedUsers({required int page, required int perPage});
}