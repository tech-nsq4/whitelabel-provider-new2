import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/pricing_mode_card.dart';
import '../../data/models/doctor_profile_model.dart';

const _kSpecialties = ['باطنة عامة', 'جلدية', 'أسنان', 'أطفال', 'نساء وولادة'];
const _kServices = ['كشف باطنة', 'متابعة', 'كشف جديدة', 'كشف أسنان', 'كشف أطفال'];

/// The reference design's `#sh-doc` — the most detailed sheet: identity,
/// specialty, the services this doctor is linked to (with an inline
/// "add a new service" mini-form), and per-mode pricing overrides.
class DoctorEditSheet extends StatefulWidget {
  const DoctorEditSheet({super.key, required this.onSubmit, this.existing, this.onOpenSchedule});

  final void Function(DoctorProfileModel model, {String? previousName}) onSubmit;
  final DoctorProfileModel? existing;

  /// Lets the caller open the full-screen work-schedule editor for this
  /// doctor straight from the sheet — the reference design's nested
  /// `sh-doc → #schedule` flow.
  final void Function(String doctorName)? onOpenSchedule;

  @override
  State<DoctorEditSheet> createState() => _DoctorEditSheetState();
}

class _DoctorEditSheetState extends State<DoctorEditSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name);
  late final _rankController = TextEditingController(text: _rankFrom(widget.existing?.specialty));
  late final _experienceController = TextEditingController();
  late final _bioController = TextEditingController();
  late final _newServiceController = TextEditingController();
  late int _specialtyIndex = _initialSpecialtyIndex();
  final Set<String> _selectedServices = {};
  final List<String> _extraServices = [];
  bool _addingService = false;

  late final Map<String, bool> _enabled = {
    for (final mode in const ['عيادة', 'فيديو', 'منزلية']) mode: widget.existing?.pricing[mode] != null,
  };
  late final Map<String, TextEditingController> _priceCtrls = {
    for (final mode in const ['عيادة', 'فيديو', 'منزلية'])
      mode: TextEditingController(text: widget.existing?.pricing[mode]?.toString()),
  };
  late final Map<String, TextEditingController> _durationCtrls = {
    for (final mode in const ['عيادة', 'فيديو', 'منزلية']) mode: TextEditingController(),
  };

  static String _rankFrom(String? specialty) {
    if (specialty == null) return '';
    final parts = specialty.split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  int _initialSpecialtyIndex() {
    if (widget.existing == null) return 0;
    for (var i = 0; i < _kSpecialties.length; i++) {
      if (widget.existing!.specialty.contains(_kSpecialties[i])) return i;
    }
    return 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _newServiceController.dispose();
    for (final c in _priceCtrls.values) {
      c.dispose();
    }
    for (final c in _durationCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _addNewService() {
    final name = _newServiceController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _extraServices.add(name);
      _selectedServices.add(name);
      _newServiceController.clear();
      _addingService = false;
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppOverlay.showError(LocaleKeys.doctorSheet_errorName.tr());
      return;
    }
    final rank = _rankController.text.trim();
    final specialtyLabel =
        rank.isEmpty ? _kSpecialties[_specialtyIndex] : '$rank ${_kSpecialties[_specialtyIndex]}';

    final pricing = <String, int>{
      for (final mode in const ['عيادة', 'فيديو', 'منزلية'])
        if (_enabled[mode] == true) mode: int.tryParse(_priceCtrls[mode]!.text) ?? 0,
    };

    final stripped = name.replaceFirst('د. ', '').trim();
    final initial = (stripped.isNotEmpty ? stripped : name).substring(0, 1);

    final model = DoctorProfileModel(
      name: name,
      initial: initial,
      specialty: specialtyLabel,
      availability: widget.existing?.availability ?? StaffAvailability.available,
      pricing: pricing,
      rating: widget.existing?.rating ?? 5.0,
      occupancyPercent: widget.existing?.occupancyPercent,
    );

    Navigator.pop(context);
    widget.onSubmit(model, previousName: widget.existing?.name);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final allServices = [..._kServices, ..._extraServices];

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 26.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 18.h),
                decoration: BoxDecoration(
                  color: AppColors.hintColor.themeColor,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
            ),
            AppText(
              (isEdit ? LocaleKeys.doctorSheet_titleEdit : LocaleKeys.doctorSheet_titleAdd).tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            16.height,
            _label(LocaleKeys.doctorSheet_nameLabel.tr()),
            8.height,
            CustomTextField(controller: _nameController, hint: LocaleKeys.doctorSheet_nameHint.tr()),
            14.height,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(LocaleKeys.doctorSheet_rankLabel.tr()),
                      8.height,
                      CustomTextField(
                          controller: _rankController, hint: LocaleKeys.doctorSheet_rankHint.tr()),
                    ],
                  ),
                ),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(LocaleKeys.doctorSheet_experienceLabel.tr()),
                      8.height,
                      CustomTextField(
                        controller: _experienceController,
                        hint: LocaleKeys.doctorSheet_experienceHint.tr(),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            14.height,
            _label(LocaleKeys.doctorSheet_specialtyLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (var i = 0; i < _kSpecialties.length; i++)
                  AppToggleChip(
                    label: _kSpecialties[i],
                    selected: _specialtyIndex == i,
                    onTap: () => setState(() => _specialtyIndex = i),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.doctorSheet_bioLabel.tr()),
            8.height,
            CustomTextField(
                controller: _bioController, hint: LocaleKeys.doctorSheet_bioHint.tr(), maxLines: 2),
            14.height,
            _label(LocaleKeys.doctorSheet_servicesLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (final s in allServices)
                  AppToggleChip(
                    label: s,
                    selected: _selectedServices.contains(s),
                    onTap: () => setState(
                      () => _selectedServices.contains(s)
                          ? _selectedServices.remove(s)
                          : _selectedServices.add(s),
                    ),
                  ),
              ],
            ),
            8.height,
            if (!_addingService)
              CustomTapEffect(
                onTap: () => setState(() => _addingService = true),
                child: AppText(LocaleKeys.doctorSheet_servicesAddNew.tr(),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.themeColor),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _newServiceController,
                      hint: LocaleKeys.doctorSheet_newServiceHint.tr(),
                    ),
                  ),
                  8.width,
                  CustomButton(
                    onTap: _addNewService,
                    title: LocaleKeys.common_confirm.tr(),
                    width: 78,
                    height: 44,
                    radius: 10,
                    fontSize: 11.5,
                  ),
                ],
              ),
            16.height,
            _label(LocaleKeys.doctorSheet_pricingLabel.tr()),
            8.height,
            PricingModeCard(
              svgIcon: AppSvgIcons.home2,
              title: LocaleKeys.serviceSheet_modeClinic.tr(),
              subtitle: LocaleKeys.serviceSheet_modeClinicSub.tr(),
              enabled: _enabled['عيادة']!,
              onToggle: (v) => setState(() => _enabled['عيادة'] = v),
              priceController: _priceCtrls['عيادة']!,
              durationController: _durationCtrls['عيادة']!,
              priceLabel: LocaleKeys.serviceSheet_priceLabel.tr(),
              durationLabel: LocaleKeys.serviceSheet_durationLabel.tr(),
            ),
            10.height,
            PricingModeCard(
              svgIcon: AppSvgIcons.videoCam,
              title: LocaleKeys.serviceSheet_modeVideo.tr(),
              subtitle: LocaleKeys.serviceSheet_modeVideoSub.tr(),
              enabled: _enabled['فيديو']!,
              onToggle: (v) => setState(() => _enabled['فيديو'] = v),
              priceController: _priceCtrls['فيديو']!,
              durationController: _durationCtrls['فيديو']!,
              priceLabel: LocaleKeys.serviceSheet_priceLabel.tr(),
              durationLabel: LocaleKeys.serviceSheet_durationLabel.tr(),
            ),
            10.height,
            PricingModeCard(
              svgIcon: AppSvgIcons.ambulanceAlt,
              title: LocaleKeys.serviceSheet_modeHome.tr(),
              subtitle: LocaleKeys.serviceSheet_modeHomeSub.tr(),
              enabled: _enabled['منزلية']!,
              onToggle: (v) => setState(() => _enabled['منزلية'] = v),
              priceController: _priceCtrls['منزلية']!,
              durationController: _durationCtrls['منزلية']!,
              priceLabel: LocaleKeys.serviceSheet_priceLabel.tr(),
              durationLabel: LocaleKeys.serviceSheet_durationLabel.tr(),
            ),
            18.height,
            CustomButton(onTap: _submit, title: LocaleKeys.doctorSheet_save.tr()),
            if (widget.onOpenSchedule != null) ...[
              10.height,
              CustomButton(
                onTap: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) return;
                  Navigator.pop(context);
                  widget.onOpenSchedule!(name);
                },
                title: LocaleKeys.doctorSheet_openSchedule.tr(),
                isOutlined: true,
                borderColor: AppColors.dividerColor.themeColor,
                textColor: AppColors.textSecondaryColor.themeColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
