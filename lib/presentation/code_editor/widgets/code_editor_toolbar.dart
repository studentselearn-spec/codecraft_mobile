import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CodeEditorToolbar extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onSearch;
  final bool hasUnsavedChanges;

  const CodeEditorToolbar({
    super.key,
    this.onSave,
    this.onUndo,
    this.onRedo,
    this.onSearch,
    this.hasUnsavedChanges = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'main.dart',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 2.w),
                  if (hasUnsavedChanges)
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToolbarButton(
                iconName: 'search',
                onTap: onSearch,
                tooltip: 'Search & Replace',
              ),
              SizedBox(width: 2.w),
              _buildToolbarButton(
                iconName: 'undo',
                onTap: onUndo,
                tooltip: 'Undo',
              ),
              SizedBox(width: 2.w),
              _buildToolbarButton(
                iconName: 'redo',
                onTap: onRedo,
                tooltip: 'Redo',
              ),
              SizedBox(width: 2.w),
              _buildToolbarButton(
                iconName: 'save',
                onTap: onSave,
                tooltip: 'Save',
                isHighlighted: hasUnsavedChanges,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required String iconName,
    VoidCallback? onTap,
    String? tooltip,
    bool isHighlighted = false,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            size: 5.w,
            color: isHighlighted
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
