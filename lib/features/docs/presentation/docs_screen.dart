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
import '../data/models/document_record_model.dart';
import '../logic/docs_cubit.dart';
import 'widgets/doc_record_tile.dart';
import 'widgets/issue_document_sheet.dart';

/// "التقارير والإجازات" — issued and pending sick leaves / medical reports.
class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  late final _cubit = getIt<DocsCubit>()..loadDocs();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openIssue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IssueDocumentSheet(
        onSubmit: (type, name, detail) => AppOverlay.showSuccess(
          LocaleKeys.docsScreen_issueSuccess.tr(namedArgs: {'type': type, 'name': name}),
        ),
      ),
    );
  }

  void _onAction(DocumentRecordModel doc) {
    if (doc.status == DocumentStatus.pendingIssue) {
      _cubit.markIssued(doc.id);
      AppOverlay.showSuccess(LocaleKeys.docsScreen_certifySuccess.tr(namedArgs: {'title': doc.title}));
    } else {
      AppOverlay.showSuccess(LocaleKeys.docsScreen_downloadToast.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DocsCubit, DocsState>(
          bloc: _cubit,
          builder: (context, state) {
            return CustomScreenStateLayout(
              isLoading: state is DocsLoading || state is DocsInitial,
              error: state is DocsError
                  ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                  : null,
              builder: (context) {
                final docs = (state as DocsSuccess).docs;
                return ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
                  children: [
                    AppScreenHeader(
                      title: LocaleKeys.docsScreen_title.tr(),
                      leading: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.chevronBack,
                        size: 38,
                        onTap: () => Navigator.pop(context),
                      ),
                      trailing: AppHeaderIconButton(
                        svgIcon: AppSvgIcons.plus,
                        color: AppColors.primaryColor.themeColor,
                        onTap: _openIssue,
                      ),
                    ),
                    18.height,
                    for (final doc in docs) DocRecordTile(doc: doc, onAction: () => _onAction(doc)),
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
