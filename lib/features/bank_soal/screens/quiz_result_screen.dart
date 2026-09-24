import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../models/question_model.dart';
import '../../../providers/app_provider.dart';

/// Hasil quiz: skor, benar/salah, review jawaban + dialog level-up jika ada.
class QuizResultScreen extends StatefulWidget {
  final SubjectPackModel pack;
  final List<QuestionModel> questions;
  final List<int?> answers;
  final bool autoFinished;

  const QuizResultScreen({
    super.key,
    required this.pack,
    required this.questions,
    required this.answers,
    this.autoFinished = false,
  });

  @override
  State<QuizResultScreen> createState() =>
      _QuizResultScreenState();
}

class _QuizResultScreenState
    extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msg = context
          .read<AppProvider>()
          .takePendingLevelUp();
      if (msg != null && mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Naik Level! 🎉'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text('Mantap!')),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.answers[i] ==
          widget.questions[i].correctIndex) {
        correct++;
      }
    }
    final score = widget.questions.isEmpty
        ? 0.0
        : correct / widget.questions.length * 100;
    final passed = score >= 70;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hasil • ${widget.pack.subjectName}',
            style:
                AppTextStyles.h3.copyWith(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: passed
                    ? AppColors.accentGreen
                    : AppColors.accentOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                      passed
                          ? Icons.emoji_events
                          : Icons.flag_outlined,
                      size: 56,
                      color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    passed ? 'Hebat!' : 'Terus Berlatih!',
                    style: AppTextStyles.h2
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    'Skor ${score.toStringAsFixed(0)} • $correct/${widget.questions.length} benar',
                    style: AppTextStyles.body
                        .copyWith(color: Colors.white),
                  ),
                  if (widget.autoFinished)
                    Text('Waktu habis — jawaban otomatis dikumpulkan',
                        style: AppTextStyles.caption.copyWith(
                            color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('+$correct koin • +${correct * 10} XP',
                      style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Ulangi',
                    outlined: true,
                    onPressed: () =>
                        Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Kembali ke Bank Soal',
                    onPressed: () {
                      Navigator.popUntil(context,
                          (r) => r.isFirst == false);
                      // Pop hingga ke BankSoalScreen (2 level).
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Review Jawaban',
                  style: AppTextStyles.h3),
            ),
            const SizedBox(height: 8),
            ...List.generate(widget.questions.length, (i) {
              final q = widget.questions[i];
              final a = widget.answers[i];
              final benar = a == q.correctIndex;
              return CustomCard(
                margin:
                    const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3),
                          decoration: BoxDecoration(
                            color: benar
                                ? AppColors.premiumTag
                                : const Color(
                                    0xFFFFEBEE),
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                          child: Text(
                            benar ? 'Benar' : 'Salah',
                            style: AppTextStyles.caption
                                .copyWith(
                              fontWeight:
                                  FontWeight.w800,
                              color: benar
                                  ? AppColors
                                      .premiumTagText
                                  : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Soal ${i + 1}',
                              style:
                                  AppTextStyles.caption),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(q.question,
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                        'Jawabanmu: ${a == null ? '-' : '${String.fromCharCode(65 + a)} • ${q.options[a]}'}',
                        style:
                            AppTextStyles.caption),
                    Text(
                        'Kunci: ${String.fromCharCode(65 + q.correctIndex)} • ${q.options[q.correctIndex]}',
                        style: AppTextStyles.caption
                            .copyWith(
                                color: AppColors
                                    .accentGreen,
                                fontWeight:
                                    FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(q.explanation,
                        style: AppTextStyles.body
                            .copyWith(fontSize: 13)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
