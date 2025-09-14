import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type;
  final VoidCallback? onRetry;
  final VoidCallback? onExplore;

  const EmptyStateWidget({
    Key? key,
    required this.type,
    this.onRetry,
    this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getIconName(),
                  size: 20.w,
                  color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _getTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTheme.textHighEmphasisDark
                        : AppTheme.textHighEmphasisLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _getDescription(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  String _getIconName() {
    switch (type) {
      case 'no_results':
        return 'search_off';
      case 'network_error':
        return 'wifi_off';
      case 'offline':
        return 'cloud_off';
      case 'no_repositories':
        return 'folder_open';
      case 'loading_error':
        return 'error_outline';
      default:
        return 'help_outline';
    }
  }

  String _getTitle() {
    switch (type) {
      case 'no_results':
        return 'No Repositories Found';
      case 'network_error':
        return 'Connection Error';
      case 'offline':
        return 'You\'re Offline';
      case 'no_repositories':
        return 'No Repositories Yet';
      case 'loading_error':
        return 'Something Went Wrong';
      default:
        return 'Empty State';
    }
  }

  String _getDescription() {
    switch (type) {
      case 'no_results':
        return 'We couldn\'t find any repositories matching your search criteria. Try adjusting your filters or search terms.';
      case 'network_error':
        return 'Unable to connect to GitHub. Please check your internet connection and try again.';
      case 'offline':
        return 'You\'re currently offline. Some features may be limited. Connect to the internet to access all repositories.';
      case 'no_repositories':
        return 'Start exploring by searching for repositories or browse trending projects to get started.';
      case 'loading_error':
        return 'We encountered an error while loading repositories. Please try again or contact support if the problem persists.';
      default:
        return 'This section is currently empty.';
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (type) {
      case 'no_results':
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Clear search and filters
              },
              icon: CustomIconWidget(
                iconName: 'clear',
                size: 5.w,
                color: Colors.white,
              ),
              label: Text('Clear Filters'),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: onExplore,
              icon: CustomIconWidget(
                iconName: 'explore',
                size: 5.w,
                color: AppTheme.primaryLight,
              ),
              label: Text('Explore Trending'),
            ),
          ],
        );
      case 'network_error':
      case 'loading_error':
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: CustomIconWidget(
                iconName: 'refresh',
                size: 5.w,
                color: Colors.white,
              ),
              label: Text('Try Again'),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () {
                // Go to settings
                Navigator.pushNamed(context, '/settings-profile');
              },
              icon: CustomIconWidget(
                iconName: 'settings',
                size: 5.w,
                color: AppTheme.primaryLight,
              ),
              label: Text('Check Settings'),
            ),
          ],
        );
      case 'offline':
        return Column(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                // Show cached repositories
              },
              icon: CustomIconWidget(
                iconName: 'storage',
                size: 5.w,
                color: AppTheme.primaryLight,
              ),
              label: Text('View Cached'),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: CustomIconWidget(
                iconName: 'wifi',
                size: 5.w,
                color: AppTheme.primaryLight,
              ),
              label: Text('Check Connection'),
            ),
          ],
        );
      case 'no_repositories':
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: onExplore,
              icon: CustomIconWidget(
                iconName: 'trending_up',
                size: 5.w,
                color: Colors.white,
              ),
              label: Text('Explore Trending'),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Search repositories
                    },
                    icon: CustomIconWidget(
                      iconName: 'search',
                      size: 4.w,
                      color: AppTheme.primaryLight,
                    ),
                    label: Text('Search'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Create new repository
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      size: 4.w,
                      color: AppTheme.primaryLight,
                    ),
                    label: Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return ElevatedButton(
          onPressed: onRetry,
          child: Text('Refresh'),
        );
    }
  }
}
