import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final networkStreamProvider = StreamProvider<ConnectivityResult>((_) async* {
  yield await Connectivity().checkConnectivity();
  yield* Connectivity().onConnectivityChanged;
});

/// ネットワークの接続状態
final networkProvider = Provider((ref) {
  final state = ref.watch(networkStreamProvider
      .select((value) => value.value != ConnectivityResult.none));
  return state;
});
