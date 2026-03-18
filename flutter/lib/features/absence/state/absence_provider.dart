import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:rt_app/features/absence/data/absence_repo.dart';
import 'package:rt_app/features/absence/data/absence_models.dart';


class AbsenceProvider extends ChangeNotifier{
  final AbsenceRepository _repo;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Absence? _absence;
  String _prompt = "";

  Absence? get getAbsence => _absence; 
  String get getPrompt => _prompt; 


  AbsenceProvider(this._repo){
    debugPrint("AbsenceProvider created;");
    //loadConversationList();

  }

  // Conversation Setter
  void setAbsence(Absence absence) {
    _absence = absence;
    notifyListeners();
  }


  // CreateMessage
  Future<void> createAbsenceData(String prompt) async {
    try {
      debugPrint("PROMPT: ${prompt}");

      _isLoading = true;
      notifyListeners();

      final absence = await _repo.createAbsenceData(
        prompt: prompt,
      );
      debugPrint("ABSENCE: ${absence}");
      setAbsence(absence);
      _error = null;
    } catch (e) {
      debugPrint("ERROR: ${e}");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }
}
