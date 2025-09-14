import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/clone_progress_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/repository_card_widget.dart';
import './widgets/search_filter_widget.dart';
import './widgets/trending_section_widget.dart';

class RepositoryBrowser extends StatefulWidget {
  const RepositoryBrowser({Key? key}) : super(key: key);

  @override
  State<RepositoryBrowser> createState() => _RepositoryBrowserState();
}

class _RepositoryBrowserState extends State<RepositoryBrowser>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;

  String _selectedLanguage = 'All';
  String _selectedSort = 'updated';
  bool _isLoading = false;
  bool _isOffline = false;
  List<String> _recentSearches = ['flutter', 'react native', 'kotlin', 'swift'];

  List<Map<String, dynamic>> _allRepositories = [];
  List<Map<String, dynamic>> _filteredRepositories = [];
  List<Map<String, dynamic>> _trendingRepositories = [];
  List<Map<String, dynamic>> _starredRepositories = [];
  List<Map<String, dynamic>> _myRepositories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
    _checkConnectivity();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _loadMockData();
    _applyFilters();
  }

  void _loadMockData() {
    _allRepositories = [
      {
        "id": 1,
        "name": "flutter",
        "owner": "flutter",
        "description":
            "Flutter makes it easy and fast to build beautiful apps for mobile and beyond",
        "language": "Dart",
        "stars": 165000,
        "forks": 27200,
        "isPrivate": false,
        "updatedAt": "2025-01-14T10:30:00Z",
        "url": "https://github.com/flutter/flutter",
        "topics": ["mobile", "ui", "framework", "dart"],
        "todayStars": 45,
      },
      {
        "id": 2,
        "name": "react-native",
        "owner": "facebook",
        "description": "A framework for building native apps with React.",
        "language": "JavaScript",
        "stars": 118000,
        "forks": 24100,
        "isPrivate": false,
        "updatedAt": "2025-01-14T09:15:00Z",
        "url": "https://github.com/facebook/react-native",
        "topics": ["mobile", "react", "javascript", "native"],
        "todayStars": 32,
      },
      {
        "id": 3,
        "name": "awesome-flutter",
        "owner": "Solido",
        "description":
            "An awesome list that curates the best Flutter libraries, tools, tutorials, articles and more.",
        "language": "Dart",
        "stars": 53000,
        "forks": 6800,
        "isPrivate": false,
        "updatedAt": "2025-01-14T08:45:00Z",
        "url": "https://github.com/Solido/awesome-flutter",
        "topics": ["awesome", "flutter", "resources", "list"],
        "todayStars": 28,
      },
      {
        "id": 4,
        "name": "kotlin",
        "owner": "JetBrains",
        "description": "The Kotlin Programming Language.",
        "language": "Kotlin",
        "stars": 48000,
        "forks": 5600,
        "isPrivate": false,
        "updatedAt": "2025-01-14T07:20:00Z",
        "url": "https://github.com/JetBrains/kotlin",
        "topics": ["kotlin", "programming-language", "jvm", "android"],
        "todayStars": 19,
      },
      {
        "id": 5,
        "name": "swift",
        "owner": "apple",
        "description": "The Swift Programming Language",
        "language": "Swift",
        "stars": 67000,
        "forks": 10300,
        "isPrivate": false,
        "updatedAt": "2025-01-14T06:10:00Z",
        "url": "https://github.com/apple/swift",
        "topics": ["swift", "programming-language", "ios", "macos"],
        "todayStars": 15,
      },
      {
        "id": 6,
        "name": "go",
        "owner": "golang",
        "description": "The Go programming language",
        "language": "Go",
        "stars": 123000,
        "forks": 17500,
        "isPrivate": false,
        "updatedAt": "2025-01-14T05:30:00Z",
        "url": "https://github.com/golang/go",
        "topics": ["go", "programming-language", "backend", "google"],
        "todayStars": 41,
      },
      {
        "id": 7,
        "name": "rust",
        "owner": "rust-lang",
        "description":
            "Empowering everyone to build reliable and efficient software.",
        "language": "Rust",
        "stars": 97000,
        "forks": 12600,
        "isPrivate": false,
        "updatedAt": "2025-01-14T04:15:00Z",
        "url": "https://github.com/rust-lang/rust",
        "topics": ["rust", "programming-language", "systems", "memory-safe"],
        "todayStars": 37,
      },
      {
        "id": 8,
        "name": "tensorflow",
        "owner": "tensorflow",
        "description": "An Open Source Machine Learning Framework for Everyone",
        "language": "Python",
        "stars": 185000,
        "forks": 74000,
        "isPrivate": false,
        "updatedAt": "2025-01-14T03:45:00Z",
        "url": "https://github.com/tensorflow/tensorflow",
        "topics": ["machine-learning", "tensorflow", "python", "ai"],
        "todayStars": 52,
      },
    ];

    _trendingRepositories = _allRepositories.take(5).toList();
    _starredRepositories = [
      _allRepositories[0],
      _allRepositories[2],
      _allRepositories[4]
    ];
    _myRepositories = [
      {
        "id": 101,
        "name": "my-flutter-app",
        "owner": "john_doe",
        "description": "My awesome Flutter application with modern UI design",
        "language": "Dart",
        "stars": 12,
        "forks": 3,
        "isPrivate": true,
        "updatedAt": "2025-01-13T15:30:00Z",
        "url": "https://github.com/john_doe/my-flutter-app",
        "topics": ["flutter", "mobile", "personal"],
        "todayStars": 1,
      },
      {
        "id": 102,
        "name": "api-backend",
        "owner": "john_doe",
        "description": "RESTful API backend built with Node.js and Express",
        "language": "JavaScript",
        "stars": 8,
        "forks": 2,
        "isPrivate": false,
        "updatedAt": "2025-01-12T11:20:00Z",
        "url": "https://github.com/john_doe/api-backend",
        "topics": ["nodejs", "api", "backend", "express"],
        "todayStars": 0,
      },
    ];
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult.contains(ConnectivityResult.none);
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> repositories;

    switch (_tabController.index) {
      case 1:
        repositories = List.from(_starredRepositories);
        break;
      case 2:
        repositories = List.from(_myRepositories);
        break;
      case 3:
        repositories = List.from(_trendingRepositories);
        break;
      default:
        repositories = List.from(_allRepositories);
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      repositories = repositories.where((repo) {
        final name = (repo['name'] as String).toLowerCase();
        final description =
            (repo['description'] as String? ?? '').toLowerCase();
        final owner = (repo['owner'] as String).toLowerCase();
        final topics =
            (repo['topics'] as List<dynamic>? ?? []).join(' ').toLowerCase();

        return name.contains(query) ||
            description.contains(query) ||
            owner.contains(query) ||
            topics.contains(query);
      }).toList();
    }

    // Apply language filter
    if (_selectedLanguage != 'All') {
      repositories = repositories
          .where((repo) => repo['language'] == _selectedLanguage)
          .toList();
    }

    // Apply sort
    repositories.sort((a, b) {
      switch (_selectedSort) {
        case 'stars':
          return (b['stars'] as int).compareTo(a['stars'] as int);
        case 'forks':
          return (b['forks'] as int).compareTo(a['forks'] as int);
        case 'created':
        case 'updated':
        default:
          return DateTime.parse(b['updatedAt'] as String)
              .compareTo(DateTime.parse(a['updatedAt'] as String));
      }
    });

    setState(() {
      _filteredRepositories = repositories;
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _applyFilters();
  }

  void _onSortChanged(String sort) {
    setState(() {
      _selectedSort = sort;
    });
    _applyFilters();
  }

  void _onClearFilters() {
    setState(() {
      _selectedLanguage = 'All';
      _selectedSort = 'updated';
      _searchController.clear();
    });
    _applyFilters();
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _applyFilters();
  }

  void _onRepositoryTap(Map<String, dynamic> repository) {
    _showRepositoryDetails(repository);
  }

  void _onCloneRepository(Map<String, dynamic> repository) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CloneProgressWidget(
        repository: repository,
        onCancel: () => Navigator.pop(context),
        onComplete: () {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Repository cloned successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }

  void _onStarRepository(Map<String, dynamic> repository) {
    HapticFeedback.lightImpact();
    final isStarred =
        _starredRepositories.any((repo) => repo['id'] == repository['id']);

    setState(() {
      if (isStarred) {
        _starredRepositories
            .removeWhere((repo) => repo['id'] == repository['id']);
        repository['stars'] = (repository['stars'] as int) - 1;
      } else {
        _starredRepositories.add(repository);
        repository['stars'] = (repository['stars'] as int) + 1;
      }
    });

    Fluttertoast.showToast(
      msg: isStarred ? "Removed from starred" : "Added to starred",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onShareRepository(Map<String, dynamic> repository) {
    HapticFeedback.lightImpact();
    final url = repository['url'] as String;
    // In a real app, this would use the share plugin
    Fluttertoast.showToast(
      msg: "Repository link copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showRepositoryDetails(Map<String, dynamic> repository) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRepositoryDetailsSheet(repository),
    );
  }

  Widget _buildRepositoryDetailsSheet(Map<String, dynamic> repository) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repository['name'] as String,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        repository['owner'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppTheme.textMediumEmphasisDark
                                  : AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 6.w,
                    color: isDark
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (repository['description'] != null) ...[
                    Text(
                      repository['description'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Stats
                  Row(
                    children: [
                      _buildStatChip(
                          context, 'star', repository['stars'] as int, 'Stars'),
                      SizedBox(width: 3.w),
                      _buildStatChip(context, 'call_split',
                          repository['forks'] as int, 'Forks'),
                      SizedBox(width: 3.w),
                      _buildStatChip(context, 'code',
                          repository['language'] as String?, 'Language'),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Topics
                  if (repository['topics'] != null &&
                      (repository['topics'] as List).isNotEmpty) ...[
                    Text(
                      'Topics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (repository['topics'] as List)
                          .map(
                            (topic) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                topic as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.primaryLight,
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // README Preview
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppTheme.backgroundDark
                              : AppTheme.backgroundLight)
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'description',
                              size: 5.w,
                              color: isDark
                                  ? AppTheme.textMediumEmphasisDark
                                  : AppTheme.textMediumEmphasisLight,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'README.md',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '# ${repository['name']}\n\n${repository['description']}\n\n## Installation\n\n```bash\ngit clone ${repository['url']}\ncd ${repository['name']}\n```\n\n## Usage\n\nDetailed usage instructions would be here...',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    height: 1.4,
                                  ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _onCloneRepository(repository);
                    },
                    icon: CustomIconWidget(
                      iconName: 'download',
                      size: 5.w,
                      color: Colors.white,
                    ),
                    label: Text('Clone'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _onStarRepository(repository);
                    },
                    icon: CustomIconWidget(
                      iconName: 'star',
                      size: 5.w,
                      color: AppTheme.primaryLight,
                    ),
                    label: Text('Star'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
      BuildContext context, String iconName, dynamic value, String label) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 4.w,
            color: isDark
                ? AppTheme.textMediumEmphasisDark
                : AppTheme.textMediumEmphasisLight,
          ),
          SizedBox(width: 1.w),
          Text(
            value is int ? _formatCount(value) : (value as String? ?? 'N/A'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    _checkConnectivity();
    _loadMockData();
    _applyFilters();

    setState(() {
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Repositories updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Repository Browser'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            _applyFilters();
          },
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.public)),
            Tab(text: 'Starred', icon: Icon(Icons.star)),
            Tab(text: 'Mine', icon: Icon(Icons.person)),
            Tab(text: 'Trending', icon: Icon(Icons.trending_up)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show QR scanner for quick repository access
            },
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              size: 6.w,
              color: isDark
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings-profile');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              size: 6.w,
              color: isDark
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          SearchFilterWidget(
            searchController: _searchController,
            selectedLanguage: _selectedLanguage,
            selectedSort: _selectedSort,
            onLanguageChanged: _onLanguageChanged,
            onSortChanged: _onSortChanged,
            onClearFilters: _onClearFilters,
            recentSearches: _recentSearches,
            onRecentSearchTap: _onRecentSearchTap,
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRepositoryList(),
                _buildRepositoryList(repositories: _starredRepositories),
                _buildRepositoryList(repositories: _myRepositories),
                _buildTrendingTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new repository
          Navigator.pushNamed(context, '/code-editor');
        },
        child: CustomIconWidget(
          iconName: 'add',
          size: 6.w,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRepositoryList({List<Map<String, dynamic>>? repositories}) {
    final repos = repositories ?? _filteredRepositories;

    if (_isOffline && repos.isEmpty) {
      return EmptyStateWidget(
        type: 'offline',
        onRetry: _onRefresh,
      );
    }

    if (repos.isEmpty) {
      return EmptyStateWidget(
        type: _searchController.text.isNotEmpty
            ? 'no_results'
            : 'no_repositories',
        onExplore: () {
          _tabController.animateTo(3);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: repos.length,
        itemBuilder: (context, index) {
          final repository = repos[index];
          return RepositoryCardWidget(
            repository: repository,
            onTap: () => _onRepositoryTap(repository),
            onClone: () => _onCloneRepository(repository),
            onStar: () => _onStarRepository(repository),
            onShare: () => _onShareRepository(repository),
          );
        },
      ),
    );
  }

  Widget _buildTrendingTab() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            TrendingSectionWidget(
              trendingRepositories: _trendingRepositories,
              onRepositoryTap: _onRepositoryTap,
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _trendingRepositories.length,
              itemBuilder: (context, index) {
                final repository = _trendingRepositories[index];
                return RepositoryCardWidget(
                  repository: repository,
                  onTap: () => _onRepositoryTap(repository),
                  onClone: () => _onCloneRepository(repository),
                  onStar: () => _onStarRepository(repository),
                  onShare: () => _onShareRepository(repository),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
