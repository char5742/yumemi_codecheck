/// 必要なGithub Repositoryの情報
class GithubRepository {
  /// リポジトリ名
  final String name;

  /// ユーザーアイコンURL
  final String icon;

  /// プロジェクト言語
  final String? language;

  /// Star数
  final int stargazers;

  /// Wacher数
  final int watchers;

  /// Fork数
  final int forks;

  /// open状態のissue数
  final int openIssues;

  const GithubRepository({
    required this.name,
    required this.icon,
    required this.language,
    required this.stargazers,
    required this.watchers,
    required this.forks,
    required this.openIssues,
  });

  /// github apiからのjsonレスポンスを[GithubRepository]に変換
  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    return GithubRepository(
      name: json['full_name'],
      icon: json['owner']['avatar_url'],
      language: json['language'],
      stargazers: json['stargazers_count'],
      watchers: json['watchers'],
      forks: json['forks'],
      openIssues: json['open_issues'],
    );
  }
}
