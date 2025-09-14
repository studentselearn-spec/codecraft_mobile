import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NewProjectBottomSheet extends StatelessWidget {
  final VoidCallback onCloneRepository;
  final VoidCallback onCreateNew;
  final VoidCallback onImportFromDevice;
  final VoidCallback onUseTemplate;

  const NewProjectBottomSheet({
    super.key,
    required this.onCloneRepository,
    required this.onCreateNew,
    required this.onImportFromDevice,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'New Project',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how you want to start your new project',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          _buildOptionTile(
            context,
            icon: Icons.download,
            title: 'Clone Repository',
            subtitle: 'Clone an existing repository from GitHub',
            onTap: () {
              Navigator.pop(context);
              onCloneRepository();
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.add_circle,
            title: 'Create New',
            subtitle: 'Start a new project from scratch',
            onTap: () {
              Navigator.pop(context);
              onCreateNew();
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.folder_open,
            title: 'Import from Device',
            subtitle: 'Import an existing project from your device',
            onTap: () {
              Navigator.pop(context);
              onImportFromDevice();
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.library_books,
            title: 'Use Template',
            subtitle: 'Start with a pre-built project template',
            onTap: () {
              Navigator.pop(context);
              onUseTemplate();
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: _getIconName(icon),
            color: AppTheme.primaryLight,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textDisabledLight,
          size: 20,
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.download) return 'download';
    if (icon == Icons.add_circle) return 'add_circle';
    if (icon == Icons.folder_open) return 'folder_open';
    if (icon == Icons.library_books) return 'library_books';
    return 'add';
  }
}
