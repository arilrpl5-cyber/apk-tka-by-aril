/// Model soal pilihan ganda Bank Soal TKA.
class QuestionModel {
  final String id;
  final String subjectId; // fisika, kimia, dst
  final String question;
  final List<String> options; // A-D
  final int correctIndex;
  final String explanation;
  final String difficulty; // Mudah / Sedang / Sulit
  final int xpReward;

  const QuestionModel({
    required this.id,
    required this.subjectId,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'Sedang',
    this.xpReward = 10,
  });
}

/// Model paket latihan per mapel.
class SubjectPackModel {
  final String subjectId;
  final String subjectName;
  final int totalQuestions;
  final int durationMinutes;
  final bool isFree;

  const SubjectPackModel({
    required this.subjectId,
    required this.subjectName,
    required this.totalQuestions,
    required this.durationMinutes,
    this.isFree = true,
  });
}
