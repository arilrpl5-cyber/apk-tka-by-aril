import 'package:flutter/material.dart';

/// Model materi belajar (grid mapel).
class MaterialModel {
  final String id;
  final String name;
  final String iconPath;
  final Color backgroundColor;
  final IconData icon;

  const MaterialModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.backgroundColor,
    required this.icon,
  });
}

/// Model fitur belajar (Pegasus, Bank Soal, dll).
class FiturBelajarModel {
  final String id;
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final bool isNew;

  const FiturBelajarModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    this.isNew = false,
  });
}
