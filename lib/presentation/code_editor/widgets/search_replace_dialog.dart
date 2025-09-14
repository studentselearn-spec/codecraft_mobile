import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchReplaceDialog extends StatefulWidget {
  final Function(String, {bool caseSensitive, bool useRegex})? onSearch;
  final Function(String, String, {bool replaceAll})? onReplace;

  const SearchReplaceDialog({
    super.key,
    this.onSearch,
    this.onReplace,
  });

  @override
  State<SearchReplaceDialog> createState() => _SearchReplaceDialogState();
}

class _SearchReplaceDialogState extends State<SearchReplaceDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();
  bool _caseSensitive = false;
  bool _useRegex = false;
  bool _showReplace = false;

  @override
  void dispose() {
    _searchController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _showReplace ? 'Find & Replace' : 'Find',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 6.w,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    size: 5.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showReplace = !_showReplace;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: _showReplace
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        size: 5.w,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              onSubmitted: (value) => _performSearch(),
            ),

            // Replace field (conditional)
            if (_showReplace) ...[
              SizedBox(height: 3.h),
              TextField(
                controller: _replaceController,
                decoration: InputDecoration(
                  labelText: 'Replace with',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'find_replace',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 4.h),

            // Options
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      'Case sensitive',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    value: _caseSensitive,
                    onChanged: (value) {
                      setState(() {
                        _caseSensitive = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),

            CheckboxListTile(
              title: Text(
                'Use regular expressions',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              value: _useRegex,
              onChanged: (value) {
                setState(() {
                  _useRegex = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            SizedBox(height: 4.h),

            // Action buttons
            Row(
              children: [
                if (_showReplace) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _performReplace(false),
                      child: Text('Replace'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _performReplace(true),
                      child: Text('Replace All'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    icon: CustomIconWidget(
                      iconName: 'search',
                      size: 4.w,
                      color: Colors.white,
                    ),
                    label: Text('Find'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      widget.onSearch?.call(
        searchText,
        caseSensitive: _caseSensitive,
        useRegex: _useRegex,
      );
    }
  }

  void _performReplace(bool replaceAll) {
    final searchText = _searchController.text.trim();
    final replaceText = _replaceController.text;

    if (searchText.isNotEmpty) {
      widget.onReplace?.call(
        searchText,
        replaceText,
        replaceAll: replaceAll,
      );
    }
  }
}
