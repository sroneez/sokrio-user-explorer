import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkConnectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  final initialStatus = await connectivity.checkConnectivity();
  yield !initialStatus.contains(ConnectivityResult.none);

  await for (final result in connectivity.onConnectivityChanged) {
    yield !result.contains(ConnectivityResult.none);
  }
});