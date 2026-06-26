
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sokrio_user_explorer/core/network/api_client.dart';
import 'package:sokrio_user_explorer/core/network/api_constants.dart';
import 'package:sokrio_user_explorer/features/users/data/repositories/user_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockHiveBox extends Mock implements Box {}

void main() {
  late UserRepositoryImpl repository;
  late MockApiClient mockApiClient;
  late MockHiveBox mockBox;

  setUp(() {
    mockApiClient = MockApiClient();
    mockBox = MockHiveBox();
    repository = UserRepositoryImpl(apiClient: mockApiClient, cacheBox: mockBox);
  });

  final tJsonResponse = {
    "page": 1,
    "per_page": 10,
    "total": 12,
    "total_pages": 2,
    "data": [
      {
        "id": 1,
        "email": "george.bluth@reqres.in",
        "first_name": "George",
        "last_name": "Bluth",
        "avatar": "https://reqres.in/img/faces/1-image.jpg"
      }
    ]
  };

  test('should return list of users when the API call is successful', () async {
    // Arrange
    when(() => mockBox.containsKey(any())).thenReturn(false); // Force cache miss
    when(() => mockApiClient.get(ApiConstants.getUsers, queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => dio.Response(
      data: tJsonResponse,
      statusCode: 200,
      requestOptions: dio.RequestOptions(path: ApiConstants.getUsers),
    ));
    when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

    // Act
    final result = await repository.fetchPaginatedUsers(page: 1, perPage: 10);

    // Assert
    expect(result.length, 1);
    expect(result.first.firstName, 'George');
    verify(() => mockApiClient.get(ApiConstants.getUsers, queryParameters: {'page': 1, 'per_page': 10})).called(1);
    verify(() => mockBox.put(any(), any())).called(1);
  });
}