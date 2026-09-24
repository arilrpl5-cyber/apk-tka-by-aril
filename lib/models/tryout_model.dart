import 'package:flutter/material.dart';

/// Model satu item tryout.
class TryoutModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final bool isFree;
  final bool isPremium;
  final int? score;
  final String status;
  final int diamondCost;
  final bool isCompleted;

  const TryoutModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.isFree = false,
    this.isPremium = false,
    this.score,
    required this.status,
    this.diamondCost = 0,
    this.isCompleted = false,
  });
}

/// Model kategori tryout (chip horizontal).
class TryoutCategoryModel {
  final String id;
  final String name;
  final String shortName;
  final Color backgroundColor;
  final int badgeCount;
  final IconData icon;

  const TryoutCategoryModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.backgroundColor,
    required this.badgeCount,
    required this.icon,
  });
}
