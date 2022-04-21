import 'package:flutter/material.dart';
import 'package:flutter_navigation/entities/post.dart';
import 'package:flutter_navigation/repositories/get_from_jsonplaceholder.dart';
import 'package:flutter_navigation/screens/comments.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController =
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
    final newItems = await GetPostsOnJsonPlaceholder(_pageSize, pageKey).call();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Section'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Post>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            animateTransitions: true,
            itemBuilder: (context, post, index) => TextButton(
              onPressed: () async {
                CommentsArgs args = CommentsArgs(post);
                final returnedId = await Navigator.pushNamed(
                  context,
                  '/comments',
                  arguments: args,
                );
                SnackBar snackBar = SnackBar(
                  content: Text('Você voltou do post $returnedId'),
                );

                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(snackBar);
              },
              child: ListTile(
                leading: Text('${post.id}'),
                title: Text(post.title),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
