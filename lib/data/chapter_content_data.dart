import '../models/chapter_model.dart';

/// Daftar 40 bab (8 mapel x 5) + isi materi tiap bab.
/// Ringkas tapi bisa dibuka & dipelajari sungguhan.
class ChapterData {
  ChapterData._();

  static List<ChapterModel> chaptersOf(
      String subjectId, String subjectName) {
    final titles = _titles[subjectId] ?? [];
    return List.generate(titles.length, (i) {
      return ChapterModel(
        id: '$subjectId-bab${i + 1}',
        subjectId: subjectId,
        subjectName: subjectName,
        title: titles[i],
        index: i + 1,
        xpReward: 20,
        durationMinutes: 8 + (i % 3) * 2,
      );
    });
  }

  static List<ChapterModel> get all {
    final out = <ChapterModel>[];
    _titles.forEach((subjectId, titles) {
      final name = _subjectNames[subjectId] ?? subjectId;
      for (int i = 0; i < titles.length; i++) {
        out.add(ChapterModel(
          id: '$subjectId-bab${i + 1}',
          subjectId: subjectId,
          subjectName: name,
          title: titles[i],
          index: i + 1,
        ));
      }
    });
    return out;
  }

  static const Map<String, String> _subjectNames = {
    'fisika': 'Fisika',
    'kimia': 'Kimia',
    'biologi': 'Biologi',
    'matematika': 'Matematika',
    'mat-ipa': 'Mat IPA',
    'sejarah': 'Sejarah',
    'literasi': 'Literasi B. Inggris',
    'bindo': 'B. Indonesia',
  };

  static const Map<String, List<String>> _titles = {
    'fisika': ['Besaran & Satuan', 'Gerak Lurus', 'Hukum Newton', 'Energi & Usaha', 'Gelombang'],
    'kimia': ['Struktur Atom', 'Ikatan Kimia', 'Stoikiometri', 'Asam Basa', 'Larutan Penyangga'],
    'biologi': ['Sel', 'Sistem Darah', 'Sistem Saraf', 'Hormon', 'Ekologi'],
    'matematika': ['Aljabar', 'Statistika', 'Peluang', 'Turunan', 'Geometri'],
    'mat-ipa': ['Logaritma', 'Nilai Mutlak', 'Trigonometri', 'Limit', 'Vektor'],
    'sejarah': ['Proklamasi', 'Budi Utomo & Kebangkitan', 'Sumpah Pemuda', 'Kerajaan Nusantara', 'Konferensi Asia Afrika'],
    'literasi': ['Grammar Dasar', 'Vocabulary', 'Preposition of Time', 'Passive Voice', 'Conditional'],
    'bindo': ['Kata Baku', 'Gagasan Utama', 'Majas', 'Kalimat Langsung', 'Sinonim'],
  };

  static ChapterContentModel contentOf(String chapterId) =>
      _contents[chapterId] ??
      const ChapterContentModel(
        chapterId: '',
        summary: 'Pelajari konsep dasar bab ini langkah demi langkah.',
        keyPoints: ['Pahami definisi', 'Hafalkan rumus/istilah kunci', 'Latihan 5 soal'],
        example: 'Contoh: kerjakan soal termudah dulu, lalu cek pembahasan.',
        tip: 'Ulangi materi ini 3x dengan jeda 1 hari agar ingatan kuat.',
      );

  static const Map<String, ChapterContentModel> _contents = {
    // ---------- FISIKA ----------
    'fisika-bab1': ChapterContentModel(
      chapterId: 'fisika-bab1',
      summary: 'Besaran adalah sesuatu yang bisa diukur dengan angka dan satuan. Ada besaran pokok (panjang, massa, waktu, dll) dan besaran turunan (kecepatan, gaya, energi).',
      keyPoints: ['7 besaran pokok wajib hafal + satuannya', 'Besaran vektor punya arah (kecepatan, gaya), skalar tidak (massa, suhu)', 'Konversi satuan: 1 km = 1000 m, 1 jam = 3600 s'],
      example: 'Contoh: kecepatan 72 km/jam = 72.000 m / 3600 s = 20 m/s.',
      tip: 'Soal TKA sering menjebak satuan — ubah dulu ke SI sebelum hitung!',
    ),
    'fisika-bab2': ChapterContentModel(
      chapterId: 'fisika-bab2',
      summary: 'Gerak lurus ada dua: GLB (kecepatan tetap, s = v×t) dan GLBB (percepatan tetap, v = v0 + at).',
      keyPoints: ['GLB: grafik v-t mendatar', 'GLBB: s = v0t + ½at²', 'Jatuh bebas: v0 = 0, a = g = 10 m/s²'],
      example: 'Contoh: benda jatuh dari 45 m → 45 = ½×10×t² → t = 3 s.',
      tip: 'Tulis dulu yang diketahui (v0, a, t) baru pilih rumus yang memuat semuanya.',
    ),
    'fisika-bab3': ChapterContentModel(
      chapterId: 'fisika-bab3',
      summary: 'Hukum I: benda diam/bergerak tetap kecuali ada gaya. Hukum II: F = m×a. Hukum III: aksi = -reaksi.',
      keyPoints: ['Satuan gaya: Newton (N)', 'Massa (kg) beda dengan berat (w = m×g)', 'Gaya gesek melawan arah gerak'],
      example: 'Contoh: m = 2 kg, F = 10 N → a = 10/2 = 5 m/s².',
      tip: 'Gambar diagram gaya dulu — 90% kesalahan karena salah arah gaya.',
    ),
    'fisika-bab4': ChapterContentModel(
      chapterId: 'fisika-bab4',
      summary: 'Usaha W = F×s. Energi kinetik Ek = ½mv², potensial Ep = mgh. Daya P = W/t.',
      keyPoints: ['Satuan energi & usaha: Joule (J)', 'Energi kekal: Ek + Ep tetap tanpa gesekan', 'Daya satuan Watt (J/s)'],
      example: 'Contoh: P = 100 W selama 2 menit → W = 100 × 120 = 12.000 J.',
      tip: 'Ubah menit ke detik dulu — jebakan paling sering di soal daya!',
    ),
    'fisika-bab5': ChapterContentModel(
      chapterId: 'fisika-bab5',
      summary: 'Gelombang memindahkan energi tanpa memindahkan medium. v = λ × f.',
      keyPoints: ['λ = panjang gelombang (m), f = frekuensi (Hz)', 'Periode T = 1/f', 'Bunyi butuh medium, cahaya tidak'],
      example: 'Contoh: f = 5 Hz, λ = 4 m → v = 20 m/s.',
      tip: 'Hafalkan segitiga v–λ–f seperti segitiga kecepatan-jarak-waktu.',
    ),

    // ---------- KIMIA ----------
    'kimia-bab1': ChapterContentModel(
      chapterId: 'kimia-bab1',
      summary: 'Atom tersusun dari proton (+), neutron (netral), elektron (−). Nomor atom = jumlah proton.',
      keyPoints: ['Lambang penting: Na (natrium), K (kalium), Fe (besi), Au (emas)', 'Elektron menentukan sifat kimia', 'Isotop: proton sama, neutron beda'],
      example: 'Contoh: Na punya 11 proton → nomor atom 11.',
      tip: 'Hafalkan 20 unsur pertama + lambang latinnya yang menipu (Na, K, Fe, Ag, Au).',
    ),
    'kimia-bab2': ChapterContentModel(
      chapterId: 'kimia-bab2',
      summary: 'Ikatan ion: serah terima elektron (logam + non-logam). Ikatan kovalen: berbagi elektron (non-logam + non-logam).',
      keyPoints: ['NaCl = ion, H2O = kovalen', 'Ikatan logam: elektron bebas bergerak', 'Ikatan hidrogen: antar molekul, titik didih tinggi'],
      example: 'Contoh: Na (logam) + Cl (non-logam) → NaCl ionik.',
      tip: 'Lihat jenis unsurnya dulu: ada logam? hampir pasti ion.',
    ),
    'kimia-bab3': ChapterContentModel(
      chapterId: 'kimia-bab3',
      summary: 'Stoikiometri = hitungan mol. Mr H2O = 18 g/mol. mol = massa / Mr.',
      keyPoints: ['1 mol = 6,02 × 10²³ partikel', 'Setarakan reaksi dulu sebelum hitung', 'Perbandingan koefisien = perbandingan mol'],
      example: 'Contoh: 36 g H2O = 36/18 = 2 mol.',
      tip: 'Selalu tulis satuan tiap langkah — salah satuan = salah jawaban.',
    ),
    'kimia-bab4': ChapterContentModel(
      chapterId: 'kimia-bab4',
      summary: 'pH = −log[H+]. pH < 7 asam, = 7 netral, > 7 basa.',
      keyPoints: ['[H+] = 10⁻³ → pH = 3', 'Asam kuat terion penuh, asam lemah sebagian', 'Indikator: lakmus merah→biru = basa'],
      example: 'Contoh: [H+] = 10⁻³ M → pH = 3.',
      tip: 'Pangkat negatif 10 langsung jadi angka pH — soal 10 detik!',
    ),
    'kimia-bab5': ChapterContentModel(
      chapterId: 'kimia-bab5',
      summary: 'Larutan penyangga (buffer) menahan perubahan pH saat ditambah sedikit asam/basa.',
      keyPoints: ['Buffer asam: asam lemah + garamnya', 'Buffer basa: basa lemah + garamnya', 'Darah & sel memakai sistem buffer'],
      example: 'Contoh: CH3COOH + CH3COONa = buffer asam.',
      tip: 'Kata kunci soal: "mempertahankan pH" → jawab buffer.',
    ),

    // ---------- BIOLOGI ----------
    'biologi-bab1': ChapterContentModel(
      chapterId: 'biologi-bab1',
      summary: 'Sel adalah unit terkecil kehidupan. Kloroplas untuk fotosintesis, mitokondria untuk energi (ATP).',
      keyPoints: ['Fotosintesis: di kloroplas, butuh cahaya + CO2 + air', 'Respirasi: di mitokondria, hasilkan ATP', 'Nukleus = pusat kendali (DNA)'],
      example: 'Contoh: tumbuhan layu di tempat gelap karena fotosintesis berhenti.',
      tip: 'Pasangkan: kloroplas–tumbuhan–fotosintesis vs mitokondria–semua sel–ATP.',
    ),
    'biologi-bab2': ChapterContentModel(
      chapterId: 'biologi-bab2',
      summary: 'Darah berisi eritrosit (angkut O2), leukosit (imun), trombosit (bekuan), plasma (cairan).',
      keyPoints: ['O = donor universal, AB = resipien universal', 'Trombosit menutup luka', 'Leukosit melawan infeksi'],
      example: 'Contoh: luka berhenti berdarah karena trombosit membentuk sumbat.',
      tip: 'Hafal pasangan fungsi — keluar di hampir tiap tryout!',
    ),
    'biologi-bab3': ChapterContentModel(
      chapterId: 'biologi-bab3',
      summary: 'Sistem saraf: otak + sumsum tulang belakang + saraf tepi. Neuron menghantar impuls listrik.',
      keyPoints: ['Otak besar: berpikir & ingatan', 'Otak kecil: keseimbangan', 'Refleks: jalur tercepat tanpa otak'],
      example: 'Contoh: tangan menjauh dari api = gerak refleks.',
      tip: 'Bedakan saraf sadar vs tak sadar (otonom).',
    ),
    'biologi-bab4': ChapterContentModel(
      chapterId: 'biologi-bab4',
      summary: 'Hormon dibawa darah, bekerja lambat tapi lama. Insulin (pankreas) menurunkan gula darah.',
      keyPoints: ['Insulin kurang → diabetes', 'Adrenalin: lawan atau lari', 'Hormon tumbuh: dari hipofisis'],
      example: 'Contoh: habis makan manis, insulin mengubah glukosa jadi glikogen.',
      tip: 'Satu organ–satu hormon: pankreas–insulin paling sering keluar.',
    ),
    'biologi-bab5': ChapterContentModel(
      chapterId: 'biologi-bab5',
      summary: 'Ekologi mempelajari hubungan makhluk hidup & lingkungan: individu, populasi, komunitas, ekosistem.',
      keyPoints: ['Rantai makanan: produsen → konsumen → pengurai', 'Simbiosis: mutualisme, komensalisme, parasitisme', 'Pencemaran mengganggu keseimbangan'],
      example: 'Contoh: benalu di pohon = parasitisme.',
      tip: 'Soal selalu kasih cerita — cari kata kuncinya (untung/rugi).',
    ),

    // ---------- MATEMATIKA ----------
    'matematika-bab1': ChapterContentModel(
      chapterId: 'matematika-bab1',
      summary: 'Aljabar: operasi huruf-angka. a² − b² = (a−b)(a+b). Selesaikan persamaan dengan isolasi variabel.',
      keyPoints: ['12² − 8² = (12−8)(12+8) = 80', 'Pindah ruas = ganti tanda', 'Cek jawaban dengan substitusi'],
      example: 'Contoh: 3x + 5 = 20 → 3x = 15 → x = 5.',
      tip: 'Faktorkan dulu sebelum hitung — jauh lebih cepat.',
    ),
    'matematika-bab2': ChapterContentModel(
      chapterId: 'matematika-bab2',
      summary: 'Rata-rata = jumlah data / banyak data. Median = nilai tengah setelah diurutkan.',
      keyPoints: ['Mean sensitif terhadap outlier', 'Median tahan terhadap data ekstrem', 'Modus = paling sering muncul'],
      example: 'Contoh: 4,6,8,10 → (28)/4 = 7.',
      tip: 'Urutkan dulu sebelum cari median — kesalahan #1!',
    ),
    'matematika-bab3': ChapterContentModel(
      chapterId: 'matematika-bab3',
      summary: 'Peluang = kejadian diinginkan / semua kemungkinan. Nilai 0–1.',
      keyPoints: ['Dadu genap: 3/6 = 1/2', 'Pasti terjadi = 1, mustahil = 0', 'Dua kejadian bebas: kalikan'],
      example: 'Contoh: dadu 6 sisi muncul genap (2,4,6) → 3/6 = 1/2.',
      tip: 'Daftar dulu ruang sampelnya, jangan langsung bagi.',
    ),
    'matematika-bab4': ChapterContentModel(
      chapterId: 'matematika-bab4',
      summary: 'Turunan = laju perubahan. f(x) = xⁿ → f′ = n·xⁿ⁻¹. Konstanta turunannya nol.',
      keyPoints: ['f = x³ + 2x → f′ = 3x² + 2', 'Turunan nol = titik ekstrem', 'Naik jika f′ > 0'],
      example: 'Contoh: turunan x³ adalah 3x².',
      tip: 'Turunkan pangkat satu-satu, jangan digabung.',
    ),
    'matematika-bab5': ChapterContentModel(
      chapterId: 'matematika-bab5',
      summary: 'Geometri: luas & keliling bangun datar, volume bangun ruang. Pythagoras: a² + b² = c².',
      keyPoints: ['Luas lingkaran = πr²', 'Volume balok = p×l×t', 'Tripel Pythagoras: 3-4-5, 5-12-13'],
      example: 'Contoh: segitiga siku 3 & 4 → sisi miring 5.',
      tip: 'Hafal tripel Pythagoras — hemat 2 menit per soal.',
    ),

    // ---------- MAT IPA ----------
    'mat-ipa-bab1': ChapterContentModel(
      chapterId: 'mat-ipa-bab1',
      summary: 'Logaritma kebalikan eksponen. log 10ⁿ = n. log(a×b) = log a + log b.',
      keyPoints: ['log 1000 = 3', 'Basis 10 sering tak ditulis', 'ln = basis e'],
      example: 'Contoh: log 1000 = log 10³ = 3.',
      tip: 'Ubah ke bentuk pangkat dulu — langsung kelihatan jawabannya.',
    ),
    'mat-ipa-bab2': ChapterContentModel(
      chapterId: 'mat-ipa-bab2',
      summary: 'Nilai mutlak = jarak dari nol, selalu ≥ 0. |x| = a → x = a atau x = −a.',
      keyPoints: ['|−5| = 5', 'Pecah jadi dua kasus', 'Cek tiap solusi ke persamaan awal'],
      example: 'Contoh: |x| = 5 → x = 5 atau −5.',
      tip: 'Jangan lupa solusi negatif — jebakan klasik!',
    ),
    'mat-ipa-bab3': ChapterContentModel(
      chapterId: 'mat-ipa-bab3',
      summary: 'Sudut istimewa: sin 30° = ½, cos 60° = ½, sin 90° = 1.',
      keyPoints: ['sin 30 + cos 60 = 1', 'Gambar segitiga 30-60-90', 'Hafal tabel 0-30-45-60-90'],
      example: 'Contoh: sin 30° + cos 60° = ½ + ½ = 1.',
      tip: 'Satu tabel sudut istimewa menjawab 80% soal trigo dasar.',
    ),
    'mat-ipa-bab4': ChapterContentModel(
      chapterId: 'mat-ipa-bab4',
      summary: 'Limit = nilai pendekatan. lim (sin x)/x saat x→0 = 1.',
      keyPoints: ['Substitusi dulu; kalau 0/0 faktorkan', 'Limit trigo dasar = 1', 'Limit tak hingga: bagi pangkat tertinggi'],
      example: 'Contoh: lim x→0 sin x / x = 1.',
      tip: 'Bentuk 0/0 = sinyal untuk faktorisasi, bukan panik.',
    ),
    'mat-ipa-bab5': ChapterContentModel(
      chapterId: 'mat-ipa-bab5',
      summary: 'Vektor punya besar & arah. Penjumlahan: komponen dijumlahkan. (1,2)+(3,−1) = (4,1).',
      keyPoints: ['Jumlahkan x dengan x, y dengan y', 'Panjang vektor = √(x²+y²)', 'Vektor satuan panjangnya 1'],
      example: 'Contoh: a=(1,2), b=(3,−1) → a+b = (4,1).',
      tip: 'Tulis komponen vertikal biar tak tertukar.',
    ),

    // ---------- SEJARAH ----------
    'sejarah-bab1': ChapterContentModel(
      chapterId: 'sejarah-bab1',
      summary: 'Proklamasi 17 Agustus 1945 oleh Soekarno-Hatta di Pegangsaan Timur 56 Jakarta.',
      keyPoints: ['Naskah diketik Sayuti Melik', 'Bendera dijahit Fatmawati', 'Momen lahirnya NKRI'],
      example: 'Contoh soal: siapa pembaca teks proklamasi? Soekarno didampingi Hatta.',
      tip: 'Hafal paket 5W+1H tiap peristiwa: kapan-di mana-siapa-apa-mengapa.',
    ),
    'sejarah-bab2': ChapterContentModel(
      chapterId: 'sejarah-bab2',
      summary: 'Budi Utomo 20 Mei 1908 oleh dr. Sutomo — awal kebangkitan nasional.',
      keyPoints: ['Awalnya untuk pendidikan Jawa', 'Hari Kebangkitan Nasional = 20 Mei', 'Pelopor organisasi modern'],
      example: 'Contoh: organisasi pertama bersifat nasional? Budi Utomo.',
      tip: 'Urutkan timeline organisasi: BU (1908) → SI → Indische Partij → PNI.',
    ),
    'sejarah-bab3': ChapterContentModel(
      chapterId: 'sejarah-bab3',
      summary: 'Sumpah Pemuda 28 Oktober 1928, Kongres Pemuda II: satu tanah air, bangsa, bahasa Indonesia.',
      keyPoints: ['Lagu Indonesia Raya pertama dikumandangkan', 'Bahasa persatuan: Indonesia', 'Tonggak persatuan pemuda'],
      example: 'Contoh: isi ketiga Sumpah Pemuda = menjunjung bahasa persatuan.',
      tip: 'Hafal 3 ikrarnya kata per kata — sering ditanya lengkap.',
    ),
    'sejarah-bab4': ChapterContentModel(
      chapterId: 'sejarah-bab4',
      summary: 'Kutai Martadipura (± abad 4) kerajaan Hindu tertua. Sriwijaya maritim, Majapahit terbesar.',
      keyPoints: ['Kutai: Yupa (prasasti)', 'Sriwijaya: pusat perdagangan & Buddha', 'Majapahit: Gajah Mada, Sumpah Palapa'],
      example: 'Contoh: kerajaan Hindu tertua? Kutai, bukan Majapahit.',
      tip: 'Tua = Kutai, dagang = Sriwijaya, besar = Majapahit.',
    ),
    'sejarah-bab5': ChapterContentModel(
      chapterId: 'sejarah-bab5',
      summary: 'KAA 1955 di Bandung: solidaritas Asia-Afrika, anti kolonialisme.',
      keyPoints: ['Digagas Indonesia (Soekarno)', 'Lahir Gerakan Non-Blok', 'Gedung Merdeka saksi sejarah'],
      example: 'Contoh: KAA pertama di mana? Bandung 1955.',
      tip: 'Kota + tahun paket mati: Bandung-1955.',
    ),

    // ---------- LITERASI INGGRIS ----------
    'literasi-bab1': ChapterContentModel(
      chapterId: 'literasi-bab1',
      summary: 'Simple present: subject tunggal (he/she/it) + verb-s. She goes, they go.',
      keyPoints: ['He/she/it → goes, eats, studies', 'I/you/we/they → go, eat, study', 'Tanda waktu: every day, always'],
      example: 'Contoh: She ___ school → goes.',
      tip: 'Lihat subject dulu sebelum pilih verb — 5 detik per soal.',
    ),
    'literasi-bab2': ChapterContentModel(
      chapterId: 'literasi-bab2',
      summary: 'Synonym = persamaan kata. Happy ≈ glad, big ≈ large.',
      keyPoints: ['Baca kalimat, tebak makna dari konteks', 'Hafal pasangan umum: happy-glad, fast-quick', 'Antonim = lawan kata'],
      example: 'Contoh: synonym happy? glad.',
      tip: 'Ganti kata dengan pilihan — yang nyambung itulah jawabannya.',
    ),
    'literasi-bab3': ChapterContentModel(
      chapterId: 'literasi-bab3',
      summary: 'Since + titik waktu (2010, Monday). For + durasi (3 years, a week).',
      keyPoints: ['Since 2010, since morning', 'For 5 years, for 2 hours', 'Present perfect + since/for'],
      example: 'Contoh: lived here ___ 2010 → since.',
      tip: 'Ada angka tahun/bulan? Hampir pasti since.',
    ),
    'literasi-bab4': ChapterContentModel(
      chapterId: 'literasi-bab4',
      summary: 'Passive present: is/am/are + V3. She writes → A letter is written.',
      keyPoints: ['Fokus ke objek, bukan pelaku', 'was/were untuk past', 'by + pelaku boleh dihilangkan'],
      example: 'Contoh: She writes a letter → A letter is written by her.',
      tip: 'Cari be + V3 — itu tanda passive.',
    ),
    'literasi-bab5': ChapterContentModel(
      chapterId: 'literasi-bab5',
      summary: 'Conditional 2: If + past, would + V1. Menyatakan khayalan. If I were rich...',
      keyPoints: ['If I were (bukan was) untuk semua subject', 'Would untuk hasil khayalan', 'Type 1 = mungkin, type 2 = khayalan'],
      example: 'Contoh: If I ___ rich → were.',
      tip: 'Lihat ada "would" di klausa utama? Berarti if-nya past.',
    ),

    // ---------- B. INDONESIA ----------
    'bindo-bab1': ChapterContentModel(
      chapterId: 'bindo-bab1',
      summary: 'Kata baku sesuai KBBI: apotek (bukan apotik), atlet (bukan atlit), bus (bukan bis).',
      keyPoints: ['Apotik → apotek', 'Jadwal, kualitas, sistem (pakai i)', 'Cek KBBI saat ragu'],
      example: 'Contoh: bentuk baku apotik? apotek.',
      tip: 'Soal baku = hafalan — cicil 10 kata per hari.',
    ),
    'bindo-bab2': ChapterContentModel(
      chapterId: 'bindo-bab2',
      summary: 'Ide pokok = gagasan utama paragraf. Biasanya di kalimat pertama (deduktif) atau terakhir (induktif).',
      keyPoints: ['Deduktif: awal paragraf', 'Induktif: akhir paragraf', 'Bedakan dengan kalimat penjelas'],
      example: 'Contoh: paragraf diawali kesimpulan umum → deduktif.',
      tip: 'Baca kalimat pertama & terakhir saja — 80% ide pokok ada di sana.',
    ),
    'bindo-bab3': ChapterContentModel(
      chapterId: 'bindo-bab3',
      summary: 'Hiperbola melebih-lebihkan, metafora perbandingan langsung, personifikasi membendakan.',
      keyPoints: ['Hiperbola: berlebihan ("setinggi langit")', 'Personifikasi: benda berperilaku manusia', 'Ironi: kebalikan makna'],
      example: 'Contoh: "air matanya membanjiri kota" → hiperbola.',
      tip: 'Cari kata paling lebay — itu hiperbola.',
    ),
    'bindo-bab4': ChapterContentModel(
      chapterId: 'bindo-bab4',
      summary: 'Kalimat langsung memakai tanda petik dua. Pola: pembicara + titik dua + "ucapan".',
      keyPoints: ['Ibu berkata: "Bawakan air!"', 'Huruf kapital di awal petikan', 'Tanda baca di dalam petik'],
      example: 'Contoh benar: Ibu berkata: "Bawakan air!"',
      tip: 'Cari tanda petik + huruf kapital — itu biasanya jawaban.',
    ),
    'bindo-bab5': ChapterContentModel(
      chapterId: 'bindo-bab5',
      summary: 'Sinonim = persamaan makna. Bahagia ≈ senang/gembira.',
      keyPoints: ['Baca konteks kalimat', 'Bedakan nuansa (senang vs puas)', 'Antonim = lawan'],
      example: 'Contoh: sinonim bahagia? senang.',
      tip: 'Substitusi tiap pilihan ke kalimat — yang paling pas menang.',
    ),
  };
}
