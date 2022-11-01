import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yumemi_codecheck/models/repository.dart';

/// [repository]の詳細ページ
class DetailPage extends StatelessWidget {
  final GithubRepository repository;
  const DetailPage(this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.network(
                      repository.icon,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 32,
                          height: 32,
                        );
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(left: 8.0)),
                    Expanded(
                      child: Text(
                        repository.name,
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: NumberFormat.compact()
                              .format(repository.stargazers),
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: ' Star',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16)),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: NumberFormat.compact().format(repository.forks),
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: ' Fork',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ]),
                    ),
                  ],
                ),
                Text('language: ${repository.language}'),
                Text('issues: ${repository.openIssues}'),
                Text('watcher: ${repository.watchers}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
