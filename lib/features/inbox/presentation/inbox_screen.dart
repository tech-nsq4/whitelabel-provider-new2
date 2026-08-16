import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_header_icon_button.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/pending_result_model.dart';
import '../logic/inbox_cubit.dart';
import 'widgets/inbox_result_tile.dart';
import 'widgets/inbox_review_sheet.dart';

/// "نتائج تنتظر مراجعتك" — results awaiting the doctor's sign-off before
/// the patient sees them.
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final _cubit = getIt<InboxCubit>()..loadPending();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openReview(PendingResultModel result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InboxReviewSheet(
        result: result,
        onApprove: () {
          _cubit.approve(result.id);
          AppOverlay.showSuccess(LocaleKeys.inbox_approveSuccess.tr());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<InboxCubit, InboxState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is InboxLoading || state is InboxInitial,
              error: state is InboxError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              isEmpty: state is InboxSuccess && state.results.isEmpty,
              builder: (context) {
                final results = (state as InboxSuccess).results;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.inbox_title.tr(),
                      eyebrow: LocaleKeys.inbox_subtitle.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    18.height,
                    for (final result in results)
                      InboxResultTile(result: result, onTap: () => _openReview(result)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
