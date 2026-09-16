enum OnboardingIllustrationType {
  welcome,
  queue,
  staff,
  setup,
}

class OnboardingSlideData {
  const OnboardingSlideData({
    this.illustration,
    this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final OnboardingIllustrationType? illustration;
  final String? imageUrl;
  final String title;
  final String subtitle;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasText => title.isNotEmpty;
}
