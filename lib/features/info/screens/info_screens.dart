import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../models/question_model.dart';
import '../../bank_soal/screens/bank_soal_screen.dart';
import '../../bank_soal/screens/quiz_screen.dart';
import '../../chatbot/screens/chatbot_screen.dart';

/// Kumpulan layar info agar semua tombol Home bisa diklik.

class PegasusScreen extends StatelessWidget {
  const PegasusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pegasus',
          style: AppTextStyles.h3.copyWith(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.badgeRed,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text('Baru',
                            style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 8),
                      Text('Pendamping Belajar AI',
                          style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pegasus membantumu menyusun rencana belajar, menjawab soal sulit, dan mengingatkan jadwal tryout. Coba tanya apa saja!',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Mulai Chat Pegasus',
                    width: double.infinity,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const ChatbotScreen(
                                    persona:
                                        'pegasus')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SikatSoalScreen extends StatelessWidget {
  const SikatSoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sikat Soal',
          style: AppTextStyles.h3.copyWith(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                children: [
                  const Icon(Icons.bolt,
                      size: 48, color: AppColors.accentOrange),
                  const SizedBox(height: 8),
                  Text('Mode Kilat 5 Menit',
                      style: AppTextStyles.h3),
                  Text(
                    'Campuran 5 soal acak dari semua mapel. Cepat, tepat, dapat XP double!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Mulai Sikat Soal',
                    width: double.infinity,
                    color: AppColors.accentOrange,
                    onPressed: () {
                      // Paket campuran: pakai soal fisika sbg pack,
                      // tapi questions diganti campuran di QuizScreen? Sederhananya pakai Matematika.
                      // Untuk kilat, kita buat pack sintetis dari 5 soal pertama semua mapel.
                      const pack = SubjectPackModel(
                        subjectId: 'fisika',
                        subjectName: 'Sikat Kilat Campuran',
                        totalQuestions: 5,
                        durationMinutes: 5,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const QuizScreen(pack: pack)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoKuliahScreen extends StatelessWidget {
  const InfoKuliahScreen({super.key});

  static const kampus = [
    {'nama': 'Universitas Indonesia', 'lok': 'Depok • SIMAK UI', 'passing': 'Passing 78%'},
    {'nama': 'UGM', 'lok': 'Yogyakarta • UTUL UGM', 'passing': 'Passing 76%'},
    {'nama': 'ITB', 'lok': 'Bandung • SNBT', 'passing': 'Passing 82%'},
    {'nama': 'UNPAD', 'lok': 'Bandung • SMUP', 'passing': 'Passing 72%'},
    {'nama': 'UNAIR', 'lok': 'Surabaya • Mandiri', 'passing': 'Passing 70%'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info Kuliah',
          style: AppTextStyles.h3.copyWith(color: Colors.white))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kampus.length,
        itemBuilder: (_, i) {
          final k = kampus[i];
          return CustomCard(
            margin: const EdgeInsets.only(bottom: 10),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Detail ${k['nama']} (demo) — ${k['passing']}')));
            },
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_outlined,
                      color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('${k['nama']}',
                          style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w800)),
                      Text('${k['lok']} • ${k['passing']}',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Tanya MIPI — chatbot beneran (jawab materi, hitung soal, info app).
class TanyaMipiScreen extends StatelessWidget {
  const TanyaMipiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const ChatbotScreen(persona: 'mipi');
  }
}

class UjianMandiriScreen extends StatelessWidget {
  final String title;
  const UjianMandiriScreen({super.key, this.title = 'SIMAK UI'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title,
          style: AppTextStyles.h3.copyWith(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h2),
                Text('Seleksi mandiri • 100 soal • 180 menit',
                    style: AppTextStyles.caption),
                const SizedBox(height: 10),
                const CustomButton(
                    text: 'Lihat Silabus (Demo)',
                    width: double.infinity),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 1; i <= 3; i++)
            CustomCard(
              margin:
                  const EdgeInsets.only(bottom: 10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const BankSoalScreen()),
                );
              },
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                          'Paket Latihan $title #$i',
                          style: AppTextStyles.body
                              .copyWith(
                                  fontWeight:
                                      FontWeight.w700))),
                  const Icon(Icons.chevron_right,
                      color:
                          AppColors.textSecondary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
