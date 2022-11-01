import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yumemi_codecheck/models/repository.dart';

class FetchResult {
  /// １ページ分のRepositoryのリスト
  final List<GithubRepository> repositories;

  /// 検索結果の総数
  final int totalCount;

  /// 検索が時間内に終わったかどうか
  final bool incompleteResults; // TODO: 検索が時間内に終わらない場合の処理が必要
  const FetchResult({
    required this.repositories,
    required this.totalCount,
    required this.incompleteResults,
  });
}

class StatusCodeException implements Exception {
  final int statusCode;
  StatusCodeException(this.statusCode);
  @override
  String toString() {
    return "StatusCodeException: $this.statusCode";
  }
}

class GithubService {
  /// [keyword]による検索結果を返す
  ///
  /// [page]目を取得する。１ページあたりは[perPage]個
  static Future<FetchResult> fetchRepositoriesByKeyword(
    String keyword, {
    int perPage = 30,
    int page = 1,
  }) async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?q=$keyword&page=$page&per_page=$perPage'));

    if (response.statusCode != 200) {
      throw StatusCodeException(response.statusCode);
    }

    final json = jsonDecode(response.body);
    final repositories = (json['items'].cast<Map<String, dynamic>>()
            as List<Map<String, dynamic>>)
        .map(GithubRepository.fromJson)
        .toList();
    return FetchResult(
      repositories: repositories,
      totalCount: json['total_count'],
      incompleteResults: json['incomplete_results'],
    );
  }
}
