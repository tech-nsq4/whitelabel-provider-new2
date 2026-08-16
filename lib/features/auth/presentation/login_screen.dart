import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_label.dart';
import '../../profile/logic/profile_cubit.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return LocaleKeys.validation_required.tr();
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // The backend takes a bare local number (e.g. "01012345678"), not one
    // prefixed with the country's dial code.
    context.read<AuthCubit>().login(
          phone: _phoneNumber!.number,
          password: _passwordCtrl.text,
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (kDebugMode) {
      _phoneNumber = PhoneNumber(
          countryISOCode: '', countryCode: '', number: '01000000001');
      _phoneCtrl.text = '01000000001';
      _passwordCtrl.text = 'password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<ProfileCubit>().setUser(state.manager);
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.layoutScreen, (_) => false);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: 16.paddingHorizontal,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor.themeColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        AppText(
                          LocaleKeys.auth_login.tr(),
                          isHeading: true,
                          fontSize: 24,
                          color: AppColors.textPrimaryColor.themeColor,
                          fontWeight: FontWeight.w700,
                        ),
                        6.height,
                        AppText(
                          LocaleKeys.auth_loginSubtitle.tr(),
                          fontSize: 13,
                          color: AppColors.mutedColor.themeColor,
                          fontWeight: FontWeight.w500,
                        ),
                        20.height,
                        FieldLabel(text: LocaleKeys.auth_phone.tr()),
                        8.height,
                        // Egypt is the only market live right now, so it's
                        // the default country — its own "must start with
                        // 0" / length rules apply automatically, but the
                        // picker still lets a manager pick another.
                        CustomTextFieldPhoneCode(
                          hint: LocaleKeys.auth_phone.tr(),
                          controller: _phoneCtrl,
                          egyptIsInitial: true,
                          onChanged: (p) => _phoneNumber = p,
                        ),
                        14.height,
                        FieldLabel(text: LocaleKeys.auth_password.tr()),
                        8.height,
                        CustomTextField(
                          hint: LocaleKeys.auth_password.tr(),
                          controller: _passwordCtrl,
                          isPassword: true,
                          validator: _validatePassword,
                        ),
                        24.height,
                        CustomButton(
                          title: LocaleKeys.auth_login.tr(),
                          onTap: _submit,
                          loading: isLoading,
                        ),
                        50.height,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
