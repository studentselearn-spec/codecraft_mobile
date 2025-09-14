import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BuildCardWidget extends StatelessWidget {
  final Map<String, dynamic> buildData;
  final VoidCallback? onViewLogs;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onCancel;

  const BuildCardWidget({
    Key? key,
    required this.buildData,
    this.onViewLogs,
    this.onDownload,
    this.onShare,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = buildData['status'] as String;
    final progress = buildData['progress'] as double? ?? 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(buildData['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onViewLogs?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.article,
              label: 'Logs',
            ),
            if (status == 'Success') ...[
              SlidableAction(
                onPressed: (_) => onDownload?.call(),
                backgroundColor: AppTheme.successLight,
                foregroundColor: Colors.white,
                icon: Icons.download,
                label: 'Download',
              ),
              SlidableAction(
                onPressed: (_) => onShare?.call(),
                backgroundColor: AppTheme.accentLight,
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
            ],
            if (status == 'Building')
              SlidableAction(
                onPressed: (_) => onCancel?.call(),
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
                icon: Icons.cancel,
                label: 'Cancel',
              ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPlatformIcon(buildData['platform'] as String),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Build #${buildData['buildNumber']}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            buildData['commitHash'] as String,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'monospace',
                                      color: isDark
                                          ? AppTheme.textMediumEmphasisDark
                                          : AppTheme.textMediumEmphasisLight,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(status, isDark),
                  ],
                ),
                SizedBox(height: 2.h),
                if (status == 'Building') ...[
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% complete',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'ETA: ${buildData['eta']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      size: 16,
                      color: isDark
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatTimestamp(buildData['timestamp'] as DateTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Spacer(),
                    if (buildData['buildType'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppTheme.secondaryDark
                                  : AppTheme.secondaryLight)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          buildData['buildType'] as String,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isDark
                                        ? AppTheme.secondaryDark
                                        : AppTheme.secondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(String platform) {
    String iconName;
    Color iconColor;

    switch (platform.toLowerCase()) {
      case 'ios':
        iconName = 'phone_iphone';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'android':
        iconName = 'android';
        iconColor = Colors.green;
        break;
      case 'web':
        iconName = 'web';
        iconColor = AppTheme.accentLight;
        break;
      default:
        iconName = 'devices';
        iconColor = AppTheme.secondaryLight;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        size: 24,
        color: iconColor,
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color backgroundColor;
    Color textColor;
    String iconName;

    switch (status.toLowerCase()) {
      case 'building':
        backgroundColor = AppTheme.warningLight;
        textColor = Colors.white;
        iconName = 'build';
        break;
      case 'success':
        backgroundColor = AppTheme.successLight;
        textColor = Colors.white;
        iconName = 'check_circle';
        break;
      case 'failed':
        backgroundColor = AppTheme.errorLight;
        textColor = Colors.white;
        iconName = 'error';
        break;
      case 'cancelled':
        backgroundColor = isDark
            ? AppTheme.textMediumEmphasisDark
            : AppTheme.textMediumEmphasisLight;
        textColor = Colors.white;
        iconName = 'cancel';
        break;
      default:
        backgroundColor = AppTheme.secondaryLight;
        textColor = Colors.white;
        iconName = 'info';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 16,
            color: textColor,
          ),
          SizedBox(width: 1.w),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}