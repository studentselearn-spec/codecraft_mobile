import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_feed_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/new_project_bottom_sheet.dart';
import './widgets/project_card_widget.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isRefreshing = false;
  String _searchQuery = '';
  int _currentTabIndex = 0;

  // Mock data for projects
  final List<Map<String, dynamic>> _projects = [
    {
      'id': 1,
      'name': 'Flutter E-Commerce App',
      'description':
          'A complete e-commerce mobile application built with Flutter and Firebase backend integration.',
      'language': 'Dart',
      'lastCommit': '2025-09-14T09:30:00.000Z',
      'syncStatus': 'synced',
      'branch': 'main',
      'stars': 45,
      'forks': 12,
    },
    {
      'id': 2,
      'name': 'React Native Weather',
      'description':
          'Weather forecast app with location-based services and beautiful animations.',
      'language': 'JavaScript',
      'lastCommit': '2025-09-14T08:15:00.000Z',
      'syncStatus': 'syncing',
      'branch': 'develop',
      'stars': 23,
      'forks': 8,
    },
    {
      'id': 3,
      'name': 'Python Data Analytics',
      'description':
          'Data analysis toolkit with machine learning capabilities and visualization dashboard.',
      'language': 'Python',
      'lastCommit': '2025-09-13T16:45:00.000Z',
      'syncStatus': 'error',
      'branch': 'feature/ml-models',
      'stars': 67,
      'forks': 19,
    },
    {
      'id': 4,
      'name': 'Swift iOS Banking',
      'description':
          'Secure banking application with biometric authentication and real-time transactions.',
      'language': 'Swift',
      'lastCommit': '2025-09-13T14:20:00.000Z',
      'syncStatus': 'synced',
      'branch': 'main',
      'stars': 89,
      'forks': 25,
    },
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'id': 1,
      'type': 'commit',
      'title': 'Added payment integration',
      'description':
          'Implemented Stripe payment gateway with secure checkout flow',
      'project': 'Flutter E-Commerce App',
      'timestamp': '2025-09-14T09:30:00.000Z',
    },
    {
      'id': 2,
      'type': 'deploy',
      'title': 'Production deployment',
      'description': 'Successfully deployed v2.1.0 to production environment',
      'project': 'React Native Weather',
      'timestamp': '2025-09-14T08:15:00.000Z',
    },
    {
      'id': 3,
      'type': 'build',
      'title': 'Build in progress',
      'description': 'Running automated tests and building release candidate',
      'project': 'Python Data Analytics',
      'timestamp': '2025-09-14T07:45:00.000Z',
    },
    {
      'id': 4,
      'type': 'error',
      'title': 'Build failed',
      'description': 'Unit tests failed due to dependency conflicts',
      'project': 'Swift iOS Banking',
      'timestamp': '2025-09-14T06:30:00.000Z',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProjects {
    if (_searchQuery.isEmpty) return _projects;
    return _projects.where((project) {
      final name = (project['name'] ?? '').toLowerCase();
      final description = (project['description'] ?? '').toLowerCase();
      final language = (project['language'] ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          description.contains(query) ||
          language.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildCodeTab(),
                  _buildDeployTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _currentTabIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.dividerLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.dividerLight,
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings-profile');
              },
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Code'),
          Tab(text: 'Deploy'),
          Tab(text: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _filteredProjects.isEmpty && _searchQuery.isEmpty
          ? EmptyStateWidget(
              onCloneRepository: _handleCloneRepository,
              onCreateNew: _handleCreateNew,
              onImportFromDevice: _handleImportFromDevice,
              onUseTemplate: _handleUseTemplate,
            )
          : CustomScrollView(
              slivers: [
                if (_searchQuery.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),
                  SliverToBoxAdapter(
                    child: ActivityFeedWidget(activities: _recentActivities),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 3.h),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Your Projects',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 1.h),
                  ),
                ],
                _filteredProjects.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.textDisabledLight,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No projects found',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textDisabledLight,
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search terms',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textDisabledLight,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final project = _filteredProjects[index];
                            return ProjectCardWidget(
                              project: project,
                              onTap: () => _handleProjectTap(project),
                              onClone: () => _handleProjectClone(project),
                              onArchive: () => _handleProjectArchive(project),
                              onShare: () => _handleProjectShare(project),
                              onDelete: () => _handleProjectDelete(project),
                              onRename: () => _handleProjectRename(project),
                              onChangeBranch: () =>
                                  _handleProjectChangeBranch(project),
                              onViewOnGitHub: () =>
                                  _handleProjectViewOnGitHub(project),
                              onOfflineSettings: () =>
                                  _handleProjectOfflineSettings(project),
                            );
                          },
                          childCount: _filteredProjects.length,
                        ),
                      ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.h),
                ),
              ],
            ),
    );
  }

  Widget _buildCodeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'code',
            color: AppTheme.primaryLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Code Editor',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select a project to start coding',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/code-editor');
            },
            child: Text('Open Code Editor'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeployTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'rocket_launch',
            color: AppTheme.successLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Build & Deploy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Deploy your projects to production',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/build-deploy');
            },
            child: Text('Open Deploy Console'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.accentLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Profile & Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your account and preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings-profile');
            },
            child: Text('Open Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showNewProjectBottomSheet,
      child: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: 'Projects refreshed successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showNewProjectBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewProjectBottomSheet(
        onCloneRepository: _handleCloneRepository,
        onCreateNew: _handleCreateNew,
        onImportFromDevice: _handleImportFromDevice,
        onUseTemplate: _handleUseTemplate,
      ),
    );
  }

  void _handleProjectTap(Map<String, dynamic> project) {
    Navigator.pushNamed(context, '/code-editor');
  }

  void _handleProjectClone(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: 'Cloning ${project['name']}...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleProjectArchive(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: '${project['name']} archived',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleProjectShare(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: 'Sharing ${project['name']}...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleProjectDelete(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Project'),
        content: Text(
            'Are you sure you want to delete "${project['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _projects.removeWhere((p) => p['id'] == project['id']);
              });
              Fluttertoast.showToast(
                msg: '${project['name']} deleted',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleProjectRename(Map<String, dynamic> project) {
    final controller = TextEditingController(text: project['name']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Project'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Project Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Project renamed to "${controller.text}"',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _handleProjectChangeBranch(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: 'Switching branch for ${project['name']}...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleProjectViewOnGitHub(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: 'Opening ${project['name']} on GitHub...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleProjectOfflineSettings(Map<String, dynamic> project) {
    Fluttertoast.showToast(
      msg: 'Opening offline settings for ${project['name']}...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleCloneRepository() {
    Navigator.pushNamed(context, '/repository-browser');
  }

  void _handleCreateNew() {
    Fluttertoast.showToast(
      msg: 'Creating new project...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleImportFromDevice() {
    Fluttertoast.showToast(
      msg: 'Importing project from device...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleUseTemplate() {
    Fluttertoast.showToast(
      msg: 'Loading project templates...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
