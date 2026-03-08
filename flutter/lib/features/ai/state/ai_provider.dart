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

  // Conversation Setter
  void selectConversation(int id) {
    _selectedId = id;
    notifyListeners();
  }

  // Conversation List Setter
  void setConversationList(List<ConversationListItem> list) {
    _conversationList = list;
    notifyListeners();
  }

  // Create new conversation
  void clearCurrentConversation() {
  _currentConversation = null;
  notifyListeners();
  }

  // CreateMessage
  Future<void> sendMessage(String content) async {
    if (_currentConversation == null) return;

    final tempMessage = Message(
      ID: -1,
      ConversationID: _currentConversation!.ID,
      Role: "USER",
      Content: content,
      CreatedAt: DateTime.now(),
    );
    
    _currentConversation!.Messages.add(tempMessage);
    notifyListeners();

    try {
      final message = await _repo.createMessage(
	conversationId: _currentConversation!.ID,
	content: content,
      );
      _currentConversation!.Messages.remove(tempMessage);
      _currentConversation!.Messages.add(message);
    } catch (e) {
      _currentConversation!.Messages.remove(tempMessage);
      rethrow;
    }

    notifyListeners();
  }
}
