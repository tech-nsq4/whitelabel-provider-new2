import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_chip.dart';

class _NamedOption {
  const _NamedOption(this.label, [this.price]);
  final String label;
  final int? price;
}

const _kBranches = [_NamedOption('العليا'), _NamedOption('المرجس'), _NamedOption('الياسمين')];
const _kServices = [
  _NamedOption('كشف باطنة', 150),
  _NamedOption('متابعة', 100),
  _NamedOption('كشف جديدة', 180),
  _NamedOption('كشف أسنان', 200),
];
const _kDoctors = [
  _NamedOption('د. خالد العتيبي'),
  _NamedOption('د. رهف الدسري'),
  _NamedOption('د. سارة المحطاني'),
];
const _kFallbackSlots = ['10:00', '12:00', '14:30', '15:00', '15:30', '16:00'];

/// The reference design's `#sh-appt` sheet, simplified to a single
/// screen — patient, type, branch, service, doctor and a time slot.
class AddAppointmentSheet extends StatefulWidget {
  const AddAppointmentSheet({
    super.key,
    required this.onSubmit,
    this.dateLabel,
    this.availableSlots,
  });

  final void Function(String patientName, String service, int price) onSubmit;
  final String? dateLabel;
  final List<String>? availableSlots;

  @override
  State<AddAppointmentSheet> createState() => _AddAppointmentSheetState();
}

class _AddAppointmentSheetState extends State<AddAppointmentSheet> {
  final _patientController = TextEditingController();
  bool _isVideo = false;
  int _branchIndex = 0;
  int _serviceIndex = 0;
  int _doctorIndex = 0;
  late String _slot = (widget.availableSlots?.isNotEmpty ?? false)
      ? widget.availableSlots!.first
      : _kFallbackSlots.first;

  @override
  void dispose() {
    _patientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slots = widget.availableSlots?.isNotEmpty ?? false ? widget.availableSlots! : _kFallbackSlots;
    final service = _kServices[_serviceIndex];

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
            AppText(LocaleKeys.appt_title.tr(),
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            if (widget.dateLabel != null)
              AppText(widget.dateLabel!, fontSize: 12, color: AppColors.mutedColor.themeColor),
            16.height,
            _label(LocaleKeys.appt_patientLabel.tr()),
            8.height,
            CustomTextField(controller: _patientController, hint: LocaleKeys.appt_patientHint.tr()),
            14.height,
            _label(LocaleKeys.appt_typeLabel.tr()),
            8.height,
            Row(children: [
              Expanded(
                child: AppToggleChip(
                  label: LocaleKeys.appt_typeClinic.tr(),
                  selected: !_isVideo,
                  onTap: () => setState(() => _isVideo = false),
                ),
              ),
              8.width,
              Expanded(
                child: AppToggleChip(
                  label: LocaleKeys.appt_typeVideo.tr(),
                  selected: _isVideo,
                  onTap: () => setState(() => _isVideo = true),
                ),
              ),
            ]),
            if (!_isVideo) ...[
              14.height,
              _label(LocaleKeys.appt_branchLabel.tr()),
              8.height,
              Wrap(
                spacing: 7.w,
                runSpacing: 7.h,
                children: [
                  for (var i = 0; i < _kBranches.length; i++)
                    AppToggleChip(
                      label: _kBranches[i].label,
                      selected: _branchIndex == i,
                      onTap: () => setState(() => _branchIndex = i),
                    ),
                ],
              ),
            ],
            14.height,
            _label(LocaleKeys.appt_serviceLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (var i = 0; i < _kServices.length; i++)
                  AppToggleChip(
                    label: '${_kServices[i].label} · ${_kServices[i].price}',
                    selected: _serviceIndex == i,
                    onTap: () => setState(() => _serviceIndex = i),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.appt_doctorLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (var i = 0; i < _kDoctors.length; i++)
                  AppToggleChip(
                    label: _kDoctors[i].label,
                    selected: _doctorIndex == i,
                    onTap: () => setState(() => _doctorIndex = i),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.appt_timeLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (final s in slots)
                  AppToggleChip(label: s, selected: _slot == s, onTap: () => setState(() => _slot = s)),
              ],
            ),
            16.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(LocaleKeys.appt_totalLabel.tr(),
                      fontSize: 12, color: AppColors.mutedColor.themeColor),
                  AppText('${service.price} ${LocaleKeys.common_currency.tr()}',
                      isHeading: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor.themeColor),
                ],
              ),
            ),
            16.height,
            CustomButton(
              onTap: () {
                final name = _patientController.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(context);
                widget.onSubmit(name, service.label, service.price ?? 0);
              },
              title: LocaleKeys.appt_confirm.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
