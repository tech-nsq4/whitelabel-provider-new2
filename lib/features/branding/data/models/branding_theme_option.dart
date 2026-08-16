import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// One selectable color theme on the "الهوية البصرية" screen — a cosmetic
/// preview only; it does not restyle the live app (that would mean making
/// [AppColors] runtime-mutable, out of scope here).
class BrandingThemeOption extends Equatable {
  const BrandingThemeOption({
    required this.id,
    required this.name,
    required this.brand,
    required this.paper,
    required this.ink,
    required this.gold,
  });

  final String id;
  final String name;
  final Color brand;
  final Color paper;
  final Color ink;
  final Color gold;

  @override
  List<Object?> get props => [id, name, brand, paper, ink, gold];
}
