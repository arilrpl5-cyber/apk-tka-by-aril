import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/models.dart';

/// Dummy data sesuai spesifikasi prompt.
class DummyData {
  DummyData._();

  // ---------------- USER ----------------
  static const UserModel user = UserModel(
    name: 'arill_',
    kelas: 'Kelas XI SMK',
    level: 1,
    currentXP: 0,
    maxXP: 100,
    subscriptionDays: 0,
    diamonds: 0,
    coins: 1300,
    isTrialActive: false,
  );

  // ---------------- FITUR BELAJAR ----------------
  static const List<FiturBelajarModel> fiturBelajar = [
    FiturBelajarModel(
      id: 'pegasus',
      name: 'Pegasus',
      icon: Icons.rocket_launch,
      backgroundColor: Color(0xFFE3F2FD),
      isNew: true,
    ),
    FiturBelajarModel(
      id: 'bank-soal',
      name: 'Bank Soal',
      icon: Icons.inventory_2_outlined,
      backgroundColor: Color(0xFFEDE7F6),
    ),
    FiturBelajarModel(
      id: 'tryout',
      name: 'Tryout',
      icon: Icons.assignment_outlined,
      backgroundColor: Color(0xFFFFF3E0),
    ),
    FiturBelajarModel(
      id: 'sikat-soal',
      name: 'Sikat Soal',
      icon: Icons.bolt_outlined,
      backgroundColor: Color(0xFFFCE4EC),
    ),
  ];

  // ---------------- MATERI BELAJAR ----------------
  static const List<MaterialModel> materiBelajar = [
    MaterialModel(
      id: 'fisika',
      name: 'Fisika',
      iconPath: '',
      backgroundColor: AppColors.fisika,
      icon: Icons.science_outlined,
    ),
    MaterialModel(
      id: 'kimia',
      name: 'Kimia',
      iconPath: '',
      backgroundColor: AppColors.kimia,
      icon: Icons.biotech_outlined,
    ),
    MaterialModel(
      id: 'biologi',
      name: 'Biologi',
      iconPath: '',
      backgroundColor: AppColors.biologi,
      icon: Icons.eco_outlined,
    ),
    MaterialModel(
      id: 'matematika',
      name: 'Matematika',
      iconPath: '',
      backgroundColor: AppColors.matematika,
      icon: Icons.calculate_outlined,
    ),
    MaterialModel(
      id: 'mat-ipa',
      name: 'Mat IPA',
      iconPath: '',
      backgroundColor: AppColors.matematika,
      icon: Icons.functions,
    ),
    MaterialModel(
      id: 'sejarah',
      name: 'Sejarah',
      iconPath: '',
      backgroundColor: AppColors.sejarah,
      icon: Icons.account_balance_outlined,
    ),
    MaterialModel(
      id: 'literasi',
      name: 'Literasi',
      iconPath: '',
      backgroundColor: AppColors.literasi,
      icon: Icons.menu_book_outlined,
    ),
    MaterialModel(
      id: 'bindo',
      name: 'B. Indonesia',
      iconPath: '',
      backgroundColor: AppColors.bindo,
      icon: Icons.chat_bubble_outline,
    ),
  ];

  // ---------------- TRYOUT LIST ----------------
  static const List<TryoutModel> tryoutList = [
    TryoutModel(
      id: 'to-1',
      title: 'Tryout UTBK 2027 #01',
      subtitle: 'SNBT - 7 Subtes - 195 Menit',
      category: 'UTBK',
      isFree: true,
      score: 629,
      status: 'Waktu Habis',
      isCompleted: true,
    ),
    TryoutModel(
      id: 'to-2',
      title: 'Tryout TKA SMA 2026 #01',
      subtitle: 'Wajib dan Pilihan - 90 Menit',
      category: 'TKA SMA',
      isPremium: true,
      status: 'Bisa Dikerjakan',
      diamondCost: 4,
    ),
  ];

  // ---------------- TRYOUT CATEGORIES ----------------
  static const List<TryoutCategoryModel> tryoutCategories = [
    TryoutCategoryModel(
      id: 'utbk',
      name: 'Tryout UTBK',
      shortName: 'UTBK',
      backgroundColor: Color(0xFFFFD93D),
      badgeCount: 29,
      icon: Icons.school_outlined,
    ),
    TryoutCategoryModel(
      id: 'tka-sma',
      name: 'TKA SMA',
      shortName: 'TKA SMA',
      backgroundColor: Color(0xFFFFB74D),
      badgeCount: 7,
      icon: Icons.edit_note_outlined,
    ),
    TryoutCategoryModel(
      id: 'tka-smp',
      name: 'TKA SMP',
      shortName: 'TKA SMP',
      backgroundColor: Color(0xFF64B5F6),
      badgeCount: 4,
      icon: Icons.book_outlined,
    ),
    TryoutCategoryModel(
      id: 'mandiri',
      name: 'Ujian Mandiri',
      shortName: 'Mandiri',
      backgroundColor: Color(0xFF9575CD),
      badgeCount: 0,
      icon: Icons.account_balance_outlined,
    ),
  ];

  // ---------------- PACKAGES ----------------
  static const List<PackageModel> packages = [
    PackageModel(
      id: 'live-class',
      name: 'Live Class',
      description: 'Belajar interaktif bareng tutor terbaik',
      iconPath: '',
      iconBackgroundColor: Color(0xFFE3F2FD),
      icon: Icons.videocam_outlined,
      price: 'Rp149rb',
    ),
    PackageModel(
      id: 'siap-utbk',
      name: 'Siap UTBK + TO',
      description: 'Persiapan lengkap UTBK + Tryout premium',
      iconPath: '',
      iconBackgroundColor: Color(0xFFFFF9C4),
      icon: Icons.emoji_events_outlined,
      price: 'Rp199rb',
    ),
    PackageModel(
      id: 'siap-belajar',
      name: 'Siap Belajar',
      description: 'Akses semua materi & bank soal',
      iconPath: '',
      iconBackgroundColor: Color(0xFFEDE7F6),
      icon: Icons.menu_book_outlined,
      price: 'Rp99rb',
    ),
    PackageModel(
      id: 'diamond',
      name: 'Diamond',
      description: 'Buka tryout & fitur premium',
      iconPath: '',
      iconBackgroundColor: Color(0xFFE8F5E9),
      icon: Icons.diamond_outlined,
      price: 'Rp25rb',
    ),
  ];

  // ---------------- BANNERS ----------------
  static const List<String> promoTitles = [
    '#CuriStartBiarSmart UTBK 2027',
    'Diskon 60% Semua Paket Premium',
    'Gratis Tryout TKA Setiap Weekend',
  ];
}
