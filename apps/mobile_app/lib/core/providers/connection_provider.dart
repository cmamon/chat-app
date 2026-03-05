import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@riverpod
Stream<List<ConnectivityResult>> connectivity(Ref ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
bool isConnected(Ref ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (results) =>
        results.any((result) => result != ConnectivityResult.none),
    loading: () => true, // Assume connected while loading
    error: (_, _) => true,
  );
}
