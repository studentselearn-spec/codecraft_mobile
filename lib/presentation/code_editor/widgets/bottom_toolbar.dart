import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomToolbar extends StatelessWidget {
  final Function(String)? onSymbolInsert;
  final VoidCallback? onIndentIncrease;
  final VoidCallback? onIndentDecrease;

  const BottomToolbar({
    super.key,
    this.onSymbolInsert,
    this.onIndentIncrease,
    this.onIndentDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Programming symbols row
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Row(
                children: _buildSymbolButtons(),
              ),
            ),
          ),
          // Indentation controls
          Container(
            height: 6.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                _buildControlButton(
                  label: 'Tab',
                  onTap: onIndentIncrease,
                  icon: 'keyboard_tab',
                ),
                SizedBox(width: 2.w),
                _buildControlButton(
                  label: 'Untab',
                  onTap: onIndentDecrease,
                  icon: 'keyboard_backspace',
                ),
                const Spacer(),
                Text(
                  'Ln 1, Col 1',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSymbolButtons() {
    final symbols = [
      '{',
      '}',
      '(',
      ')',
      '[',
      ']',
      '<',
      '>',
      ';',
      ':',
      ',',
      '.',
      '=',
      '+',
      '-',
      '*',
      '/',
      '%',
      '&',
      '|',
      '!',
      '?',
      '"',
      "'",
      '@',
      '#',
      '\$',
      '^',
      '~',
      '`',
    ];

    return symbols.map((symbol) {
      return Padding(
        padding: EdgeInsets.only(right: 1.w),
        child: _buildSymbolButton(symbol),
      );
    }).toList();
  }

  Widget _buildSymbolButton(String symbol) {
    return InkWell(
      onTap: () => onSymbolInsert?.call(symbol),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 10.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    VoidCallback? onTap,
    String? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CustomIconWidget(
                iconName: icon,
                size: 4.w,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
