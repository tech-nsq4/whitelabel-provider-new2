import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_toggle_chip.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../branches/logic/branches_cubit.dart';
import '../../data/models/queue_filter.dart';

class QueueFilterSheet extends StatefulWidget {
  const QueueFilterSheet({super.key, required this.current});

  final QueueFilter current;

  @override
  State<QueueFilterSheet> createState() => _QueueFilterSheetState();
}

class _QueueFilterSheetState extends State<QueueFilterSheet> {
  late final _branchesCubit = getIt<BranchesCubit>()..loadLocations();

  int? _clinicId;
  String? _clinicName;

  @override
  void initState() {
    super.initState();
    _clinicId = widget.current.clinicId;
    _clinicName = widget.current.clinicName;
  }

  @override
  void dispose() {
    _branchesCubit.close();
    super.dispose();
  }

  void _apply() {
    Navigator.pop(
      context,
      QueueFilter(clinicId: _clinicId, clinicName: _clinicName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
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
              AppText(LocaleKeys.queue_filterTitle.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor),
              const Spacer(),
              SizedBox(
                width: 44.w,
                child: _clinicId != null
                    ? CustomTapEffect(
                        onTap: () => setState(() {
                          _clinicId = null;
                          _clinicName = null;
                        }),
                        child: AppText(LocaleKeys.queue_filterClear.tr(),
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
          AppText(LocaleKeys.queue_filterBranch.tr(),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedColor.themeColor),
          12.height,
          Flexible(child: SingleChildScrollView(child: _branchChips())),
          20.height,
          CustomButton(
            onTap: _apply,
            title: LocaleKeys.queue_filterApply.tr(),
          ),
        ],
      ),
    );
  }

  Widget _branchChips() {
    return BlocBuilder<BranchesCubit, BranchesState>(
      bloc: _branchesCubit,
      builder: (context, state) {
        if (state is BranchesLoading || state is BranchesInitial) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
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
            child: AppText(LocaleKeys.queue_filterEmptyBranches.tr(),
                fontSize: 12, color: AppColors.mutedColor.themeColor),
          );
        }

        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            AppToggleChip(
              label: LocaleKeys.queue_filterAllBranches.tr(),
              selected: _clinicId == null,
              onTap: () => setState(() {
                _clinicId = null;
                _clinicName = null;
              }),
            ),
            for (final location in locations)
              AppToggleChip(
                label: location.name,
                selected: _clinicId == location.id,
                onTap: () => setState(() {
                  _clinicId = location.id;
                  _clinicName = location.name;
                }),
              ),
          ],
        );
      },
    );
  }
}
