part of 'branding_cubit.dart';

sealed class BrandingState extends Equatable {
  const BrandingState();
  @override
  List<Object?> get props => [];
}

final class BrandingInitial extends BrandingState {
  const BrandingInitial();
}

final class BrandingLoading extends BrandingState {
  const BrandingLoading();
}

final class BrandingSuccess extends BrandingState {
  final BrandingData data;
  const BrandingSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

final class BrandingError extends BrandingState {
  final String message;
  const BrandingError(this.message);
  @override
  List<Object?> get props => [message];
}
