import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_label.dart';
import '../logic/profile_cubit.dart';

/// "تعديل البيانات" — lets the signed-in manager update their name/email.
/// The phone number came from login and isn't editable here.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: kUserModel?.name);
  late final _emailCtrl = TextEditingController(text: kUserModel?.email);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; // optional
    if (!value.contains('@')) return LocaleKeys.validation_invalidEmail.tr();
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    context.read<ProfileCubit>().updateProfile(
          name: _nameCtrl.text.trim(),
          email: email.isEmpty ? null : email,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          AppOverlay.showSuccess(LocaleKeys.profile_updateSuccess.tr());
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor.themeColor,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.profile_editTitle.tr(),
                      eyebrow: LocaleKeys.profile_editSubtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    22.height,
                    FieldLabel(text: LocaleKeys.profile_nameLabel.tr()),
                    8.height,
                    CustomTextField(
                      hint: LocaleKeys.profile_nameHint.tr(),
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                      validator: _validateName,
                    ),
                    14.height,
                    FieldLabel(text: LocaleKeys.profile_emailLabel.tr()),
                    8.height,
                    CustomTextField(
                      hint: LocaleKeys.profile_emailHint.tr(),
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    14.height,
                    FieldLabel(text: LocaleKeys.auth_phone.tr()),
                    8.height,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor.themeColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AppText(kUserModel?.phone ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryColor.themeColor),
                    ),
                    6.height,
                    AppText(LocaleKeys.profile_phoneReadOnlyNote.tr(),
                        fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    28.height,
                    CustomButton(
                      title: LocaleKeys.profile_saveChanges.tr(),
                      onTap: _submit,
                      loading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
