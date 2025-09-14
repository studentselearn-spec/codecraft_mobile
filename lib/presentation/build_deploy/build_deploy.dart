import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/build_card_widget.dart';
import './widgets/build_configuration_modal.dart';
import './widgets/build_logs_modal.dart';

class BuildDeploy extends StatefulWidget {
  const BuildDeploy({Key? key}) : super(key: key);

  @override
  State<BuildDeploy> createState() => _BuildDeployState();
}

class _BuildDeployState extends State<BuildDeploy>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _builds = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _builds = [
      {
        "id": 1,
        "buildNumber": "247",
        "platform": "Android",
        "buildType": "Debug",
        "status": "Building",
        "progress": 0.65,
        "eta": "2m 15s",
        "commitHash": "a7b3c9d",
        "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
        "environment": "Development",
        "size": "18.2MB",
      },
      {
        "id": 2,
        "buildNumber": "246",
        "platform": "iOS",
        "buildType": "Release",
        "status": "Success",
        "progress": 1.0,
        "eta": "Completed",
        "commitHash": "f4e2a1b",
        "timestamp": DateTime.now().subtract(Duration(hours: 2)),
        "environment": "Production",
        "size": "24.7MB",
      },
      {
        "id": 3,
        "buildNumber": "245",
        "platform": "Web",
        "buildType": "Debug",
        "status": "Failed",
        "progress": 0.0,
        "eta": "Failed",
        "commitHash": "c8d5f2e",
        "timestamp": DateTime.now().subtract(Duration(hours: 4)),
        "environment": "Staging",
        "size": "0MB",
      },
      {
        "id": 4,
        "buildNumber": "244",
        "platform": "Android",
        "buildType": "Release",
        "status": "Success",
        "progress": 1.0,
        "eta": "Completed",
        "commitHash": "b9a6e3f",
        "timestamp": DateTime.now().subtract(Duration(days: 1)),
        "environment": "Production",
        "size": "19.8MB",
      },
      {
        "id": 5,
        "buildNumber": "243",
        "platform": "iOS",
        "buildType": "Debug",
        "status": "Cancelled",
        "progress": 0.3,
        "eta": "Cancelled",
        "commitHash": "d2c7b4a",
        "timestamp": DateTime.now().subtract(Duration(days: 2)),
        "environment": "Development",
        "size": "0MB",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Build & Deploy'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'build',
                    size: 18,
                    color: _tabController.index == 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : (isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight),
                  ),
                  SizedBox(width: 2.w),
                  Text('Active'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    size: 18,
                    color: _tabController.index == 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : (isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight),
                  ),
                  SizedBox(width: 2.w),
                  Text('History'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_upload',
                    size: 18,
                    color: _tabController.index == 2
                        ? AppTheme.lightTheme.colorScheme.primary
                        : (isDark
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight),
                  ),
                  SizedBox(width: 2.w),
                  Text('Deploy'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveBuildsTab(),
          _buildHistoryTab(),
          _buildDeployTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBuildConfigurationModal,
        icon: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: Colors.white,
        ),
        label: Text('New Build'),
      ),
    );
  }

  Widget _buildActiveBuildsTab() {
    final activeBuilds = _builds
        .where((build) =>
            build['status'] == 'Building' || build['status'] == 'Queued')
        .toList();

    return RefreshIndicator(
      onRefresh: _refreshBuilds,
      child: activeBuilds.isEmpty
          ? _buildEmptyState(
              'No Active Builds',
              'Start a new build to see it here',
              'build',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: activeBuilds.length,
              itemBuilder: (context, index) {
                final build = activeBuilds[index];
                return BuildCardWidget(
                  buildData: build,
                  onViewLogs: () => _showBuildLogs(build),
                  onCancel: () => _cancelBuild(build),
                );
              },
            ),
    );
  }

  Widget _buildHistoryTab() {
    final completedBuilds = _builds
        .where((build) =>
            build['status'] != 'Building' && build['status'] != 'Queued')
        .toList();

    return RefreshIndicator(
      onRefresh: _refreshBuilds,
      child: completedBuilds.isEmpty
          ? _buildEmptyState(
              'No Build History',
              'Your completed builds will appear here',
              'history',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: completedBuilds.length,
              itemBuilder: (context, index) {
                final build = completedBuilds[index];
                return BuildCardWidget(
                  buildData: build,
                  onViewLogs: () => _showBuildLogs(build),
                  onDownload: build['status'] == 'Success'
                      ? () => _downloadBuild(build)
                      : null,
                  onShare: build['status'] == 'Success'
                      ? () => _shareBuild(build)
                      : null,
                );
              },
            ),
    );
  }

  Widget _buildDeployTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeploymentCard(
            'Supabase Backend',
            'Auto-deploy backend changes with builds',
            'cloud_upload',
            AppTheme.lightTheme.colorScheme.primary,
            true,
          ),
          SizedBox(height: 2.h),
          _buildDeploymentCard(
            'Firebase Hosting',
            'Deploy web builds to Firebase',
            'web',
            Colors.orange,
            false,
          ),
          SizedBox(height: 2.h),
          _buildDeploymentCard(
            'App Store Connect',
            'Upload iOS builds to TestFlight',
            'phone_iphone',
            AppTheme.lightTheme.colorScheme.primary,
            false,
          ),
          SizedBox(height: 2.h),
          _buildDeploymentCard(
            'Google Play Console',
            'Upload Android builds to Play Store',
            'android',
            Colors.green,
            false,
          ),
          SizedBox(height: 4.h),
          Text(
            'Deployment History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          _buildDeploymentHistoryCard(
            'Backend v2.1.4',
            'Deployed to Supabase',
            DateTime.now().subtract(Duration(hours: 1)),
            'Success',
          ),
          _buildDeploymentHistoryCard(
            'Web v1.0.8',
            'Deployed to Firebase',
            DateTime.now().subtract(Duration(hours: 6)),
            'Success',
          ),
          _buildDeploymentHistoryCard(
            'iOS v1.2.1',
            'Uploaded to TestFlight',
            DateTime.now().subtract(Duration(days: 1)),
            'Failed',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, String iconName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              size: 48,
              color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeploymentCard(String title, String subtitle, String iconName,
      Color color, bool isEnabled) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            size: 24,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) {
            // Handle deployment toggle
          },
        ),
      ),
    );
  }

  Widget _buildDeploymentHistoryCard(
      String title, String subtitle, DateTime timestamp, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color statusColor;

    switch (status.toLowerCase()) {
      case 'success':
        statusColor = AppTheme.successLight;
        break;
      case 'failed':
        statusColor = AppTheme.errorLight;
        break;
      default:
        statusColor = AppTheme.warningLight;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            SizedBox(height: 0.5.h),
            Text(
              _formatTimestamp(timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                  ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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

  void _showBuildConfigurationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BuildConfigurationModal(
        onBuildStart: _startNewBuild,
      ),
    );
  }

  void _showBuildLogs(Map<String, dynamic> build) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BuildLogsModal(build: build),
    );
  }

  void _startNewBuild(Map<String, dynamic> config) {
    setState(() {
      final newBuild = {
        "id": _builds.length + 1,
        "buildNumber": "${248 + _builds.length}",
        "platform": config['platform'],
        "buildType": config['buildType'],
        "status": "Building",
        "progress": 0.0,
        "eta": "5m 30s",
        "commitHash":
            "x${DateTime.now().millisecond.toString().substring(0, 3)}",
        "timestamp": DateTime.now(),
        "environment": config['environment'],
        "size": "0MB",
      };
      _builds.insert(0, newBuild);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Build started for ${config['platform']}'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            _tabController.animateTo(0);
          },
        ),
      ),
    );
  }

  void _cancelBuild(Map<String, dynamic> build) {
    setState(() {
      build['status'] = 'Cancelled';
      build['progress'] = 0.0;
      build['eta'] = 'Cancelled';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Build #${build['buildNumber']} cancelled'),
      ),
    );
  }

  void _downloadBuild(Map<String, dynamic> build) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${build['platform']} build...'),
      ),
    );
  }

  void _shareBuild(Map<String, dynamic> build) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing build #${build['buildNumber']}'),
      ),
    );
  }

  Future<void> _refreshBuilds() async {
    setState(() => _isRefreshing = true);

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Update build progress for active builds
    setState(() {
      for (var build in _builds) {
        if (build['status'] == 'Building') {
          final currentProgress = build['progress'] as double;
          if (currentProgress < 1.0) {
            build['progress'] = (currentProgress + 0.1).clamp(0.0, 1.0);
            if (build['progress'] >= 1.0) {
              build['status'] = 'Success';
              build['eta'] = 'Completed';
              build['size'] =
                  '${(15 + (build['id'] as int) * 2).toStringAsFixed(1)}MB';
            }
          }
        }
      }
      _isRefreshing = false;
    });
  }
}
