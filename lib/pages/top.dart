import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yumemi_codecheck/models/repository.dart';
import 'package:yumemi_codecheck/pages/detail.dart';
import 'package:yumemi_codecheck/provider/github.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final scrollController = useScrollController();
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          ref.read(repositoriesProvider.notifier).fetchNext();
        }
      });
      return null;
    }, const []);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: TextField(
              autofocus: true,
              controller: textController,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                primaryFocus?.unfocus();
                ref
                    .read(repositoriesProvider.notifier)
                    .fetchFirst(textController.text);
              },
            ),
          ),
          Visibility(
            visible: ref
                .watch(repositoriesProvider)
                .map(RepositoryInfo.new)
                .isNotEmpty,
            child: Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => ref
                    .read(repositoriesProvider.notifier)
                    .fetchFirst(textController.text),
                child: ListView(
                  controller: scrollController,
                  // ClampingScrollPhysicsでは正常にRefreshIndicatorが動作しないため
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: ref
                      .watch(repositoriesProvider)
                      .map(RepositoryInfo.new)
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RepositoryInfo extends StatelessWidget {
  final GithubRepository repository;
  const RepositoryInfo(this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(repository),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(repository.name),
        ),
      ),
    );
  }
}
