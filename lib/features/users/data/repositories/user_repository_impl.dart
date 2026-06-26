// lib/src/features/users/data/repositories/user_repository_impl.dart
import 'package:hive_ce/hive.dart';
import 'package:sokrio_user_explorer/features/users/domain/entities/user.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  final Box _cacheBox;

  UserRepositoryImpl({
    required ApiClient apiClient,
    required Box cacheBox,
  })  : _apiClient = apiClient,
        _cacheBox = cacheBox;

  String _getCacheKey(int page) => 'cached_users_page_$page';

  @override
  Future<List<UserEntity>> fetchPaginatedUsers({required int page, required int perPage}) async {
    final cacheKey = _getCacheKey(page);

    try {
      final response = await _apiClient.get(
        ApiConstants.getUsers,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      final List<dynamic> rawList = responseData['data'] as List<dynamic>;

      final List<UserModel> fetchedModels = rawList
          .map((userJson) => UserModel.fromJson(userJson as Map<String, dynamic>))
          .toList();

      final dynamicSerializedList = fetchedModels.map((m) => m.toJson()).toList();
      await _cacheBox.put(cacheKey, dynamicSerializedList);

      return fetchedModels;
    } on ApiException catch (apiException) {
      if (_cacheBox.containsKey(cacheKey)) {
        return _readLocalCache(cacheKey);
      }
      throw ApiException(message: apiException.message, statusCode: apiException.statusCode);
    } catch (e) {
      if (_cacheBox.containsKey(cacheKey)) {
        return _readLocalCache(cacheKey);
      }
      throw ApiException(message: 'An unexpected application exception occurred.');
    }
  }

  List<UserEntity> _readLocalCache(String key) {
    final List<dynamic> rawCachedList = _cacheBox.get(key) as List<dynamic>;
    return rawCachedList
        .map((element) => UserModel.fromJson(Map<String, dynamic>.from(element as Map)))
        .toList();
  }
}