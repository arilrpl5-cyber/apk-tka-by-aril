import '../models/question_model.dart';

/// Bank Soal TKA — 8 mapel, masing-masing 5 soal + pembahasan.
/// Soal dibuat ringkas tapi representatif untuk latihan.
class BankSoalData {
  BankSoalData._();

  static const List<SubjectPackModel> packs = [
    SubjectPackModel(subjectId: 'fisika', subjectName: 'Fisika', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'kimia', subjectName: 'Kimia', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'biologi', subjectName: 'Biologi', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'matematika', subjectName: 'Matematika', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'mat-ipa', subjectName: 'Mat IPA', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'sejarah', subjectName: 'Sejarah', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'literasi', subjectName: 'Literasi B. Inggris', totalQuestions: 5, durationMinutes: 15),
    SubjectPackModel(subjectId: 'bindo', subjectName: 'B. Indonesia', totalQuestions: 5, durationMinutes: 15),
  ];

  static List<QuestionModel> questionsBySubject(String subjectId) {
    return _all.where((q) => q.subjectId == subjectId).toList();
  }

  static const List<QuestionModel> _all = [
    // ================= FISIKA =================
    QuestionModel(
      id: 'fis-1', subjectId: 'fisika',
      question: 'Sebuah benda bergerak lurus beraturan dengan kecepatan 20 m/s selama 5 sekon. Jarak yang ditempuh adalah ...',
      options: ['40 m', '60 m', '100 m', '120 m'],
      correctIndex: 2,
      explanation: 'GLB: s = v × t = 20 × 5 = 100 m.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'fis-2', subjectId: 'fisika',
      question: 'Benda bermassa 2 kg diberi gaya 10 N. Percepatan yang dialami benda adalah ...',
      options: ['2 m/s²', '5 m/s²', '10 m/s²', '20 m/s²'],
      correctIndex: 1,
      explanation: 'Hukum II Newton: a = F/m = 10/2 = 5 m/s².',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'fis-3', subjectId: 'fisika',
      question: 'Sebuah bola dijatuhkan dari ketinggian 45 m (g = 10 m/s²). Waktu hingga menyentuh tanah adalah ...',
      options: ['2 s', '3 s', '4 s', '5 s'],
      correctIndex: 1,
      explanation: 'h = ½gt² → 45 = 5t² → t² = 9 → t = 3 s.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'fis-4', subjectId: 'fisika',
      question: 'Daya 100 watt digunakan selama 2 menit. Energi yang digunakan sebesar ...',
      options: ['200 J', '3.000 J', '6.000 J', '12.000 J'],
      correctIndex: 3,
      explanation: 'W = P × t = 100 × 120 = 12.000 J.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'fis-5', subjectId: 'fisika',
      question: 'Frekuensi gelombang 5 Hz dengan panjang gelombang 4 m. Cepat rambatnya adalah ...',
      options: ['0,8 m/s', '1,25 m/s', '9 m/s', '20 m/s'],
      correctIndex: 3,
      explanation: 'v = λ × f = 4 × 5 = 20 m/s.',
      difficulty: 'Mudah',
    ),

    // ================= KIMIA =================
    QuestionModel(
      id: 'kim-1', subjectId: 'kimia',
      question: 'Lambang unsur natrium adalah ...',
      options: ['N', 'Na', 'Ne', 'Ni'],
      correctIndex: 1,
      explanation: 'Natrium = Na (dari Natrium, latin: Natrium). N adalah nitrogen.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'kim-2', subjectId: 'kimia',
      question: 'pH larutan dengan [H+] = 10⁻³ M adalah ...',
      options: ['1', '3', '7', '11'],
      correctIndex: 1,
      explanation: 'pH = -log[H+] = -log(10⁻³) = 3.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'kim-3', subjectId: 'kimia',
      question: 'Ikatan yang terjadi antara Na dan Cl pada NaCl adalah ikatan ...',
      options: ['Kovalen', 'Ion', 'Logam', 'Hidrogen'],
      correctIndex: 1,
      explanation: 'Logam (Na) + non-logam (Cl) → serah terima elektron → ikatan ion.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'kim-4', subjectId: 'kimia',
      question: 'Massa molar H2O (H=1, O=16) adalah ...',
      options: ['17 g/mol', '18 g/mol', '19 g/mol', '20 g/mol'],
      correctIndex: 1,
      explanation: 'Mr = 2(1) + 16 = 18 g/mol.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'kim-5', subjectId: 'kimia',
      question: 'Larutan yang dapat mempertahankan pH disebut larutan ...',
      options: ['Elektrolit', 'Koloid', 'Buffer', 'Jenuh'],
      correctIndex: 2,
      explanation: 'Larutan penyangga (buffer) menahan perubahan pH.',
      difficulty: 'Sedang',
    ),

    // ================= BIOLOGI =================
    QuestionModel(
      id: 'bio-1', subjectId: 'biologi',
      question: 'Organel sel yang berfungsi sebagai tempat fotosintesis adalah ...',
      options: ['Mitokondria', 'Kloroplas', 'Nukleus', 'Ribosom'],
      correctIndex: 1,
      explanation: 'Fotosintesis terjadi di kloroplas yang mengandung klorofil.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bio-2', subjectId: 'biologi',
      question: 'Proses pembentukan energi (ATP) pada sel terjadi di ...',
      options: ['Kloroplas', 'Mitokondria', 'Dinding sel', 'Vakuola'],
      correctIndex: 1,
      explanation: 'Respirasi sel penghasil ATP terjadi di mitokondria.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bio-3', subjectId: 'biologi',
      question: 'Golongan darah yang disebut donor universal adalah ...',
      options: ['A', 'B', 'AB', 'O'],
      correctIndex: 3,
      explanation: 'Golongan O tidak punya antigen A/B sehingga bisa donor ke semua.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bio-4', subjectId: 'biologi',
      question: 'Bagian darah yang berfungsi membekukan darah saat luka adalah ...',
      options: ['Eritrosit', 'Leukosit', 'Trombosit', 'Plasma'],
      correctIndex: 2,
      explanation: 'Trombosit (keping darah) berperan dalam pembekuan darah.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bio-5', subjectId: 'biologi',
      question: 'Hormon insulin dihasilkan oleh organ ...',
      options: ['Hati', 'Ginjal', 'Pankreas', 'Lambung'],
      correctIndex: 2,
      explanation: 'Sel beta pankreas menghasilkan insulin untuk mengatur gula darah.',
      difficulty: 'Sedang',
    ),

    // ================= MATEMATIKA =================
    QuestionModel(
      id: 'mtk-1', subjectId: 'matematika',
      question: 'Hasil dari 12² − 8² adalah ...',
      options: ['40', '64', '80', '144'],
      correctIndex: 2,
      explanation: '144 − 64 = 80. Atau (12−8)(12+8) = 4×20 = 80.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mtk-2', subjectId: 'matematika',
      question: 'Jika 3x + 5 = 20, maka nilai x adalah ...',
      options: ['3', '5', '7', '15'],
      correctIndex: 1,
      explanation: '3x = 15 → x = 5.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mtk-3', subjectId: 'matematika',
      question: 'Rata-rata dari 4, 6, 8, 10 adalah ...',
      options: ['6', '7', '8', '9'],
      correctIndex: 1,
      explanation: '(4+6+8+10)/4 = 28/4 = 7.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mtk-4', subjectId: 'matematika',
      question: 'Peluang muncul angka genap pada dadu 6 sisi adalah ...',
      options: ['1/6', '1/3', '1/2', '2/3'],
      correctIndex: 2,
      explanation: 'Genap: 2,4,6 → 3/6 = 1/2.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'mtk-5', subjectId: 'matematika',
      question: 'Turunan dari f(x) = x³ + 2x adalah ...',
      options: ['3x² + 2', 'x² + 2', '3x + 2', '3x² + 1'],
      correctIndex: 0,
      explanation: "f'(x) = 3x² + 2.",
      difficulty: 'Sedang',
    ),

    // ================= MAT IPA =================
    QuestionModel(
      id: 'mipa-1', subjectId: 'mat-ipa',
      question: 'Nilai dari log 1000 adalah ...',
      options: ['1', '2', '3', '10'],
      correctIndex: 2,
      explanation: 'log 1000 = log 10³ = 3.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mipa-2', subjectId: 'mat-ipa',
      question: 'Himpunan penyelesaian |x| = 5 adalah ...',
      options: ['{5}', '{-5}', '{-5, 5}', '{0}'],
      correctIndex: 2,
      explanation: '|x|=5 → x=5 atau x=−5.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mipa-3', subjectId: 'mat-ipa',
      question: 'sin 30° + cos 60° = ...',
      options: ['0', '1/2', '1', '√3'],
      correctIndex: 2,
      explanation: '½ + ½ = 1.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'mipa-4', subjectId: 'mat-ipa',
      question: 'Limit x→0 dari (sin x)/x adalah ...',
      options: ['0', '1', 'Tak hingga', 'Tidak ada'],
      correctIndex: 1,
      explanation: 'Limit trigonometri dasar = 1.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'mipa-5', subjectId: 'mat-ipa',
      question: 'Vektor a=(1,2), b=(3,−1). a+b = ...',
      options: ['(4,1)', '(2,3)', '(4,3)', '(3,1)'],
      correctIndex: 0,
      explanation: '(1+3, 2+(−1)) = (4,1).',
      difficulty: 'Sedang',
    ),

    // ================= SEJARAH =================
    QuestionModel(
      id: 'sej-1', subjectId: 'sejarah',
      question: 'Proklamasi kemerdekaan Indonesia dibacakan pada tanggal ...',
      options: ['16 Agustus 1945', '17 Agustus 1945', '18 Agustus 1945', '20 Mei 1908'],
      correctIndex: 1,
      explanation: '17 Agustus 1945 oleh Soekarno-Hatta di Pegangsaan Timur 56.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'sej-2', subjectId: 'sejarah',
      question: 'Organisasi Budi Utomo didirikan pada tahun ...',
      options: ['1905', '1908', '1928', '1945'],
      correctIndex: 1,
      explanation: '20 Mei 1908 oleh dr. Sutomo dkk.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'sej-3', subjectId: 'sejarah',
      question: 'Sumpah Pemuda diikrarkan pada ...',
      options: ['28 Oktober 1928', '1 Juni 1945', '10 November 1945', '17 Agustus 1945'],
      correctIndex: 0,
      explanation: 'Kongres Pemuda II, 28 Oktober 1928.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'sej-4', subjectId: 'sejarah',
      question: 'Kerajaan Hindu tertua di Indonesia adalah ...',
      options: ['Majapahit', 'Sriwijaya', 'Kutai', 'Mataram'],
      correctIndex: 2,
      explanation: 'Kutai Martadipura di Kalimantan Timur (± abad ke-4).',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'sej-5', subjectId: 'sejarah',
      question: 'Konferensi Asia Afrika pertama digelar di ...',
      options: ['Jakarta', 'Bandung', 'Yogyakarta', 'Surabaya'],
      correctIndex: 1,
      explanation: 'KAA 1955 di Bandung.',
      difficulty: 'Mudah',
    ),

    // ================= LITERASI INGGRIS =================
    QuestionModel(
      id: 'lit-1', subjectId: 'literasi',
      question: '"She ___ to school every day." The correct verb is ...',
      options: ['go', 'goes', 'going', 'gone'],
      correctIndex: 1,
      explanation: 'Subject "she" (singular) → verb + s: goes.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'lit-2', subjectId: 'literasi',
      question: 'Synonym of "happy" is ...',
      options: ['sad', 'glad', 'angry', 'tired'],
      correctIndex: 1,
      explanation: 'Happy ≈ glad (senang).',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'lit-3', subjectId: 'literasi',
      question: '"They have lived here ___ 2010." The correct preposition is ...',
      options: ['for', 'since', 'at', 'on'],
      correctIndex: 1,
      explanation: 'Since + titik waktu (2010). For + durasi.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'lit-4', subjectId: 'literasi',
      question: 'Passive form of "She writes a letter" is ...',
      options: ['A letter is written by her', 'A letter was wrote by her', 'She is written a letter', 'A letter writes by her'],
      correctIndex: 0,
      explanation: 'Present simple passive: is + V3.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'lit-5', subjectId: 'literasi',
      question: '"If I ___ rich, I would travel." The correct word is ...',
      options: ['am', 'were', 'was', 'be'],
      correctIndex: 1,
      explanation: 'Conditional type 2 memakai "were" untuk semua subject.',
      difficulty: 'Sedang',
    ),

    // ================= B. INDONESIA =================
    QuestionModel(
      id: 'bi-1', subjectId: 'bindo',
      question: 'Kata baku dari "apotik" adalah ...',
      options: ['apotik', 'apotek', 'apothek', 'apotic'],
      correctIndex: 1,
      explanation: 'Bentuk baku KBBI: apotek.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bi-2', subjectId: 'bindo',
      question: 'Ide pokok paragraf disebut juga ...',
      options: ['Kalimat penjelas', 'Gagasan utama', 'Kesimpulan', 'Judul'],
      correctIndex: 1,
      explanation: 'Ide pokok = gagasan utama/utama paragraf.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bi-3', subjectId: 'bindo',
      question: 'Majas yang melebih-lebihkan disebut ...',
      options: ['Metafora', 'Hiperbola', 'Personifikasi', 'Ironi'],
      correctIndex: 1,
      explanation: 'Hiperbola: gaya bahasa berlebihan.',
      difficulty: 'Mudah',
    ),
    QuestionModel(
      id: 'bi-4', subjectId: 'bindo',
      question: 'Penulisan kalimat langsung yang tepat adalah ...',
      options: ['Ibu berkata, bawakan air.', 'Ibu berkata: "Bawakan air!"', 'Ibu berkata "bawakan air"', '"Ibu berkata, bawakan air"'],
      correctIndex: 1,
      explanation: 'Kalimat langsung memakai tanda petik dua dan tanda baca tepat.',
      difficulty: 'Sedang',
    ),
    QuestionModel(
      id: 'bi-5', subjectId: 'bindo',
      question: 'Sinonim kata "bahagia" adalah ...',
      options: ['sedih', 'senang', 'marah', 'kecewa'],
      correctIndex: 1,
      explanation: 'Bahagia ≈ senang/gembira.',
      difficulty: 'Mudah',
    ),
  ];
}
