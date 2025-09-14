import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SecuritySectionWidget extends StatelessWidget {
  final bool biometricAuth;
  final String sessionTimeout;
  final Function(bool) onBiometricChanged;
  final Function(String) onSessionTimeoutChanged;
  final VoidCallback onClearData;

  const SecuritySectionWidget({
    Key? key,
    required this.biometricAuth,
    required this.sessionTimeout,
    required this.onBiometricChanged,
    required this.onSessionTimeoutChanged,
    required this.onClearData,
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
            'Security',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          _buildSwitchTile(
            context,
            'Biometric Authentication',
            'Use fingerprint or face recognition',
            biometricAuth,
            onBiometricChanged,
            'fingerprint',
          ),
          SizedBox(height: 1.5.h),
          _buildSessionTimeoutTile(context),
          SizedBox(height: 1.5.h),
          _buildClearDataTile(context),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    String iconName,
  ) {
    return Row(
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
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSessionTimeoutTile(BuildContext context) {
    return InkWell(
      onTap: () => _showSessionTimeoutDialog(context),
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
              iconName: 'timer',
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session Timeout',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    sessionTimeout,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
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

  Widget _buildClearDataTile(BuildContext context) {
    return InkWell(
      onTap: () => _showClearDataDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'delete_forever',
              size: 20,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clear Secure Data',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  Text(
                    'Remove all stored credentials',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              size: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionTimeoutDialog(BuildContext context) {
    final timeouts = ['15 minutes', '30 minutes', '1 hour', '2 hours', 'Never'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Timeout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeouts.map((timeout) {
              return RadioListTile<String>(
                title: Text(timeout),
                value: timeout,
                groupValue: sessionTimeout,
                onChanged: (String? value) {
                  if (value != null) {
                    onSessionTimeoutChanged(value);
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

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                size: 24,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: 2.w),
              Text('Clear Secure Data'),
            ],
          ),
          content: Text(
            'This will permanently remove all stored credentials, tokens, and secure data. You will need to re-authenticate with all services.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClearData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Secure data cleared successfully'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text('Clear Data'),
            ),
          ],
        );
      },
    );
  }
}
