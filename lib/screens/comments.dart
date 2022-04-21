import 'package:flutter/material.dart';
import 'package:flutter_navigation/entities/comment.dart';
import 'package:flutter_navigation/entities/post.dart';
import 'package:flutter_navigation/repositories/get_from_jsonplaceholder.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommentsArgs {
  final Post post;

  CommentsArgs(this.post);
}

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  static const _pageSize = 20;

  bool loadedList = false;

  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey) async {
    final args = ModalRoute.of(context)!.settings.arguments as CommentsArgs;

    final newItems = await GetCommentsOnJsonPlaceholder(
      _pageSize,
      pageKey,
      args.post.id,
    ).call();
    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = ++pageKey;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CommentsArgs;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, args.post.id);
          },
        ),
        title: const Text('Comment Section'),
      ),
      body: infiniteList(),
    );
  }

  RefreshIndicator infiniteList() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Comment>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Comment>(
          animateTransitions: true,
          itemBuilder: (context, comments, index) => ListTile(
            leading: Text('${comments.id}'),
            title: Text(comments.body),
            trailing: Text('${comments.postId}'),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
