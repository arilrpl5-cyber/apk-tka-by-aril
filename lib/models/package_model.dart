import 'package:flutter/material.dart';

/// Model paket pembelian.
class PackageModel {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final Color iconBackgroundColor;
  final IconData icon;
  final String price;

  const PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.icon,
    required this.price,
  });
}
