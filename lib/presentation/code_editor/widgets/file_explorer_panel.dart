import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FileExplorerPanel extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onClose;
  final Function(String)? onFileSelected;

  const FileExplorerPanel({
    super.key,
    required this.isVisible,
    this.onClose,
    this.onFileSelected,
  });

  @override
  State<FileExplorerPanel> createState() => _FileExplorerPanelState();
}

class _FileExplorerPanelState extends State<FileExplorerPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _projectStructure = [
    {
      "name": "lib",
      "type": "folder",
      "isExpanded": true,
      "children": [
        {
          "name": "main.dart",
          "type": "file",
          "icon": "description",
          "isActive": true,
        },
        {
          "name": "models",
          "type": "folder",
          "isExpanded": false,
          "children": [
            {"name": "user.dart", "type": "file", "icon": "description"},
            {"name": "project.dart", "type": "file", "icon": "description"},
          ],
        },
        {
          "name": "screens",
          "type": "folder",
          "isExpanded": true,
          "children": [
            {"name": "home_screen.dart", "type": "file", "icon": "description"},
            {
              "name": "profile_screen.dart",
              "type": "file",
              "icon": "description"
            },
          ],
        },
        {
          "name": "widgets",
          "type": "folder",
          "isExpanded": false,
          "children": [
            {
              "name": "custom_button.dart",
              "type": "file",
              "icon": "description"
            },
            {
              "name": "loading_widget.dart",
              "type": "file",
              "icon": "description"
            },
          ],
        },
      ],
    },
    {
      "name": "assets",
      "type": "folder",
      "isExpanded": false,
      "children": [
        {"name": "images", "type": "folder", "children": []},
        {"name": "fonts", "type": "folder", "children": []},
      ],
    },
    {
      "name": "pubspec.yaml",
      "type": "file",
      "icon": "settings",
    },
    {
      "name": "README.md",
      "type": "file",
      "icon": "article",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(FileExplorerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible
          ? _animationController.forward()
          : _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVisible
        ? SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 70.w,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildFileTree(),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildHeader() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'folder',
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Project Explorer',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          InkWell(
            onTap: widget.onClose,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'close',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTree() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      children:
          _projectStructure.map((item) => _buildTreeItem(item, 0)).toList(),
    );
  }

  Widget _buildTreeItem(Map<String, dynamic> item, int depth) {
    final isFolder = item["type"] == "folder";
    final isExpanded = item["isExpanded"] ?? false;
    final isActive = item["isActive"] ?? false;
    final children = item["children"] as List<Map<String, dynamic>>? ?? [];

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (isFolder) {
              setState(() {
                item["isExpanded"] = !isExpanded;
              });
            } else {
              widget.onFileSelected?.call(item["name"]);
            }
          },
          onLongPress: isFolder ? null : () => _showContextMenu(item),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: (4 + depth * 4).w,
              vertical: 1.5.h,
            ),
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            child: Row(
              children: [
                if (isFolder) ...[
                  CustomIconWidget(
                    iconName: isExpanded
                        ? 'keyboard_arrow_down'
                        : 'keyboard_arrow_right',
                    size: 4.w,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                  SizedBox(width: 1.w),
                ],
                CustomIconWidget(
                  iconName:
                      isFolder ? 'folder' : (item["icon"] ?? 'description'),
                  size: 5.w,
                  color: isFolder
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    item["name"],
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isFolder && isExpanded)
          ...children.map((child) => _buildTreeItem(child, depth + 1)),
      ],
    );
  }

  void _showContextMenu(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('Rename',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              title: Text('Delete',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              title: Text('New File',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
