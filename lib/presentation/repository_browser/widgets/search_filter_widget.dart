import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedLanguage;
  final String selectedSort;
  final Function(String) onLanguageChanged;
  final Function(String) onSortChanged;
  final VoidCallback onClearFilters;
  final List<String> recentSearches;
  final Function(String) onRecentSearchTap;

  const SearchFilterWidget({
    Key? key,
    required this.searchController,
    required this.selectedLanguage,
    required this.selectedSort,
    required this.onLanguageChanged,
    required this.onSortChanged,
    required this.onClearFilters,
    required this.recentSearches,
    required this.onRecentSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              ),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search repositories...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  size: 5.w,
                  color: isDark
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          size: 5.w,
                          color: isDark
                              ? AppTheme.textMediumEmphasisDark
                              : AppTheme.textMediumEmphasisLight,
                        ),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Language Filter
                _buildFilterChip(
                  context,
                  label:
                      selectedLanguage == 'All' ? 'Language' : selectedLanguage,
                  isSelected: selectedLanguage != 'All',
                  onTap: () => _showLanguageFilter(context),
                ),
                SizedBox(width: 2.w),

                // Sort Filter
                _buildFilterChip(
                  context,
                  label: _getSortLabel(selectedSort),
                  isSelected: selectedSort != 'updated',
                  onTap: () => _showSortFilter(context),
                ),
                SizedBox(width: 2.w),

                // Clear Filters
                if (selectedLanguage != 'All' || selectedSort != 'updated')
                  _buildFilterChip(
                    context,
                    label: 'Clear',
                    isSelected: false,
                    onTap: onClearFilters,
                    isAction: true,
                  ),
              ],
            ),
          ),

          // Recent Searches
          if (recentSearches.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                    ),
              ),
            ),
            SizedBox(height: 1.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recentSearches
                    .take(5)
                    .map(
                      (search) => Container(
                        margin: EdgeInsets.only(right: 2.w),
                        child: InkWell(
                          onTap: () => onRecentSearchTap(search),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.8.h),
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.primaryDark
                                      : AppTheme.primaryLight)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (isDark
                                        ? AppTheme.primaryDark
                                        : AppTheme.primaryLight)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'history',
                                  size: 3.5.w,
                                  color: isDark
                                      ? AppTheme.primaryDark
                                      : AppTheme.primaryLight,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  search,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? AppTheme.primaryDark
                                            : AppTheme.primaryLight,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isAction = false,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
              : (isAction
                  ? AppTheme.errorLight.withValues(alpha: 0.1)
                  : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                : (isAction
                    ? AppTheme.errorLight
                    : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAction)
              CustomIconWidget(
                iconName: 'clear',
                size: 4.w,
                color: AppTheme.errorLight,
              )
            else
              CustomIconWidget(
                iconName: isSelected ? 'check' : 'filter_list',
                size: 4.w,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight),
              ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isAction
                            ? AppTheme.errorLight
                            : (isDark
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight)),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageFilter(BuildContext context) {
    final languages = [
      'All',
      'Dart',
      'JavaScript',
      'TypeScript',
      'Python',
      'Java',
      'Swift',
      'Kotlin',
      'Go',
      'Rust',
      'C++'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Language',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: languages
                  .map(
                    (language) => InkWell(
                      onTap: () {
                        onLanguageChanged(language);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: selectedLanguage == language
                              ? AppTheme.primaryLight
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selectedLanguage == language
                                ? AppTheme.primaryLight
                                : AppTheme.dividerLight,
                          ),
                        ),
                        child: Text(
                          language,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: selectedLanguage == language
                                        ? Colors.white
                                        : null,
                                  ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSortFilter(BuildContext context) {
    final sortOptions = {
      'updated': 'Recently Updated',
      'stars': 'Most Stars',
      'forks': 'Most Forks',
      'created': 'Recently Created',
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...sortOptions.entries
                .map(
                  (entry) => ListTile(
                    title: Text(entry.value),
                    leading: Radio<String>(
                      value: entry.key,
                      groupValue: selectedSort,
                      onChanged: (value) {
                        if (value != null) {
                          onSortChanged(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    onTap: () {
                      onSortChanged(entry.key);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'stars':
        return 'Most Stars';
      case 'forks':
        return 'Most Forks';
      case 'created':
        return 'Recently Created';
      case 'updated':
      default:
        return 'Recently Updated';
    }
  }
}
