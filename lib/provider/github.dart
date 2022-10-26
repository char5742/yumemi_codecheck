import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yumemi_codecheck/models/repository.dart';
import 'package:yumemi_codecheck/services/github.dart';

final repositoriesProvider =
    StateNotifierProvider<RepositoryNotifier, List<GithubRepository>>(
  (ref) => RepositoryNotifier(),
);

class RepositoryNotifier extends StateNotifier<List<GithubRepository>> {
  RepositoryNotifier() : super([]);

  late int _page;
  late bool _hasNext;
  late String _keyword;
  final int perPage = 30;

  Future<void> fetchFirst(String keyword) async {
    final result = await GithubService.fetchRepositoriesByKeyword(
      keyword,
      perPage: perPage,
    );
    _keyword = keyword;
    _hasNext = result.totalCount > perPage;
    _page = 1;
    state = result.repositories;
  }

  Future<void> fetchNext() async {
    if (_hasNext) {
      final result = await GithubService.fetchRepositoriesByKeyword(
        _keyword,
        perPage: perPage,
        page: ++_page,
      );
      state = [...state, ...result.repositories];
      _hasNext = result.totalCount > _page * perPage;
    }
  }
}
