import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BuildLogsModal extends StatefulWidget {
  final Map<String, dynamic> build;

  const BuildLogsModal({
    Key? key,
    required this.build,
  }) : super(key: key);

  @override
  State<BuildLogsModal> createState() => _BuildLogsModalState();
}

class _BuildLogsModalState extends State<BuildLogsModal> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _autoScroll = true;
  String _searchQuery = '';
  List<String> _filteredLogs = [];

  final List<String> _mockLogs = [
    '[2025-09-14 11:12:57] Starting build process...',
    '[2025-09-14 11:12:58] Initializing Flutter environment',
    '[2025-09-14 11:12:59] Flutter 3.16.0 • channel stable',
    '[2025-09-14 11:13:00] Dart 3.2.0 • DevTools 2.28.4',
    '[2025-09-14 11:13:01] Resolving dependencies...',
    '[2025-09-14 11:13:03] Running "flutter pub get" in /project',
    '[2025-09-14 11:13:05] Downloading packages...',
    '[2025-09-14 11:13:08] Got dependencies!',
    '[2025-09-14 11:13:09] Building APK...',
    '[2025-09-14 11:13:10] Running Gradle task "assembleDebug"...',
    '[2025-09-14 11:13:15] > Task :app:preBuild UP-TO-DATE',
    '[2025-09-14 11:13:16] > Task :app:preDebugBuild UP-TO-DATE',
    '[2025-09-14 11:13:18] > Task :app:compileDebugKotlin',
    '[2025-09-14 11:13:22] > Task :app:javaPreCompileDebug',
    '[2025-09-14 11:13:25] > Task :app:compileDebugJavaWithJavac',
    '[2025-09-14 11:13:28] > Task :flutter:compileFlutterBuildDebug',
    '[2025-09-14 11:13:35] Building Flutter assets...',
    '[2025-09-14 11:13:38] Compiling Dart to native code...',
    '[2025-09-14 11:13:45] > Task :app:packLibsflutterBuildDebug',
    '[2025-09-14 11:13:48] > Task :app:processDebugManifest',
    '[2025-09-14 11:13:50] > Task :app:processDebugResources',
    '[2025-09-14 11:13:55] > Task :app:assembleDebug',
    '[2025-09-14 11:13:57] BUILD SUCCESSFUL in 1m 0s',
    '[2025-09-14 11:13:58] Built build/app/outputs/flutter-apk/app-debug.apk (18.2MB)',
    '[2025-09-14 11:13:59] Build completed successfully!',
  ];

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_mockLogs);
    _searchController.addListener(_onSearchChanged);

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoScroll && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredLogs = List.from(_mockLogs);
      } else {
        _filteredLogs = _mockLogs
            .where((log) => log.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Build Logs',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Build #${widget.build['buildNumber']} - ${widget.build['platform']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: _copyLogsToClipboard,
                  icon: CustomIconWidget(
                    iconName: 'copy',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: isDark
                        ? AppTheme.textHighEmphasisDark
                        : AppTheme.textHighEmphasisLight,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search logs...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  size: 20,
                  color: isDark
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          size: 20,
                          color: isDark
                              ? AppTheme.textMediumEmphasisDark
                              : AppTheme.textMediumEmphasisLight,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Controls
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  '${_filteredLogs.length} lines',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Auto-scroll',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(width: 2.w),
                    Switch(
                      value: _autoScroll,
                      onChanged: (value) {
                        setState(() => _autoScroll = value);
                        if (value && _scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Logs content
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1A1A1A) : Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = _filteredLogs[index];
                  final isHighlighted = _searchQuery.isNotEmpty &&
                      log.toLowerCase().contains(_searchQuery);

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.2.h),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.sp,
                          color: _getLogColor(log, isDark),
                        ),
                        children: isHighlighted
                            ? _buildHighlightedText(log, _searchQuery, isDark)
                            : [TextSpan(text: log)],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Color _getLogColor(String log, bool isDark) {
    if (log.contains('ERROR') || log.contains('FAILED')) {
      return AppTheme.errorLight;
    } else if (log.contains('WARNING') || log.contains('WARN')) {
      return AppTheme.warningLight;
    } else if (log.contains('SUCCESS') || log.contains('BUILD SUCCESSFUL')) {
      return AppTheme.successLight;
    } else if (log.contains('[') && log.contains(']')) {
      return isDark
          ? AppTheme.textMediumEmphasisDark
          : AppTheme.textMediumEmphasisLight;
    }
    return isDark
        ? AppTheme.textHighEmphasisDark
        : AppTheme.textHighEmphasisLight;
  }

  List<TextSpan> _buildHighlightedText(String text, String query, bool isDark) {
    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Add text before match
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor: AppTheme.warningLight.withValues(alpha: 0.3),
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  void _copyLogsToClipboard() {
    final logsText = _filteredLogs.join('\n');
    Clipboard.setData(ClipboardData(text: logsText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logs copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
