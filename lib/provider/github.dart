import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yumemi_codecheck/models/repository.dart';
import 'package:yumemi_codecheck/provider/network.dart';
import 'package:yumemi_codecheck/services/github.dart';

final repositoriesProvider =
    StateNotifierProvider<RepositoryNotifier, RepositoryState>(
  (ref) => RepositoryNotifier(ref),
);

class RepositoryState {
  final List<GithubRepository> repositories;
  final bool isLoading;
  final Object? error;
  const RepositoryState(
      {required this.repositories, required this.isLoading, this.error});

  RepositoryState copyWith(
          {List<GithubRepository>? repositories,
          bool? isLoading,
          Object? error}) =>
      RepositoryState(
        repositories: repositories ?? this.repositories,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class RepositoryNotifier extends StateNotifier<RepositoryState> {
  RepositoryNotifier(this.ref)
      : super(const RepositoryState(
          repositories: [],
          isLoading: false,
        ));
  final Ref ref;
  late int _page;
  late bool _hasNext;
  late String _keyword;
  final int perPage = 30;

  /// [keyword]をもとにgithubのrepositoryを取得
  ///
  /// 1ページだけ取得し、１ページあたりは[perPage] (default 30)個である。
  Future<void> fetchFirst(String keyword) async {
    // ネットワークに接続していなければ何もしない
    if (!ref.read(networkProvider)) return;
    state = state.copyWith(isLoading: true);
    try {
      final result = await GithubService.fetchRepositoriesByKeyword(
        keyword,
        perPage: perPage,
      );
      _keyword = keyword;
      // 取得数よりも検索結果数が多ければ次のページが存在する
      _hasNext = result.totalCount > perPage;
      _page = 1;
      state =
          RepositoryState(repositories: result.repositories, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  /// [fetchFirst]で取得しきれなかった場合に追加で１ページを取得する
  Future<void> fetchNext() async {
    // 次のページがなければ何もしない
    if (!(_hasNext && ref.read(networkProvider))) return;
    try {
      final result = await GithubService.fetchRepositoriesByKeyword(
        _keyword,
        perPage: perPage,
        page: ++_page,
      );
      state = RepositoryState(
          repositories: [...state.repositories, ...result.repositories],
          isLoading: false);
      _hasNext = result.totalCount > _page * perPage;
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  /// 最初の１ページ分だけ再取得する
  Future<void> fetchRetry() async {
    if (!ref.read(networkProvider)) return;
    try {
      final result = await GithubService.fetchRepositoriesByKeyword(
        _keyword,
        perPage: perPage,
      );
      _hasNext = result.totalCount > perPage;
      _page = 1;
      state =
          RepositoryState(repositories: result.repositories, isLoading: false);
      _hasNext = result.totalCount > _page * perPage;
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}
