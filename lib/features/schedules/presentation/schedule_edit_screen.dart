import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toggle_chip.dart';
import '../data/models/work_schedule_model.dart';

const _kServices = ['كشف باطنة', 'متابعة', 'كشف جديدة', 'كشف أسنان', 'كشف أطفال'];
const _kBranches = ['فرع العليا', 'فرع المرجس', 'فرع الياسمين'];
const _kAreas = ['العليا', 'المرجس', 'الياسمين', 'النخيل'];

class _Day {
  const _Day(this.key, this.label);
  final String key;
  final String label;
}

/// The reference design's `#schedule` — the full-screen slot editor reached
/// from `sh-doc`'s "إعداد جدول العمل" and from a `WorkScheduleTile`'s
/// "تعديل" button (via `sh-newsch` for a brand-new schedule).
class ScheduleEditScreen extends StatefulWidget {
  const ScheduleEditScreen({
    super.key,
    required this.doctorName,
    required this.doctorInitial,
    required this.mode,
    required this.onSave,
    this.existing,
  });

  final String doctorName;
  final String doctorInitial;
  final WorkScheduleMode mode;
  final ValueChanged<WorkScheduleModel> onSave;
  final WorkScheduleModel? existing;

  @override
  State<ScheduleEditScreen> createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> {
  final Set<String> _selectedServices = {_kServices.first};
  int _branchIndex = 0;
  final Set<String> _selectedAreas = {_kAreas.first};
  bool _instantConsult = true;
  late final _fromController = TextEditingController(text: '09:00');
  late final _toController = TextEditingController(text: '17:00');

  late final List<_Day> _days = [
    _Day('sat', LocaleKeys.scheduleEditor_daySat.tr()),
    _Day('sun', LocaleKeys.scheduleEditor_daySun.tr()),
    _Day('mon', LocaleKeys.scheduleEditor_dayMon.tr()),
    _Day('tue', LocaleKeys.scheduleEditor_dayTue.tr()),
    _Day('wed', LocaleKeys.scheduleEditor_dayWed.tr()),
    _Day('thu', LocaleKeys.scheduleEditor_dayThu.tr()),
    _Day('fri', LocaleKeys.scheduleEditor_dayFri.tr()),
  ];
  late final Set<String> _selectedDays = {'sat', 'sun', 'mon', 'tue', 'wed'};

  int get _slotDuration => switch (widget.mode) {
        WorkScheduleMode.clinic => 20,
        WorkScheduleMode.online => 15,
        WorkScheduleMode.home => 45,
      };

  String get _unitLabel => switch (widget.mode) {
        WorkScheduleMode.clinic => LocaleKeys.scheduleEditor_unitClinic.tr(),
        WorkScheduleMode.online => LocaleKeys.scheduleEditor_unitOnline.tr(),
        WorkScheduleMode.home => LocaleKeys.scheduleEditor_unitHome.tr(),
      };

  int? _minutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  int get _slotsPerDay {
    final from = _minutes(_fromController.text);
    final to = _minutes(_toController.text);
    if (from == null || to == null || to <= from) return 0;
    return ((to - from) / _slotDuration).floor().clamp(0, 999);
  }

  String get _daysLabel {
    final ordered = [for (final d in _days) if (_selectedDays.contains(d.key)) d.label];
    if (ordered.isEmpty) return '';
    if (ordered.length == 1) return ordered.first;
    return '${ordered.first} — ${ordered.last}';
  }

  String get _note => switch (widget.mode) {
        WorkScheduleMode.clinic => _kBranches[_branchIndex],
        WorkScheduleMode.online =>
          _instantConsult ? LocaleKeys.scheduleEditor_onlineNowLabel.tr() : LocaleKeys.schedules_modeOnline.tr(),
        WorkScheduleMode.home => _selectedAreas.join('، '),
      };

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _fromController.text = _splitHours(existing.hoursLabel).$1;
      _toController.text = _splitHours(existing.hoursLabel).$2;
    }
  }

  static (String, String) _splitHours(String hours) {
    final parts = hours.split('—');
    return (
      parts.isNotEmpty ? parts.first.trim() : '09:00',
      parts.length > 1 ? parts[1].trim() : '17:00',
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _save() {
    final model = WorkScheduleModel(
      id: widget.existing?.id ?? 'sc-${DateTime.now().millisecondsSinceEpoch}',
      doctorName: widget.doctorName,
      doctorInitial: widget.doctorInitial,
      mode: widget.mode,
      note: _note.isEmpty ? '—' : _note,
      daysLabel: _daysLabel.isEmpty ? '—' : _daysLabel,
      hoursLabel: '${_fromController.text} — ${_toController.text}',
      slotCount: _slotsPerDay,
      unitLabel: _unitLabel,
    );
    Navigator.pop(context);
    widget.onSave(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            AppScreenHeader(
              title: LocaleKeys.scheduleEditor_title.tr(),
              eyebrow: widget.doctorName,
              leading: AppHeaderIconButton(
                svgIcon: AppSvgIcons.chevronBack,
                size: 38,
                onTap: () => Navigator.pop(context),
              ),
            ),
            16.height,
            _label(LocaleKeys.scheduleEditor_servicesLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (final s in _kServices)
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
            14.height,
            if (widget.mode == WorkScheduleMode.clinic) ...[
              _label(LocaleKeys.scheduleEditor_branchLabel.tr()),
              8.height,
              Wrap(
                spacing: 7.w,
                runSpacing: 7.h,
                children: [
                  for (var i = 0; i < _kBranches.length; i++)
                    AppToggleChip(
                      label: _kBranches[i],
                      selected: _branchIndex == i,
                      onTap: () => setState(() => _branchIndex = i),
                    ),
                ],
              ),
              14.height,
            ],
            if (widget.mode == WorkScheduleMode.online) ...[
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(LocaleKeys.scheduleEditor_onlineNowLabel.tr(),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          AppText(LocaleKeys.scheduleEditor_onlineNowSub.tr(),
                              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                    Switch(
                      value: _instantConsult,
                      onChanged: (v) => setState(() => _instantConsult = v),
                      activeThumbColor: AppColors.primaryColor.themeColor,
                    ),
                  ],
                ),
              ),
              14.height,
            ],
            if (widget.mode == WorkScheduleMode.home) ...[
              _label(LocaleKeys.scheduleEditor_coverageLabel.tr()),
              8.height,
              Wrap(
                spacing: 7.w,
                runSpacing: 7.h,
                children: [
                  for (final a in _kAreas)
                    AppToggleChip(
                      label: a,
                      selected: _selectedAreas.contains(a),
                      onTap: () => setState(
                        () => _selectedAreas.contains(a)
                            ? _selectedAreas.remove(a)
                            : _selectedAreas.add(a),
                      ),
                    ),
                ],
              ),
              14.height,
            ],
            _label(LocaleKeys.scheduleEditor_daysLabel.tr()),
            8.height,
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                for (final d in _days)
                  AppToggleChip(
                    label: d.label,
                    selected: _selectedDays.contains(d.key),
                    onTap: () => setState(
                      () => _selectedDays.contains(d.key)
                          ? _selectedDays.remove(d.key)
                          : _selectedDays.add(d.key),
                    ),
                  ),
              ],
            ),
            14.height,
            _label(LocaleKeys.scheduleEditor_hoursLabel.tr()),
            8.height,
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _fromController,
                    hint: LocaleKeys.scheduleEditor_hoursFrom.tr(),
                    label: LocaleKeys.scheduleEditor_hoursFrom.tr(),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                10.width,
                Expanded(
                  child: CustomTextField(
                    controller: _toController,
                    hint: LocaleKeys.scheduleEditor_hoursTo.tr(),
                    label: LocaleKeys.scheduleEditor_hoursTo.tr(),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
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
              child: AppText(
                LocaleKeys.scheduleEditor_slotsFormula.tr(namedArgs: {
                  'days': '${_selectedDays.length}',
                  'hours': '${_fromController.text} — ${_toController.text}',
                  'count': '$_slotsPerDay',
                }),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor.themeColor,
              ),
            ),
            18.height,
            CustomButton(onTap: _save, title: LocaleKeys.scheduleEditor_save.tr()),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      AppText(text, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor);
}
