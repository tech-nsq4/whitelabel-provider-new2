import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../branches/logic/branches_cubit.dart';
import '../../data/models/orders_filter.dart';

class OrdersFilterSheet extends StatefulWidget {
  const OrdersFilterSheet({super.key, required this.current});

  final OrdersFilter current;

  @override
  State<OrdersFilterSheet> createState() => _OrdersFilterSheetState();
}

class _OrdersFilterSheetState extends State<OrdersFilterSheet> {
  late final _branchesCubit = getIt<BranchesCubit>()..loadLocations();

  int? _locationId;
  String? _locationName;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _locationId = widget.current.locationId;
    _locationName = widget.current.locationName;
    final from = DateTime.tryParse(widget.current.dateFrom ?? '');
    final to = DateTime.tryParse(widget.current.dateTo ?? '');
    if (from != null && to != null) {
      _range = DateTimeRange(start: from, end: to);
    }
  }

  @override
  void dispose() {
    _branchesCubit.close();
    super.dispose();
  }

  bool get _dirtyOrSet => _locationId != null || _range != null;

  static String _iso(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _range = picked);
  }

  void _apply() {
    Navigator.pop(
      context,
      OrdersFilter(
        locationId: _locationId,
        locationName: _locationName,
        dateFrom: _range == null ? null : _iso(_range!.start),
        dateTo: _range == null ? null : _iso(_range!.end),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(4.r)),
            ),
          ),
          16.height,
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 18.sp,
                      color: AppColors.textSecondaryColor.themeColor),
                ),
              ),
              const Spacer(),
              AppText(LocaleKeys.orders_filterTitle.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor),
              const Spacer(),
              SizedBox(
                width: 44.w,
                child: _dirtyOrSet
                    ? CustomTapEffect(
                        onTap: () => setState(() {
                          _locationId = null;
                          _locationName = null;
                          _range = null;
                        }),
                        child: AppText(LocaleKeys.orders_filterClear.tr(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.end,
                            color: AppColors.errorColor.themeColor),
                      )
                    : null,
              ),
            ],
          ),
          20.height,
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(LocaleKeys.orders_filterBranch.tr()),
                  10.height,
                  _branchList(),
                  20.height,
                  _sectionLabel(LocaleKeys.orders_filterDate.tr()),
                  10.height,
                  _dateField(),
                ],
              ),
            ),
          ),
          20.height,
          CustomButton(
            onTap: _apply,
            title: LocaleKeys.orders_filterApply.tr(),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => AppText(text,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.mutedColor.themeColor);

  Widget _branchList() {
    return BlocBuilder<BranchesCubit, BranchesState>(
      bloc: _branchesCubit,
      builder: (context, state) {
        if (state is BranchesLoading || state is BranchesInitial) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: CustomLoadingWidget(
                  color: AppColors.primaryColor.themeColor, size: 26),
            ),
          );
        }
        if (state is BranchesError) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppText(state.message,
                fontSize: 12, color: AppColors.errorColor.themeColor),
          );
        }

        final locations = (state as BranchesSuccess).locations;
        if (locations.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppText(LocaleKeys.orders_filterEmptyBranches.tr(),
                fontSize: 12, color: AppColors.mutedColor.themeColor),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 240.h),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              _SelectRow(
                label: LocaleKeys.orders_filterAllBranches.tr(),
                selected: _locationId == null,
                onTap: () => setState(() {
                  _locationId = null;
                  _locationName = null;
                }),
              ),
              for (final location in locations) ...[
                8.height,
                _SelectRow(
                  label: location.name,
                  subtitle: [location.areaName, location.cityName]
                      .whereType<String>()
                      .join('، '),
                  selected: _locationId == location.id,
                  onTap: () => setState(() {
                    _locationId = location.id;
                    _locationName = location.name;
                  }),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _dateField() {
    final range = _range;
    final hasDate = range != null;
    final label = range == null
        ? LocaleKeys.orders_filterAnyDate.tr()
        : ConvertHelper.formatDateRange(_iso(range.start), _iso(range.end));

    return CustomTapEffect(
      onTap: _pickRange,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: hasDate
                ? AppColors.primaryColor.themeColor
                : AppColors.dividerColor.themeColor,
            width: hasDate ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            AppSvgIcon(AppSvgIcons.calendar,
                size: 17.sp,
                color: hasDate
                    ? AppColors.primaryColor.themeColor
                    : AppColors.mutedColor.themeColor),
            10.width,
            Expanded(
              child: AppText(label,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: hasDate
                      ? AppColors.textPrimaryColor.themeColor
                      : AppColors.mutedColor.themeColor),
            ),
            if (hasDate)
              GestureDetector(
                onTap: () => setState(() => _range = null),
                child: Icon(Icons.close_rounded,
                    size: 17.sp, color: AppColors.mutedColor.themeColor),
              )
            else
              AppSvgIcon(AppSvgIcons.chevronBack,
                  size: 13.sp, color: AppColors.mutedColor.themeColor),
          ],
        ),
      ),
    );
  }
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final showSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.06)
              : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? primary : AppColors.dividerColor.themeColor,
            width: selected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(label,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? primary
                          : AppColors.textPrimaryColor.themeColor),
                  if (showSubtitle) ...[
                    2.height,
                    AppText(subtitle!,
                        fontSize: 10.5,
                        color: AppColors.mutedColor.themeColor),
                  ],
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20.sp,
              color: selected ? primary : AppColors.hintColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
