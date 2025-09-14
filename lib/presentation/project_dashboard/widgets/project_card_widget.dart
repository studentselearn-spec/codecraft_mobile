import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onTap;
  final VoidCallback onClone;
  final VoidCallback onArchive;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onRename;
  final VoidCallback onChangeBranch;
  final VoidCallback onViewOnGitHub;
  final VoidCallback onOfflineSettings;

  const ProjectCardWidget({
    super.key,
    required this.project,
    required this.onTap,
    required this.onClone,
    required this.onArchive,
    required this.onShare,
    required this.onDelete,
    required this.onRename,
    required this.onChangeBranch,
    required this.onViewOnGitHub,
    required this.onOfflineSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(project['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onClone(),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.download,
              label: 'Clone',
            ),
            SlidableAction(
              onPressed: (_) => onArchive(),
              backgroundColor: AppTheme.warningLight,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              onPressed: (_) => onShare(),
              backgroundColor: AppTheme.accentLight,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
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
                      Expanded(
                        child: Text(
                          project['name'] ?? 'Unknown Project',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildSyncStatusIndicator(),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildLanguageBadge(project['language'] ?? 'Unknown'),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Last commit: ${_formatTime(project['lastCommit'])}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    project['description'] ?? 'No description available',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusIndicator() {
    final status = project['syncStatus'] ?? 'synced';
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'syncing':
        statusColor = AppTheme.warningLight;
        statusIcon = Icons.sync;
        break;
      case 'error':
        statusColor = AppTheme.errorLight;
        statusIcon = Icons.sync_problem;
        break;
      case 'synced':
      default:
        statusColor = AppTheme.successLight;
        statusIcon = Icons.check_circle;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getIconName(statusIcon),
            color: statusColor,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBadge(String language) {
    final languageColors = {
      'Dart': AppTheme.primaryLight,
      'JavaScript': Colors.yellow.shade700,
      'Python': Colors.blue.shade700,
      'Java': Colors.orange.shade700,
      'Swift': Colors.orange.shade600,
      'Kotlin': Colors.purple.shade700,
      'TypeScript': Colors.blue.shade600,
    };

    final color = languageColors[language] ?? AppTheme.secondaryLight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        language,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
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
    if (icon == Icons.sync) return 'sync';
    if (icon == Icons.sync_problem) return 'sync_problem';
    if (icon == Icons.check_circle) return 'check_circle';
    return 'check_circle';
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
            SizedBox(height: 2.h),
            Text(
              project['name'] ?? 'Project Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(context, Icons.edit, 'Rename', onRename),
            _buildContextMenuItem(
                context, Icons.alt_route, 'Change Branch', onChangeBranch),
            _buildContextMenuItem(
                context, Icons.open_in_new, 'View on GitHub', onViewOnGitHub),
            _buildContextMenuItem(context, Icons.offline_pin,
                'Offline Settings', onOfflineSettings),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: _getIconName(icon),
        color: AppTheme.textMediumEmphasisLight,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
