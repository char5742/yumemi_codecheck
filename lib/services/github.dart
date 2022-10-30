import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yumemi_codecheck/models/repository.dart';

class FetchResult {
  final List<GithubRepository> repositories;
  final int totalCount;
  final bool incompleteResults;
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
