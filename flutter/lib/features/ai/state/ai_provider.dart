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

  int? editingConversationId;
  String? pendingTitle;

  AiProvider(this._repo){
    debugPrint("AiProvider created;");
    loadConversationList();

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
  _selectedId = null;
  notifyListeners();
  }

  // DeleteConversation
  Future<void> deleteConversation(int id) async {
    await _repo.DeleteConversation(id);
    final updatedList = _conversationList.where((item) => item.ID != id).toList();
    
    if (_currentConversation != null) {
      if (id == _currentConversation!.ID) {
	_currentConversation = null;
      }
    }
    setConversationList(updatedList);
    notifyListeners();
  }

  // Toggle Pinned Conversation
  Future<void> togglePinnedConversation(int id) async {
    int index = _conversationList.indexWhere((item) => item.ID == id);
    if (index != -1) {
      await _repo.TogglePinnedConversation(id, _conversationList[index].IsPinned);
      _conversationList = await _repo.ConversationList();
    }
    
    setConversationList(_conversationList);  
    notifyListeners();
  }

  // StartRename
  Future<void> startRename(int id, String currentTitle) async {
    editingConversationId = id;
    pendingTitle = currentTitle;
    notifyListeners();
  }
  

  // Update Conversation Title
  Future<void> updateConversationTitle(int id, String newTitle) async {
    int index = _conversationList.indexWhere((item) => item.ID == id);
    try {
      editingConversationId = null;
      await _repo.RenameConversation(id, newTitle);
      conversationList[index] = conversationList[index].copyWith(Title: newTitle);
    } finally {
      cancelRename();
    }
    notifyListeners();
  }
 
 // Cancel Rename
  void cancelRename() {
    editingConversationId = null;
    pendingTitle = null;
    notifyListeners();
  }

  // CreateMessage
  Future<void> sendMessage(String content) async {
    bool isNew = false;
    if (_currentConversation == null) {
      isNew = true;
      _createOptimisticConversation();
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
      final int? realConvId = isNew ? null : _currentConversation!.ID;
      debugPrint("REAL CONVERSATION ID:  ------- ${realConvId}");
      final message = await _repo.createMessage(
        conversationId: realConvId,
        content: content,
      );
      debugPrint("Message: ${message}");
      _currentConversation!.ID = message.ConversationID;
      _currentConversation!.Messages.remove(tempMessage);
      _currentConversation!.Messages.add(message);
      _createAssistantMessage();
      _subscribeToStream(message.ID, message.ConversationID);
      loadConversationList();
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

  // Create Optimistic conversation 
  void _createOptimisticConversation() {
    final now = DateTime.now();
    final fakeConvId = -2;
    final conv = Conversation(
      ID: fakeConvId,
      Title: "",
      CreatedAt: now,
      UpdatedAt: now,
      Messages: [],
    ); 
    _currentConversation = conv;
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
