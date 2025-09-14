import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GitConfigurationWidget extends StatelessWidget {
  final Map<String, dynamic> gitConfig;
  final Function(String, String) onConfigChanged;

  const GitConfigurationWidget({
    Key? key,
    required this.gitConfig,
    required this.onConfigChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Git Configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          _buildConfigItem(
            context,
            'Default Author',
            gitConfig['author'] as String,
            'person',
            () => _showEditDialog(
                context, 'author', gitConfig['author'] as String),
          ),
          SizedBox(height: 1.5.h),
          _buildConfigItem(
            context,
            'GPG Signing',
            gitConfig['gpgSigning'] as bool ? 'Enabled' : 'Disabled',
            'security',
            () => onConfigChanged(
                'gpgSigning', (!(gitConfig['gpgSigning'] as bool)).toString()),
          ),
          SizedBox(height: 1.5.h),
          _buildConfigItem(
            context,
            'Merge Strategy',
            gitConfig['mergeStrategy'] as String,
            'merge_type',
            () => _showMergeStrategyDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(
    BuildContext context,
    String title,
    String value,
    String iconName,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String key, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${key == 'author' ? 'Default Author' : key}'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: key == 'author' ? 'Author Name' : key,
              hintText: key == 'author' ? 'John Doe <john@example.com>' : '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onConfigChanged(key, controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showMergeStrategyDialog(BuildContext context) {
    final strategies = ['Fast-forward', 'No fast-forward', 'Squash'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Merge Strategy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: strategies.map((strategy) {
              return RadioListTile<String>(
                title: Text(strategy),
                value: strategy,
                groupValue: gitConfig['mergeStrategy'] as String,
                onChanged: (String? value) {
                  if (value != null) {
                    onConfigChanged('mergeStrategy', value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
