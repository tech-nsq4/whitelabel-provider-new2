import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class ExpandablePanel extends StatefulWidget {
  const ExpandablePanel({
    super.key,
    required this.header,
    required this.child,
    this.initiallyExpanded = false,
    this.boxed = true,
  });

  final Widget header;
  final Widget child;
  final bool initiallyExpanded;
  final bool boxed;

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTapEffect(
          onTap: _toggle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: widget.boxed ? 0 : 12.h),
            child: Row(
              children: [
                Expanded(child: widget.header),
                8.width,
                AnimatedRotation(
                  turns: _expanded ? -0.25 : 0,
                  duration: AppConstants.shortAnimationDuration,
                  child: AppSvgIcon(
                    AppSvgIcons.chevronRow,
                    size: 16,
                    color: AppColors.hintColor.themeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: AppConstants.shortAnimationDuration,
          alignment: Alignment.topCenter,
          curve: Curves.easeOut,
          child: _expanded
              ? Padding(padding: 12.paddingBottom, child: widget.child)
              : const SizedBox(width: double.infinity),
        ),
      ],
    );

    if (widget.boxed) {
      return AppCard(margin: 12.paddingBottom, child: body);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.dividerColor.themeColor),
        ),
      ),
      child: body,
    );
  }
}
