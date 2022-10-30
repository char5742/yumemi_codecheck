import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yumemi_codecheck/models/repository.dart';
import 'package:yumemi_codecheck/pages/components.dart';
import 'package:yumemi_codecheck/pages/detail.dart';
import 'package:yumemi_codecheck/provider/github.dart';
import 'package:yumemi_codecheck/provider/network.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    return Scaffold(
      bottomSheet: Visibility(
        visible: !ref.watch(networkProvider),
        child: Container(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          height: 24,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            '接続していません',
          ),
        ),
      ),
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
                if (textController.text.isEmpty) return;
                primaryFocus?.unfocus();
                ref
                    .read(repositoriesProvider.notifier)
                    .fetchFirst(textController.text);
              },
            ),
          ),
          const RepositoryItems(),
        ],
      ),
    );
  }
}

class RepositoryItems extends HookConsumerWidget {
  const RepositoryItems({super.key});

  @override
  Widget build(context, ref) {
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
    if (ref.watch(repositoriesProvider).isLoading) {
      return const Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else if (ref.watch(repositoriesProvider).error != null) {
      return const ErrorScreen();
    } else {
      final repositoryInfoList = ref
          .watch(repositoriesProvider)
          .repositories
          .map(RepositoryInfo.new)
          .toList();
      return Visibility(
        visible: repositoryInfoList.isNotEmpty,
        child: Expanded(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () =>
                ref.read(repositoriesProvider.notifier).fetchRetry(),
            child: ListView(
              controller: scrollController,
              // ClampingScrollPhysicsでは正常にRefreshIndicatorが動作しないため
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: repositoryInfoList,
            ),
          ),
        ),
      );
    }
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
