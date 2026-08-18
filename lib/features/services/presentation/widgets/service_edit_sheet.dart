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
import '../../../../core/widgets/pricing_mode_card.dart';
import '../../data/models/service_model.dart';

const _kSpecialties = ['باطنة عامة', 'جلدية', 'أسنان', 'أطفال', 'نساء وولادة'];

/// The reference design's `#sh-svc` — add/edit a service with its name,
/// specialty, and a toggle-able price+duration row per visit mode.
class ServiceEditSheet extends StatefulWidget {
  const ServiceEditSheet({super.key, required this.onSubmit, this.existing});

  final ValueChanged<ServiceModel> onSubmit;
  final ServiceModel? existing;

  @override
  State<ServiceEditSheet> createState() => _ServiceEditSheetState();
}

class _ServiceEditSheetState extends State<ServiceEditSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name);
  late int _specialtyIndex = widget.existing == null
      ? 0
      : _kSpecialties.indexOf(widget.existing!.specialty).clamp(0, _kSpecialties.length - 1);

  late final Map<String, ServicePriceModel?> _byMode = {
    for (final mode in const ['عيادة', 'فيديو', 'منزلية']) mode: _priceFor(mode),
  };

  ServicePriceModel? _priceFor(String mode) {
    for (final p in widget.existing?.prices ?? const <ServicePriceModel>[]) {
      if (p.modeLabel == mode) return p;
    }
    return null;
  }
  late final Map<String, bool> _enabled = {for (final e in _byMode.entries) e.key: e.value != null};
  late final Map<String, TextEditingController> _priceCtrls = {
    for (final e in _byMode.entries) e.key: TextEditingController(text: e.value?.price.toString()),
  };
  late final Map<String, TextEditingController> _durationCtrls = {
    for (final e in _byMode.entries)
      e.key: TextEditingController(text: e.value?.durationMinutes.toString()),
  };

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _priceCtrls.values) {
      c.dispose();
    }
    for (final c in _durationCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppOverlay.showError(LocaleKeys.serviceSheet_errorName.tr());
      return;
    }
    if (!_enabled.values.any((v) => v)) {
      AppOverlay.showError(LocaleKeys.serviceSheet_errorMode.tr());
      return;
    }

    final prices = <ServicePriceModel>[
      for (final mode in const ['عيادة', 'فيديو', 'منزلية'])
        if (_enabled[mode] == true)
          ServicePriceModel(
            modeLabel: mode,
            price: int.tryParse(_priceCtrls[mode]!.text) ?? 0,
            durationMinutes: int.tryParse(_durationCtrls[mode]!.text) ?? 0,
          ),
    ];

    final model = ServiceModel(
      id: widget.existing?.id ?? 'svc-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      specialty: _kSpecialties[_specialtyIndex],
      enabled: widget.existing?.enabled ?? true,
      prices: prices,
    );

    Navigator.pop(context);
    widget.onSubmit(model);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

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
              (isEdit ? LocaleKeys.serviceSheet_titleEdit : LocaleKeys.serviceSheet_titleAdd).tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            16.height,
            _label(LocaleKeys.serviceSheet_nameLabel.tr()),
            8.height,
            CustomTextField(controller: _nameController, hint: LocaleKeys.serviceSheet_nameHint.tr()),
            14.height,
            _label(LocaleKeys.serviceSheet_specialtyLabel.tr()),
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
            _label(LocaleKeys.serviceSheet_modesLabel.tr()),
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
            CustomButton(onTap: _submit, title: LocaleKeys.serviceSheet_save.tr()),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
