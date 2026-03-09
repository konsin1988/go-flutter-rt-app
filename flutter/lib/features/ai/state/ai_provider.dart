import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:rt_app/features/ai/data/ai_repo.dart';
import 'package:rt_app/features/ai/data/ai_models.dart';


class AiProvider extends ChangeNotifier{
  final AiRepository _repo;

  List<ConversationListItem> _conversationList = [];
  int? _selectedId;
  Conversation? _currentConversation; 
  bool loading = false;
  StreamSubscription? _streamSub;

  List<ConversationListItem> get conversationList => _conversationList;
  int? get selectedId => _selectedId;
  Conversation? get currentConversation => _currentConversation;
  StreamSubscription? get streamSub => _streamSub;

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
    if (_currentConversation == null) {
      try {
        final message = await _repo.createMessage(
          conversationId: null,
          content: content,
        );
        debugPrint("Message: ${message}");
	selectConversation(message.ConversationID);
	loadConversation(message.ConversationID);
        _currentConversation!.Messages.add(message);
      } catch (e) {
	debugPrint("Error from SendMessage: ${e}"); 
        rethrow;
      }
    }

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
      debugPrint("Message: ${message}");
      _currentConversation!.Messages.remove(tempMessage);
      _currentConversation!.Messages.add(message);
      _createAssistantMessage();
      _subscribeToStream(message.ID, message.ConversationID);
    } catch (e) {
      _currentConversation!.Messages.remove(tempMessage);
      rethrow;
    }

    notifyListeners();
  }


  // Create Assistant Message
  void _createAssistantMessage() {
    _currentConversation!.Messages.add(
      Message(
        ID: -2,
        ConversationID: _currentConversation!.ID,
        Role: "ASSISTANT",
        Content: "",
        CreatedAt: DateTime.now(),
      ),
    );
  
    notifyListeners();
  }

  //Append Chunk
  void _appendChunk(String chunk) {
    final messages = _currentConversation!.Messages;
    final last = messages.last;

    messages[messages.length - 1] = last.copyWith(
      Content: last.Content + chunk,
    );
  }

  //subscribeToStream
  void _subscribeToStream(int messageId, int conversationId) {
    _streamSub?.cancel();

    _streamSub = _repo
      .messageStream(
        messageId: messageId,
        conversationId: conversationId,
      )
      .listen((result) {

	if (result.hasException) {
    	  debugPrint(result.exception.toString());
    	  return;
    	}

    	final data = result.data?['messageStream'];
    	if (data == null) return;

    	final chunk = data['chunk'];
    	final done = data['done'];

    	debugPrint("chunk: $chunk done: $done");

    	_appendChunk(chunk);
    	
	notifyListeners();

    	if (done) {
    	  debugPrint("Stream finished");
    	  _streamSub?.cancel();
    	}

      });
  } 
}
