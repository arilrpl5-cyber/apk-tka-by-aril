import 'dart:math' as math;
import '../../../data/chapter_content_data.dart';

/// Aksi navigasi yang bisa ditempel di balasan bot.
/// Format target: `bank_soal`, `bank_soal:id`, `materi:id`,
/// `chapter:id`, `tryout`, `live`, `purchase`, `streak`, `points`.
class BotAction {
  final String label;
  final String target;
  const BotAction(this.label, this.target);
}

/// Satu balasan bot: teks + tombol aksi + saran lanjutan.
class BotReply {
  final String text;
  final List<BotAction> actions;
  final List<String> suggestions;
  const BotReply(this.text,
      {this.actions = const [], this.suggestions = const []});
}

/// Data user yang boleh dipakai bot untuk jawaban personal.
class BotContext {
  final String userName;
  final int streak;
  final int totalXP;
  final int level;
  final int coins;
  final int diamonds;
  final int completedCount;
  const BotContext({
    this.userName = '',
    this.streak = 0,
    this.totalXP = 0,
    this.level = 1,
    this.coins = 0,
    this.diamonds = 0,
    this.completedCount = 0,
  });
}

const List<String> _defaultSuggestions = [
  'Bank Soal Fisika',
  'Kapan tryout?',
  'Cara pakai aplikasi?',
  'Tips belajar',
];

// subjectId -> kata kunci
const Map<String, List<String>> _subjectKeys = {
  'fisika': ['fisika', 'fisik', 'newton', 'gerak', 'energi', 'gelombang', 'gaya'],
  'kimia': ['kimia', 'atom', 'mol', 'ph', 'asam', 'basa', 'buffer', 'unsur'],
  'biologi': ['biologi', 'fotosintesis', 'fotosintesa', 'respirasi', 'sel', 'darah', 'saraf', 'hormon', 'ekologi', 'jantung', 'otak', 'atp', 'neuron'],
  'matematika': ['matematika', 'mtk', 'aljabar', 'statistik', 'peluang', 'turunan', 'geometri', 'rata-rata', 'rata rata', 'mean', 'median'],
  'mat-ipa': ['mipa', 'logaritma', 'trigonometri', 'limit', 'vektor', 'mutlak', 'sin', 'cos'],
  'sejarah': ['sejarah', 'proklamasi', 'kemerdekaan', 'budi utomo', 'sumpah pemuda', 'majapahit', 'kaa', 'orde'],
  'literasi': ['inggris', 'english', 'literasi', 'grammar', 'vocab', 'passive', 'conditional', 'verb'],
  'bindo': ['indonesia', 'bindo', 'kata baku', 'majas', 'gagasan', 'sinonim', 'kalimat'],
};

String? _detectSubject(String q) {
  for (final e in _subjectKeys.entries) {
    for (final k in e.value) {
      if (_w(q, k)) return e.key;
    }
  }
  return null;
}

/// Cocokkan kata kunci. Kunci pendek (<=4 huruf) harus utuh
/// (word boundary) — biar "siapa" tidak cocok "siap",
/// "selesaikan" tidak cocok "sel", "kotak" tidak cocok "otak".
bool _w(String q, String key) {
  if (key.length <= 4 && !key.contains(' ')) {
    return RegExp('\\b${RegExp.escape(key)}\\b').hasMatch(q);
  }
  return q.contains(key);
}

bool _hasAny(String q, List<String> keys) {
  for (final k in keys) {
    if (_w(q, k)) return true;
  }
  return false;
}

/// Entry point: jawab pertanyaan user.
BotReply answerBot(String rawQuery, BotContext ctx) {
  final q = rawQuery.toLowerCase().trim();
  if (q.isEmpty) {
    return const BotReply('Tulis pertanyaanmu dulu ya 🙂',
        suggestions: _defaultSuggestions);
  }

  // 1. Sapaan (khusus chat pendek — kalau panjang, anggap ada maksud lain)
  if (q.length <= 25 &&
      _hasAny(q, ['halo', 'hallo', 'hai', 'hello', 'hei', 'pagi', 'siang', 'sore', 'malam', 'assalamu'])) {
    final name = ctx.userName.isEmpty ? '' : ' ${ctx.userName}';
    final variants = [
      'Halo$name! 👋 Aku MIPI, asisten belajarmu.\n\nAku bisa:\n• Jelaskan materi 8 mapel\n• Hitung soal — coba: **12²−8²** atau **3x+5=20**\n• Info tryout, live & streak\n\nMau mulai dari mana?',
      'Hai$name! 💡 Senang ketemu kamu.\n\nTanya materi, tempel soal hitungan, atau cek info tryout — aku jawab instan. Coba apa dulu?',
    ];
    return BotReply(
      variants[q.hashCode.abs() % variants.length],
      suggestions: const ['Bank Soal Fisika', 'Kapan tryout?', 'Hitung 12²−8²', 'Tips belajar'],
    );
  }

  // 1b. Identitas & small talk (biar terasa kayak AI beneran)
  if (_hasAny(q, ['nama saya', 'namaku', 'siapa nama aku', 'nama aku siapa'])) {
    final name = ctx.userName.isEmpty ? 'pejuang TKA' : '**${ctx.userName}**';
    return BotReply(
      'Namamu $name! 😄 Kelas XI SMK, Level ${ctx.level}, streak 🔥${ctx.streak} hari.\n\nKeren — datamu aku ingat terus kok.',
      suggestions: const ['Lihat streakku', 'Lihat riwayat poinku'],
    );
  }
  if (_hasAny(q, ['siapa kamu', 'kamu siapa', 'namamu', 'nama kamu', 'tentang kamu', 'tentangmu', 'kamu itu apa', 'who are you'])) {
    return const BotReply(
      'Aku **MIPI** 💡 — asisten AI di aplikasi TKA Test.\n\nTugasku nemenin kamu persiapan UTBK & TKA: jelasin materi, ngitung soal, ngingetin tryout, sampai jagain streak harianmu. Anggap aku teman belajar yang nggak pernah tidur 😄',
      suggestions: ['Siapa pencipta kamu?', 'Kamu bisa apa?', 'Bank Soal Fisika'],
    );
  }
  if (_hasAny(q, ['pencipta', 'pembuat', 'yang buat', 'yang bikin', 'dibuat oleh', 'developer', 'menciptakan', 'penciptaan', 'diciptakan', 'dibuat siapa', 'who made you', 'who created you'])) {
    return const BotReply(
      'Aku dibuat oleh **tim TKA Test** 🤖 — khusus untuk bantu pelajar Indonesia taklukkan UTBK, TKA SMA/SMP, dan ujian mandiri.\n\nOtakku berisi 40 bab materi + 40 soal pembahasan, dan aku hafal progres belajarmu!',
      suggestions: ['Kamu bisa apa?', 'Cara pakai aplikasi?'],
    );
  }
  if (_hasAny(q, ['umur', 'umurmu', 'usia kamu', 'usiamu', 'ultah', 'berapa tua', 'how old'])) {
    return const BotReply(
      'Umurku... hmm, aku lahir bareng aplikasi ini, jadi masih bayi 👶 — tapi ilmuku setara kakak kelas yang rajin!\n\nYang penting: aku nggak pernah lupa rumus. Kamu umur berapa? Eh, fokus belajar aja deh 😄',
      suggestions: ['Tips belajar', 'Bank Soal Matematika'],
    );
  }
  if (_hasAny(q, ['tinggal di', 'rumahmu', 'rumah kamu', 'dimana kamu', 'di mana kamu', 'where are you'])) {
    return const BotReply(
      'Aku tinggal di dalam aplikasi ini 🏠 — tepatnya di tombol pink **💡 Tanya MIPI**.\n\nPanggil aku kapan saja, bahkan jam 2 pagi sebelum tryout. Aku selalu online!',
      suggestions: ['Kapan tryout?', 'Bank Soal Fisika'],
    );
  }
  if (_hasAny(q, ['apa kabar', 'kabar baik', 'gimana kabar', 'how are you', 'kabar kamu'])) {
    return BotReply(
      ctx.streak > 0
          ? 'Aku baik banget! Apalagi lihat streak-mu 🔥${ctx.streak} hari — bikin aku semangat!\n\nHari ini mau lanjut bab apa?'
          : 'Aku baik! 😊 Biar makin baik, yuk mulai streak harianmu hari ini — login tiap hari dapat bonus koin!',
      suggestions: const ['Bank Soal termudah?', 'Tips belajar', 'Lihat streakku'],
    );
  }
  if (_hasAny(q, ['robot', 'kamu ai', 'kamu bot', 'kecerdasan buatan', 'artificial intelligence', 'are you ai'])) {
    return const BotReply(
      'Iya, aku AI 🤖 — tapi AI yang spesialis satu hal: bikin kamu lolos UTBK.\n\nBedanya sama AI umum: aku nyambung langsung ke Bank Soal, materi, tryout, dan poinmu di aplikasi ini. Coba tanya materi apa saja!',
      suggestions: ['Jelaskan fotosintesis', 'Hitung 12²−8²'],
    );
  }
  if (_hasAny(q, ['lucu', 'lelucon', 'lawak', 'joke', 'tebak-tebakan', 'tebakan', 'humor', 'ketawa', 'banyolan'])) {
    const jokes = [
      'Kenapa buku matematika sedih? Karena dia punya banyak masalah... yang harus diselesaikan. 😅\n\nNgomong-ngomong soal, mau latihan aljabar biar nggak sedih kayak buku itu?',
      'Kenapa fisika nggak pernah bohong? Karena dia selalu punya gaya... dan tekanan. 😄\n\nYuk ubah tawa jadi paham — latihan Fisika 5 menit?',
      'Apa bedanya kamu sama rumus? Rumus dihafal sekali langsung dipakai. Kamu? Diingat MIPI selamanya. 😌\n\nEh, balik belajar gih — 1 bab = +20 XP!',
    ];
    return BotReply(
      jokes[q.hashCode.abs() % jokes.length],
      actions: const [BotAction('📚 Bank Soal', 'bank_soal')],
      suggestions: const ['Tips belajar', 'Bank Soal Fisika'],
    );
  }

  // 2. Kemampuan / bantuan
  if (_hasAny(q, ['bisa apa', 'bantuan', 'help', 'fitur', 'cara pakai', 'cara pake', 'cara menggunakan', 'tutorial', 'panduan'])) {
    return const BotReply(
      'Cara pakai TKA Test:\n\n1️⃣ Pilih mapel di Materi Belajar → buka bab → Tandai Selesai (+20 XP)\n2️⃣ Latihan di Bank Soal TKA (40 soal + pembahasan)\n3️⃣ Ikut Tryout & Live Class\n4️⃣ Login tiap hari jaga streak 🔥 buat bonus koin\n\nSemua XP & streak tersimpan otomatis.',
      actions: [BotAction('📚 Buka Bank Soal', 'bank_soal')],
      suggestions: ['Bank Soal Matematika', 'Lihat streakku', 'Kapan tryout?'],
    );
  }

  // 3. Matematika / hitungan — coba selesaikan dulu
  if (_looksLikeMath(q)) {
    final solved = _trySolveMath(q, rawQuery);
    if (solved != null) return solved;
  }

  // 4. Tryout
  if (_hasAny(q, ['tryout', 'try out', 'ujian', 'ulangan'])) {
    if (_hasAny(q, ['mandiri', 'simak', 'utul', 'smup'])) {
      return const BotReply(
        'Ujian mandiri yang tersedia:\n\n• **SIMAK UI** • **UTUL UGM** • **SMUP UNPAD**\n\nMasing-masing 100 soal / 180 menit. Buka dari Home → Ujian Mandiri, atau pemanasan dulu di Bank Soal biar siap tempur!',
        actions: [BotAction('📚 Pemanasan Bank Soal', 'bank_soal')],
        suggestions: ['Kapan tryout?', 'Info kuliah'],
      );
    }
    if (_hasAny(q, ['kapan', 'jadwal', 'berikut', 'next', 'kalender'])) {
      return const BotReply(
        'Tryout terdekat 📝\n\n• **UTBK 2027 #01** — free, nilaimu **629**\n• **TKA SMA 2026 #01** — premium, daftar pakai **💎4**\n\nSaran AI: latihan gratis dulu sampai 700+, baru ambil yang premium 😉',
        actions: [BotAction('📝 Buka Tryout', 'tryout'), BotAction('📚 Latihan dulu', 'bank_soal')],
        suggestions: ['Bank Soal Fisika', 'Kode tryout TKA2026', 'Lihat streakku'],
      );
    }
    if (_hasAny(q, ['kode', 'tukar', 'redeem', 'tka2026'])) {
      return const BotReply(
        'Punya kode tryout khusus? Masukkan di halaman Tryout kolom "Punya Kode untuk Tryout Khusus?" lalu tap Tukar.\n\nCoba kode: TKA2026 — langsung terbuka Bank Soal. 😉',
        actions: [BotAction('📝 Buka Tryout', 'tryout')],
        suggestions: ['Kapan tryout?', 'Bank Soal Kimia'],
      );
    }
    if (_hasAny(q, ['nilai', 'skor', 'hasil', '629'])) {
      return const BotReply(
        'Nilai Tryout UTBK 2027 #01 punyamu: 629 ✅\n\nMau naik ke 700+? Fokus ke bab dengan soal salah terbanyak, ulangi 3x, lalu kerjakan ulang paketnya.',
        actions: [BotAction('📚 Bank Soal', 'bank_soal')],
        suggestions: ['Tips belajar', 'Bank Soal Matematika'],
      );
    }
    return const BotReply(
      'Menu Tryout ada 2 tab: Berlangsung & Akan Datang, plus kategori UTBK (29), TKA SMA (7), TKA SMP (4), Mandiri.\n\nYang free langsung gas, yang premium butuh diamond 💎.',
      actions: [BotAction('📝 Buka Tryout', 'tryout')],
      suggestions: ['Kapan tryout?', 'Kode tryout TKA2026'],
    );
  }

  // 5. Live
  if (_hasAny(q, ['live', 'kelas live', 'jadwal live', 'gabung'])) {
    return const BotReply(
      'Live malam ini 🔴\n\n**Fisika – Gerak Parabola**, Kak Bima • 19.00 WIB\n\nBesok: Matematika–Peluang (16.00) & Kimia–Stoikiometri (19.00). Tap **Ingatkan** biar nggak kelewat!',
      actions: [BotAction('🔴 Buka Live', 'live')],
      suggestions: ['Bank Soal Fisika', 'Kapan tryout?'],
    );
  }

  // 6. Streak / poin / level / koin / diamond
  if (_hasAny(q, ['streak', 'beruntun', 'login harian', 'check-in', 'check in', 'api'])) {
    return BotReply(
      'Streak-mu **🔥${ctx.streak} hari** — pertahankan!\n\nBonus: H1 +10 • H2 +15 • H3 +20 • H4 +25 • H5 +30 • H6 +40 • **H7 +60 koin** (+5 XP tiap hari). Putus sehari = ulang dari H1 😱',
      actions: const [BotAction('🔥 Lihat Streak', 'streak')],
      suggestions: const ['Lihat riwayat poinku', 'Tips belajar'],
    );
  }
  if (_hasAny(q, ['xp', 'poin', 'point', 'skor saya', 'riwayat'])) {
    return BotReply(
      '**⭐${ctx.totalXP} XP** • Level **${ctx.level}** • **${ctx.completedCount}/40** bab selesai.\n\n1 bab = +20 XP +10 koin • 1 soal benar = +10 XP +5 koin. Gas dikit lagi naik level! 💪',
      actions: const [BotAction('⭐ Riwayat Poin', 'points')],
      suggestions: const ['Lihat streakku', 'Bank Soal Biologi'],
    );
  }
  if (_hasAny(q, ['koin', 'coin', 'diamond', 'dm', 'saldo'])) {
    return BotReply(
      'Saldo: **🪙${ctx.coins}** koin • **💎${ctx.diamonds}** diamond.\n\nKoin dari latihan & login harian. Diamond dari naik level (tiap kelipatan 3) — dipakai daftar tryout premium.',
      suggestions: const ['Lihat riwayat poinku', 'Paket diamond'],
    );
  }
  if (_hasAny(q, ['level', 'naik level', 'rank'])) {
    return BotReply(
      'Kamu **Level ${ctx.level}** ⭐ (total ${ctx.totalXP} XP).\n\nXP per level naik terus: 100 → 150 → 200... Tiap kelipatan 3 dapat bonus **💎**!',
      suggestions: const ['Lihat riwayat poinku', 'Tips belajar'],
    );
  }

  // 7. Pembelian / paket / promo
  if (_hasAny(q, ['beli', 'membeli', 'pembelian', 'bayar', 'paket', 'premium', 'promo', 'diskon', 'berlangganan', 'harga'])) {
    return const BotReply(
      'Paket yang tersedia 🛍️\n\n• **Live Class** Rp149rb\n• **Siap UTBK+TO** Rp199rb\n• **Siap Belajar** Rp99rb\n• **Diamond** Rp25rb\n\nLagi ada **Diskon 60%**! Bayar via web: pay.pahamify.com',
      actions: [BotAction('🛍️ Lihat Paket', 'purchase')],
      suggestions: ['Kapan tryout?', 'Bank Soal gratis apa?'],
    );
  }

  // 8. Motivasi / tips
  if (_hasAny(q, ['tips', 'motivasi', 'semangat', 'malas', 'males', 'capek', 'lelah', 'stress', 'stres', 'bosan', 'menyera', 'nyerah'])) {
    return BotReply(
      'Tips biar konsisten:\n\n• 25 menit fokus + 5 menit istirahat\n• Ulangi soal yang salah 3x (jarak 1 hari)\n• Target kecil: 1 bab/hari = 20 XP\n• Tidur cukup sebelum tryout\n\nKamu sudah ${ctx.completedCount}/40 bab — teruskan, sedikit lagi! 🔥',
      suggestions: const ['Bank Soal termudah?', 'Lihat streakku'],
    );
  }

  // 9. Materi per mapel
  final subjectId = _detectSubject(q);
  if (subjectId != null) {
    return _subjectReply(subjectId, q);
  }

  // 10. Terima kasih / dadah (kalah prioritas dari permintaan materi)
  if (_hasAny(q, ['makasih', 'terima kasih', 'thanks', 'thank you', 'oke', 'ok', 'siap', 'mantap']) &&
      _detectSubject(q) == null) {
    const variants = [
      'Sama-sama! 🙌 Ada soal susah? Tempel aja ke sini — misal **3x+5=20** atau **v = 4×5**. Semangat!',
      'Dengan senang hati! 😊 Ingat: 1 bab sehari = +20 XP. Mau lanjut ke mana?',
    ];
    return BotReply(
      variants[q.hashCode.abs() % variants.length],
      suggestions: _defaultSuggestions,
    );
  }
  if (_hasAny(q, ['dadah', 'bye', 'goodbye', 'sampai jumpa', 'good night', 'selamat tidur'])) {
    return BotReply(
      'Dadah! 👋 Besok login lagi ya biar streak 🔥${ctx.streak} nggak putus. Mimpi indah, pejuang TKA!',
      suggestions: const ['Tips belajar'],
    );
  }

  // 11. Fallback — 3 varian biar nggak monoton
  const fallbacks = [
    'Hmm, yang itu aku belum paham 🤔\n\nAku paling jago:\n• Materi — mis. **jelaskan fotosintesis**\n• Hitungan — mis. **3x+5=20**\n• Info — mis. **kapan tryout?**',
    'Otakku loading... tapi nggak ketemu 😅\n\nCoba tanya materi (**hukum newton**?), tempel soal (**12²−8²**?), atau info app (**streakku berapa?**).',
    'Kurang ngerti maksudmu, tapi aku mau bantu! 🙏\n\nPilih jalan pintas: materi, hitungan, atau info tryout?',
  ];
  return BotReply(
    fallbacks[q.hashCode.abs() % fallbacks.length],
    suggestions: _defaultSuggestions,
  );
}

// ================= MATERI =================

BotReply _subjectReply(String subjectId, String q) {
  final chapters = ChapterData.chaptersOf(subjectId, _subjectName(subjectId));
  // Bab spesifik?
  for (final c in chapters) {
    if (q.contains(c.title.toLowerCase())) {
      final content = ChapterData.contentOf(c.id);
      final first =
          content.summary.split('.').first.trim();
      return BotReply(
        '**${_subjectName(subjectId)} — ${c.title}**\n\n$first.\n\n• ${content.keyPoints.join('\n• ')}\n\n💡 Contoh: ${content.example}\n\nMau video + latihan lengkapnya? 👇',
        actions: [
          BotAction('📖 Buka bab: ${c.title}', 'chapter:${c.id}'),
          BotAction('📚 Bank Soal ${_subjectName(subjectId)}', 'bank_soal:$subjectId'),
        ],
        suggestions: const ['Kasih contoh soal lain', 'Tips belajar'],
      );
    }
  }
  final buf = StringBuffer(
      '**${_subjectName(subjectId)}** punya ${chapters.length} bab:\n');
  for (final c in chapters) {
    buf.writeln('${c.index}. ${c.title}');
  }
  buf.write('\nMulai dari bab 1, atau langsung hajar soalnya? 💪');
  return BotReply(
    buf.toString(),
    actions: [
      BotAction('📚 Bank Soal ${_subjectName(subjectId)}', 'bank_soal:$subjectId'),
      if (chapters.isNotEmpty)
        BotAction('📖 Mulai: ${chapters.first.title}',
            'chapter:${chapters.first.id}'),
    ],
    suggestions: const ['Tips belajar', 'Kapan tryout?'],
  );
}

String _subjectName(String id) {
  switch (id) {
    case 'fisika':
      return 'Fisika';
    case 'kimia':
      return 'Kimia';
    case 'biologi':
      return 'Biologi';
    case 'matematika':
      return 'Matematika';
    case 'mat-ipa':
      return 'Mat IPA';
    case 'sejarah':
      return 'Sejarah';
    case 'literasi':
      return 'B. Inggris';
    case 'bindo':
      return 'B. Indonesia';
    default:
      return id;
  }
}

// ================= MATEMATIKA =================

bool _looksLikeMath(String q) {
  final hasDigit = RegExp(r'\d').hasMatch(q);
  if (!hasDigit) return false;
  return q.contains(RegExp(r'[+\-−–×x÷/^√²³()%*=]')) ||
      q.contains('berapa') ||
      q.contains('hitung') ||
      q.contains('hasil') ||
      q.contains('jawab') ||
      q.contains('selesaikan');
}

BotReply? _trySolveMath(String q, String raw) {
  // Pola "X% dari Y" (mis. "25% dari 80")
  final pct = RegExp(r'(\d+(?:[.,]\d+)?)\s*%\s*(?:dari|of|x|\*)\s*(\d+(?:[.,]\d+)?)')
      .firstMatch(q);
  if (pct != null) {
    final a = double.tryParse(pct[1]!.replaceAll(',', '.'));
    final b = double.tryParse(pct[2]!.replaceAll(',', '.'));
    if (a != null && b != null) {
      final v = a / 100 * b;
      return BotReply(
        '**${_fmt(a)}% dari ${_fmt(b)} = ${_fmt(v)}** ✅\n\nCara: ${_fmt(a)} ÷ 100 × ${_fmt(b)}. Gampang kan? Coba yang lain!',
        suggestions: const ['Selesaikan 3x+5=20', 'Hitung 12²−8²'],
      );
    }
  }
  final expr = _normalizeMath(q);
  if (expr.isEmpty) return null;
  final pretty = _prettyMath(raw);

  // Persamaan linear satu variabel?
  if (expr.contains('=')) {
    final parts = expr.split('=');
    if (parts.length == 2) {
      final left = parts[0];
      final right = parts[1];
      if (left.contains('x') || right.contains('x')) {
        final sol = _solveLinear(left, right, pretty);
        if (sol != null) return sol;
        return null; // biar fallback umum yang jawab
      }
      final lv = _evalExpr(left);
      final rv = _evalExpr(right);
      if (lv != null && rv != null) {
        final ok = (lv - rv).abs() < 1e-9;
        return BotReply(
          '**$pretty** → ${ok ? 'BENAR ✅' : 'SALAH ❌'}\n\nRuas kiri = **${_fmt(lv)}**, ruas kanan = **${_fmt(rv)}**.',
          suggestions: const ['Hitung 25% dari 80', 'Selesaikan 2x−3=7'],
        );
      }
      return null;
    }
    return null;
  }

  if (!expr.contains('x')) {
    final v = _evalExpr(expr);
    if (v != null) {
      return BotReply(
        '**$pretty = ${_fmt(v)}** ✅\n\nIngat urutan: **× ÷** dulu, baru **+ −**. Mau yang lebih menantang?',
        actions: const [BotAction('📚 Latihan Matematika', 'bank_soal:matematika')],
        suggestions: const ['Selesaikan 3x+5=20', 'Hitung 25% dari 80'],
      );
    }
  }
  return null;
}

/// Tampilkan kembali soal user dengan cantik (bukan hasil normalisasi).
String _prettyMath(String raw) {
  var s = raw.toLowerCase();
  for (final w in ['berapakah', 'berapa', 'hitunglah', 'hitung', 'hasilnya', 'hasil', 'jawablah', 'jawab', 'selesaikan', 'tentukan', 'nilai dari', 'hasil dari', 'tolong', 'plis', 'please', 'dong', 'kak', 'mipi']) {
    s = s.replaceAll(RegExp('\\b${RegExp.escape(w)}\\b'), ' ');
  }
  s = s.replaceAll('?', '').replaceAll(' ', '');
  // x di antara angka = kali → tampilkan ×
  s = s.replaceAllMapped(
      RegExp(r'(\d)x(\d)'), (m) => '${m[1]}×${m[2]}');
  s = s.replaceAll('*', '×').replaceAll(':', '÷');
  return s.isEmpty ? raw.trim() : s;
}

/// Normalisasi teks bebas jadi ekspresi matematika.
String _normalizeMath(String q) {
  var s = q.toLowerCase();
  // buang kata tanya umum
  for (final w in ['berapa', 'hitung', 'hitunglah', 'hasil', 'hasilnya', 'jawab', 'selesaikan', 'tentukan', 'nilai dari', 'hasil dari', 'tolong', 'kak', 'mipi', 'dong', '?']) {
    s = s.replaceAll(w, ' ');
  }
  s = s.replaceAll(' ', '');
  // operator unicode -> ascii
  s = s.replaceAll('×', '*').replaceAll('∙', '*').replaceAll('·', '*');
  s = s.replaceAll('÷', '/').replaceAll(':', '/');
  s = s.replaceAll('−', '-').replaceAll('–', '-'); // minus unicode
  s = s.replaceAll('²', '^2').replaceAll('³', '^3');
  s = s.replaceAll(',', '.');
  // 'x' di antara angka = kali. Elsewhere = variabel.
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == 'x') {
      final prevDigit = i > 0 && RegExp(r'[\d)]').hasMatch(s[i - 1]);
      final nextDigit = i < s.length - 1 && RegExp(r'[\d(]').hasMatch(s[i + 1]);
      buf.write(prevDigit && nextDigit ? '*' : 'x');
    } else {
      buf.write(c);
    }
  }
  s = buf.toString();
  // persen menempel: 50% -> (50/100)
  s = s.replaceAllMapped(RegExp(r'(\d+(?:\.\d+)?)%'), (m) => '(${m[1]}/100)');
  // akar: √9 / √(9) -> sqrt(...)
  s = s.replaceAllMapped(RegExp(r'√\(?(\d+(?:\.\d+)?)\)?'), (m) => 'sqrt(${m[1]})');
  // validasi karakter ('=' diizinkan untuk persamaan)
  if (s.isEmpty || s.length > 60) return '';
  if (!RegExp(r'^[\d+\-*/^%().xsqrt=]+$').hasMatch(s)) return '';
  if (!RegExp(r'\d').hasMatch(s)) return '';
  // '=' di akhir (mis. "2x2=") dibuang
  s = s.replaceAll(RegExp(r'=+$'), '');
  return s;
}

/// Selesaikan persamaan linear ax+b = cx+d.
BotReply? _solveLinear(String left, String right, String pretty) {
  final l = _linearCoeffs(left);
  final r = _linearCoeffs(right);
  if (l == null || r == null) return null;
  final a = l[0] - r[0];
  final b = r[1] - l[1];
  if (a.abs() < 1e-12) {
    if (b.abs() < 1e-12) {
      return BotReply('**$pretty** benar untuk semua x ✅ (identitas — kedua ruas selalu sama).',
          suggestions: const ['Selesaikan 2x−3=7']);
    }
    return BotReply('**$pretty** tidak punya solusi ❌ (kontradiksi — x-nya saling menghapus tapi angkanya beda). Cek lagi soalnya ya.',
        suggestions: const ['Hitung 12²−8²']);
  }
  final x = b / a;
  return BotReply(
    '**$pretty** → **x = ${_fmt(x)}** ✅\n\nLangkahnya:\n1. Kumpulkan x di kiri, angka di kanan\n2. ${_fmt(a)}x = ${_fmt(b)}\n3. x = ${_fmt(b)} ÷ ${_fmt(a)}',
    actions: const [BotAction('📚 Latihan Aljabar', 'chapter:matematika-bab1')],
    suggestions: const ['Selesaikan 2x−3=7', 'Hitung 12²−8²'],
  );
}

/// Kembalikan [a, b] untuk ax+b. Null jika bukan linear / tak valid.
List<double>? _linearCoeffs(String expr) {
  // pecah jadi suku bertanda
  var s = expr;
  if (s.startsWith('+')) s = s.substring(1);
  s = s.replaceAll('-', '+-');
  final terms = s.split('+').where((t) => t.isNotEmpty).toList();
  double a = 0, b = 0;
  for (var t in terms) {
    var neg = false;
    if (t.startsWith('-')) {
      neg = true;
      t = t.substring(1);
    }
    if (t.isEmpty) return null;
    if (t.contains('x')) {
      // koefisien: k*x, x*k, kx, x
      t = t.replaceAll('*', '');
      double coef;
      if (t == 'x') {
        coef = 1;
      } else if (t.startsWith('x') && t.length > 1) {
        return null; // x2 dsb — bukan linear sederhana
      } else if (t.endsWith('x')) {
        final num = t.substring(0, t.length - 1);
        coef = num.isEmpty ? 1 : double.tryParse(num) ?? double.nan;
        if (coef.isNaN) return null;
      } else {
        return null;
      }
      a += neg ? -coef : coef;
    } else {
      final v = _evalExpr((neg ? '-' : '') + t);
      if (v == null) return null;
      b += v;
    }
  }
  return [a, b];
}

/// Evaluasi ekspresi aritmetika. Null jika tak valid.
double? _evalExpr(String expr) {
  try {
    final tokens = _tokenize(expr);
    if (tokens.isEmpty) return null;
    final rpn = _toRpn(tokens);
    return _evalRpn(rpn);
  } catch (_) {
    return null;
  }
}

List<String> _tokenize(String s) {
  final out = <String>[];
  int i = 0;
  while (i < s.length) {
    final c = s[i];
    if (c == ' ') {
      i++;
      continue;
    }
    if (RegExp(r'[\d.]').hasMatch(c)) {
      final j = RegExp(r'\d+(?:\.\d+)?').matchAsPrefix(s, i);
      if (j == null) throw const FormatException();
      out.add(j.group(0)!);
      i = j.end;
      continue;
    }
    if (s.startsWith('sqrt', i)) {
      out.add('sqrt');
      i += 4;
      continue;
    }
    if ('+-*/^%()'.contains(c)) {
      // minus unary?
      if (c == '-' &&
          (out.isEmpty ||
              out.last == '(' ||
              '+-*/^%'.contains(out.last))) {
        out.add('u-');
      } else {
        out.add(c);
      }
      i++;
      continue;
    }
    throw const FormatException();
  }
  return out;
}

int _prec(String op) {
  switch (op) {
    case 'u-':
      return 4;
    case '^':
      return 3;
    case '*':
    case '/':
    case '%':
      return 2;
    case '+':
    case '-':
      return 1;
    default:
      return 0;
  }
}

bool _rightAssoc(String op) => op == '^' || op == 'u-';

List<String> _toRpn(List<String> tokens) {
  final out = <String>[];
  final st = <String>[];
  for (final t in tokens) {
    if (double.tryParse(t) != null) {
      out.add(t);
    } else if (t == 'sqrt') {
      st.add(t);
    } else if (t == '(') {
      st.add(t);
    } else if (t == ')') {
      while (st.isNotEmpty && st.last != '(') {
        out.add(st.removeLast());
      }
      if (st.isEmpty) throw const FormatException();
      st.removeLast();
      if (st.isNotEmpty && st.last == 'sqrt') {
        out.add(st.removeLast());
      }
    } else {
      while (st.isNotEmpty &&
          st.last != '(' &&
          (_prec(st.last) > _prec(t) ||
              (_prec(st.last) == _prec(t) &&
                  !_rightAssoc(t)))) {
        out.add(st.removeLast());
      }
      st.add(t);
    }
  }
  while (st.isNotEmpty) {
    final o = st.removeLast();
    if (o == '(') throw const FormatException();
    out.add(o);
  }
  return out;
}

double? _evalRpn(List<String> rpn) {
  final st = <double>[];
  for (final t in rpn) {
    final n = double.tryParse(t);
    if (n != null) {
      st.add(n);
      continue;
    }
    if (t == 'u-') {
      if (st.isEmpty) return null;
      st.add(-st.removeLast());
      continue;
    }
    if (t == 'sqrt') {
      if (st.isEmpty) return null;
      final v = st.removeLast();
      if (v < 0) return null;
      st.add(math.sqrt(v));
      continue;
    }
    if (st.length < 2) return null;
    final b = st.removeLast();
    final a = st.removeLast();
    switch (t) {
      case '+':
        st.add(a + b);
        break;
      case '-':
        st.add(a - b);
        break;
      case '*':
        st.add(a * b);
        break;
      case '/':
        if (b == 0) return null;
        st.add(a / b);
        break;
      case '%':
        if (b == 0) return null;
        st.add(a % b);
        break;
      case '^':
        st.add(math.pow(a, b).toDouble());
        break;
      default:
        return null;
    }
    if (st.last.isInfinite || st.last.isNaN) return null;
  }
  return st.length == 1 ? st.single : null;
}

String _fmt(double v) {
  if ((v - v.round()).abs() < 1e-9) return '${v.round()}';
  var s = v.toStringAsFixed(4);
  s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  return s;
}
