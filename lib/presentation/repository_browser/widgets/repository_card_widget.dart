import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RepositoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> repository;
  final VoidCallback? onTap;
  final VoidCallback? onClone;
  final VoidCallback? onStar;
  final VoidCallback? onFork;
  final VoidCallback? onShare;

  const RepositoryCardWidget({
    Key? key,
    required this.repository,
    this.onTap,
    this.onClone,
    this.onStar,
    this.onFork,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(repository['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onClone?.call(),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.download,
              label: 'Clone',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onStar?.call(),
              backgroundColor: AppTheme.warningLight,
              foregroundColor: Colors.white,
              icon: Icons.star,
              label: 'Star',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.successLight,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repository['name'] as String? ??
                                  'Unknown Repository',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppTheme.textHighEmphasisDark
                                        : AppTheme.textHighEmphasisLight,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              repository['owner'] as String? ?? 'Unknown Owner',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppTheme.textMediumEmphasisDark
                                        : AppTheme.textMediumEmphasisLight,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: repository['isPrivate'] == true
                              ? AppTheme.warningLight.withValues(alpha: 0.1)
                              : AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          repository['isPrivate'] == true
                              ? 'Private'
                              : 'Public',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: repository['isPrivate'] == true
                                        ? AppTheme.warningLight
                                        : AppTheme.successLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  if (repository['description'] != null &&
                      (repository['description'] as String).isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      repository['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      if (repository['language'] != null) ...[
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: _getLanguageColor(
                                repository['language'] as String),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          repository['language'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppTheme.textMediumEmphasisDark
                                        : AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                      CustomIconWidget(
                        iconName: 'star',
                        size: 4.w,
                        color: isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatCount(repository['stars'] as int? ?? 0),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppTheme.textMediumEmphasisDark
                                  : AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'call_split',
                        size: 4.w,
                        color: isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatCount(repository['forks'] as int? ?? 0),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppTheme.textMediumEmphasisDark
                                  : AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(repository['updatedAt'] as String?),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppTheme.textDisabledDark
                                  : AppTheme.textDisabledLight,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return const Color(0xFF0175C2);
      case 'javascript':
        return const Color(0xFFF7DF1E);
      case 'typescript':
        return const Color(0xFF3178C6);
      case 'python':
        return const Color(0xFF3776AB);
      case 'java':
        return const Color(0xFFED8B00);
      case 'swift':
        return const Color(0xFFFA7343);
      case 'kotlin':
        return const Color(0xFF7F52FF);
      case 'go':
        return const Color(0xFF00ADD8);
      case 'rust':
        return const Color(0xFF000000);
      case 'c++':
        return const Color(0xFF00599C);
      default:
        return AppTheme.primaryLight;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()}y ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()}mo ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
