/// Model bab materi yang bisa dibuka.
class ChapterModel {
  final String id; // misal: matematika-aljabar
  final String subjectId;
  final String subjectName;
  final String title;
  final int index; // urutan bab
  final int xpReward;
  final int durationMinutes;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.title,
    required this.index,
    this.xpReward = 20,
    this.durationMinutes = 10,
  });
}

/// Isi materi per bab.
class ChapterContentModel {
  final String chapterId;
  final String summary; // rangkuman 2-3 kalimat
  final List<String> keyPoints; // poin penting
  final String example; // contoh + cara
  final String tip; // tips ujian

  const ChapterContentModel({
    required this.chapterId,
    required this.summary,
    required this.keyPoints,
    required this.example,
    required this.tip,
  });
}

/// Satu event perolehan poin (riwayat).
class PointEvent {
  final String title;
  final int xp;
  final int coins;
  final DateTime date;

  const PointEvent({
    required this.title,
    required this.xp,
    required this.coins,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'xp': xp,
        'coins': coins,
        'date': date.toIso8601String(),
      };

  factory PointEvent.fromJson(Map<String, dynamic> j) => PointEvent(
        title: (j['title'] ?? '') as String,
        xp: (j['xp'] ?? 0) as int,
        coins: (j['coins'] ?? 0) as int,
        date: DateTime.tryParse((j['date'] ?? '') as String) ??
            DateTime.now(),
      );
}
