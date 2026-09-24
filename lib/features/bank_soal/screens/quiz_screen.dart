import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/bank_soal_data.dart';
import '../../../models/question_model.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/bank_soal_provider.dart';
import 'quiz_result_screen.dart';

/// Layar mengerjakan soal: timer, progress, opsi A-D, pembahasan langsung.
class QuizScreen extends StatefulWidget {
  final SubjectPackModel pack;
  final int startIndex;

  const QuizScreen({super.key, required this.pack, this.startIndex = 0});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuestionModel> questions;
  late int current;
  int? selected;
  bool showExplanation = false;
  late List<int?> answers;
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    questions =
        BankSoalData.questionsBySubject(widget.pack.subjectId);
    current = widget.startIndex.clamp(0, questions.length - 1);
    answers = List.filled(questions.length, null);
    remaining = Duration(minutes: widget.pack.durationMinutes);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds <= 0) {
        _finish(auto: true);
        return;
      }
      setState(
          () => remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _choose(int i) {
    if (showExplanation) return;
    setState(() {
      selected = i;
      answers[current] = i;
      showExplanation = true;
    });
  }

  void _next() {
    if (current < questions.length - 1) {
      setState(() {
        current++;
        selected = answers[current];
        showExplanation = selected != null;
      });
    } else {
      _finish();
    }
  }

  void _prev() {
    if (current > 0) {
      setState(() {
        current--;
        selected = answers[current];
        showExplanation = selected != null;
      });
    }
  }

  void _finish({bool auto = false}) {
    timer?.cancel();
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctIndex) correct++;
    }
    final score = questions.isEmpty
        ? 0.0
        : (correct / questions.length * 100);

    // Simpan skor + tambah XP & koin.
    context
        .read<BankSoalProvider>()
        .submitResult(widget.pack.subjectId, score);
    final app = context.read<AppProvider>();
    final gainedXp = correct * 10;
    final gainedCoins = correct * 5;
    app.earn(
        xp: gainedXp,
        coins: gainedCoins,
        source:
            'Quiz ${widget.pack.subjectName}: $correct/${questions.length} benar');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          pack: widget.pack,
          questions: questions,
          answers: answers,
          autoFinished: auto,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    final mm = (remaining.inMinutes).toString().padLeft(2, '0');
    final ss = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.pack.subjectName} • ${current + 1}/${questions.length}',
            style:
                AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('$mm:$ss',
                        style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: (current + 1) / questions.length,
                minHeight: 8,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation(
                    AppColors.primaryBlue),
              ),
            ),
            const SizedBox(height: 14),
            Text('Soal ${current + 1}',
                style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBlue)),
            const SizedBox(height: 6),
            Text(q.question,
                style: AppTextStyles.h3.copyWith(height: 1.4)),
            const SizedBox(height: 4),
            Text(q.difficulty,
                style: AppTextStyles.caption),
            const SizedBox(height: 14),
            ...List.generate(q.options.length, (i) {
              final isCorrect = i == q.correctIndex;
              final isSelected = i == selected;
              Color border = const Color(0xFFE5E7EB);
              Color bg = Colors.white;
              if (showExplanation && isCorrect) {
                border = AppColors.accentGreen;
                bg = const Color(0xFFE8F5E9);
              } else if (showExplanation && isSelected && !isCorrect) {
                border = Colors.red;
                bg = const Color(0xFFFFEBEE);
              } else if (isSelected) {
                border = AppColors.primaryBlue;
                bg = AppColors.primaryLight;
              }
              return GestureDetector(
                onTap: () => _choose(i),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: border,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(q.options[i],
                              style: AppTextStyles.body)),
                      if (showExplanation && isCorrect)
                        const Icon(Icons.check_circle,
                            color: AppColors.accentGreen),
                      if (showExplanation &&
                          isSelected &&
                          !isCorrect)
                        const Icon(Icons.cancel,
                            color: Colors.red),
                    ],
                  ),
                ),
              );
            }),
            if (showExplanation) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('Pembahasan',
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(q.explanation,
                        style: AppTextStyles.body
                            .copyWith(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('+${q.xpReward} XP jika benar',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Kembali',
                    outlined: true,
                    onPressed:
                        current == 0 ? null : _prev,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: current == questions.length - 1
                        ? 'Selesai'
                        : 'Lanjut',
                    onPressed:
                        selected == null ? null : _next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Nomor soal
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(questions.length, (i) {
                final answered = answers[i] != null;
                final isNow = i == current;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = i;
                      selected = answers[i];
                      showExplanation = selected != null;
                    });
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isNow
                          ? AppColors.primaryBlue
                          : answered
                              ? AppColors.accentGreen
                              : Colors.white,
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text('${i + 1}',
                        style: AppTextStyles.body.copyWith(
                          color: (isNow || answered)
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
