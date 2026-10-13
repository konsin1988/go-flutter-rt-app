import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/graphql/graphql_service.dart';
import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/features/user/data/user_repository.dart';
import 'package:rt_app/features/user/state/user_provider.dart';


class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key });

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  static const int _pageSize = 16;
  String _lastQuery = '';

  late final UserRepository _repository;
  late final ScrollController _scrollController;

  final List<SearchUser> _users = [];
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  Object? _error;

  int _currentRequestId = 0;

  @override
  void initState() {
    super.initState();

    _repository = UserRepository(GraphQLService().client);
    _scrollController = ScrollController()
      ..addListener(_onScroll);

    _loadMore();
  }

  void _onScroll() {
    if (!_hasMore || _isLoading) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore({bool isNewQuery = false}) async {
    if (!isNewQuery && (_isLoading || !_hasMore)) return;
    final requestId = ++_currentRequestId;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newUsers = await _repository.getSearchUsers(
        _lastQuery,
        _offset,
      );

      if (!mounted) return;

      // 3. CRITICAL: If a newer request has started since this one was fired, discard
      if (requestId != _currentRequestId) return;

      setState(() {
        _users.addAll(newUsers);
        _offset += _pageSize;
        _hasMore = newUsers.length == _pageSize;
      });
    } catch (error) {
      if (!mounted || requestId != _currentRequestId) return;

      setState(() => _error = error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleNewQuery(String newQuery) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _lastQuery = newQuery;
        _users.clear();
        _offset = 0;
        _hasMore = true;
        _error = null;
      });
      _loadMore(isNewQuery: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchPath = context.watch<UserProvider>().searchPath;
    if (searchPath != _lastQuery) {
      _handleNewQuery(searchPath);
    }

    if (_error != null && _users.isEmpty) {
      return Center(child: Text(_error.toString()));
    }

    if (_users.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return const Center(child: Text('Пользователи не найдены'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _users.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _users.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final user = _users[index];
        final photoUrl = user.photoURL;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            child: photoUrl == null || photoUrl.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.fio),
          onTap: () => context.push('/profile/user/${user.id}'),
        );
      },
    );
  }
}
