import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:rt_app/features/ai/data/ai_repo.dart';
import 'package:rt_app/features/ai/data/ai_models.dart';


class AiProvider extends ChangeNotifier{
  final AiRepository _repo;

  List<ConversationListItem> _conversationList = [];
  int? _selectedId;
  Conversation? _currentConversation; 
  bool loading = false;

  List<ConversationListItem> get conversationList => _conversationList;
  int? get selectedId => _selectedId;
  Conversation? get currentConversation => _currentConversation;

  AiProvider(this._repo){
    debugPrint("AiProvider created;");
    loadConversationList();

  }

  ConversationListItem? get selectedConversation {
    if (_conversationList.isEmpty) return null;
    if (_selectedId == null) return _conversationList.first;
    return _conversationList.firstWhere(
      (c) => c.ID == _selectedId,
      orElse: () => _conversationList.first,
    );
  }

  // Conversation List
  Future<void> loadConversationList() async {
    loading = true;
    notifyListeners();

    try {
      _conversationList = await _repo.ConversationList();
      if (_conversationList.isNotEmpty && _selectedId == null) {
        _selectedId = _conversationList.first.ID;
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Conversation by ID
  Future<Conversation> loadConversation(int id) async {
    final conversation = await _repo.conversationById(id); 

    _currentConversation = conversation;
    debugPrint('Conversation: ${conversation.Messages}');
    notifyListeners();

    return conversation;
  }

  void selectConversation(int id) {
    _selectedId = id;
    notifyListeners();
  }

  void setConversationList(List<ConversationListItem> list) {
    _conversationList = list;
    notifyListeners();
  }
}
