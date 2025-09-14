import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityFeedWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const ActivityFeedWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.primaryLight,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            height: 20.h,
            child: activities.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return _buildActivityCard(context, activity);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'timeline',
            color: AppTheme.textDisabledLight,
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            'No recent activity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDisabledLight,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, Map<String, dynamic> activity) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildActivityIcon(activity['type'] ?? 'commit'),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      activity['title'] ?? 'Unknown Activity',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                activity['description'] ?? 'No description',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    activity['project'] ?? 'Unknown Project',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(activity['timestamp']),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textDisabledLight,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'commit':
        iconData = Icons.commit;
        iconColor = AppTheme.primaryLight;
        break;
      case 'deploy':
        iconData = Icons.rocket_launch;
        iconColor = AppTheme.successLight;
        break;
      case 'build':
        iconData = Icons.build;
        iconColor = AppTheme.warningLight;
        break;
      case 'error':
        iconData = Icons.error;
        iconColor = AppTheme.errorLight;
        break;
      default:
        iconData = Icons.info;
        iconColor = AppTheme.secondaryLight;
        break;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomIconWidget(
        iconName: _getIconName(iconData),
        color: iconColor,
        size: 16,
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.commit) return 'commit';
    if (icon == Icons.rocket_launch) return 'rocket_launch';
    if (icon == Icons.build) return 'build';
    if (icon == Icons.error) return 'error';
    return 'info';
  }
}
