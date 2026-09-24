import 'package:flutter/material.dart';
import '../data/bank_soal_data.dart';
import '../models/question_model.dart';

/// Provider untuk progres Bank Soal + Quiz + XP.
class BankSoalProvider extends ChangeNotifier {
  final Map<String, double> _bestScore = {}; // subjectId -> 0..100
  final Map<String, int> _attempts = {};

  double bestScore(String subjectId) => _bestScore[subjectId] ?? 0;
  int attempts(String subjectId) => _attempts[subjectId] ?? 0;
  int get totalAttempts => _attempts.values.fold(0, (a, b) => a + b);

  double get averageScore {
    if (_bestScore.isEmpty) return 0;
    final sum = _bestScore.values.fold(0.0, (a, b) => a + b);
    return sum / _bestScore.length;
  }

  void submitResult(String subjectId, double score) {
    _attempts[subjectId] = attempts(subjectId) + 1;
    final prev = bestScore(subjectId);
    if (score > prev) _bestScore[subjectId] = score;
    notifyListeners();
  }

  List<SubjectPackModel> get packs => BankSoalData.packs;
}
