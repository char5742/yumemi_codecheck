// リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数
class GithubRepository {
  final String name;
  final String icon;
  final String language;
  final int stargazers;
  final int watchers;
  final int forks;
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
