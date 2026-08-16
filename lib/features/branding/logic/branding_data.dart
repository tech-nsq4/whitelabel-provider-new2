import 'package:equatable/equatable.dart';

import '../data/models/branding_theme_option.dart';

class BrandingData extends Equatable {
  const BrandingData({
    required this.themes,
    required this.selectedIndex,
    required this.clinicName,
  });

  final List<BrandingThemeOption> themes;
  final int selectedIndex;
  final String clinicName;

  BrandingThemeOption get selected => themes[selectedIndex];

  BrandingData copyWith({int? selectedIndex, String? clinicName}) => BrandingData(
        themes: themes,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        clinicName: clinicName ?? this.clinicName,
      );

  @override
  List<Object?> get props => [themes, selectedIndex, clinicName];
}
