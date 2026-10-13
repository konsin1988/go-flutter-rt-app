import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/user/state/user_provider.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialQuery = context.read<UserProvider>().searchPath;
    _controller = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final currentQuery = context.watch<UserProvider>().searchPath;
    if (_controller.text != currentQuery) {
      _controller.text = currentQuery;
    }
    return TextField(
      key: const ValueKey('user-search-field'),
      controller: _controller,
      autofocus: _controller.text.isEmpty,
      onChanged: (query) {
        context.read<UserProvider>().setSearchPath(query);
      },
      style: RTFontStyle.appTitle.value,
      decoration: const InputDecoration(
        hintText: 'Поиск коллег',
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }
}
