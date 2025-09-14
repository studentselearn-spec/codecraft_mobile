import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EditorPreferencesWidget extends StatelessWidget {
  final String selectedTheme;
  final double fontSize;
  final bool syntaxHighlighting;
  final bool autoSave;
  final Function(String) onThemeChanged;
  final Function(double) onFontSizeChanged;
  final Function(bool) onSyntaxHighlightingChanged;
  final Function(bool) onAutoSaveChanged;

  const EditorPreferencesWidget({
    Key? key,
    required this.selectedTheme,
    required this.fontSize,
    required this.syntaxHighlighting,
    required this.autoSave,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.onSyntaxHighlightingChanged,
    required this.onAutoSaveChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editor Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          _buildThemeSelector(context),
          SizedBox(height: 2.h),
          _buildFontSizeSlider(context),
          SizedBox(height: 2.h),
          _buildSwitchTile(
            context,
            'Syntax Highlighting',
            'Enable code syntax highlighting',
            syntaxHighlighting,
            onSyntaxHighlightingChanged,
            'code',
          ),
          SizedBox(height: 1.h),
          _buildSwitchTile(
            context,
            'Auto Save',
            'Automatically save changes',
            autoSave,
            onAutoSaveChanged,
            'save',
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final themes = ['Light', 'Dark', 'System'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'palette',
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Theme',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedTheme,
              isExpanded: true,
              items: themes.map((String theme) {
                return DropdownMenuItem<String>(
                  value: theme,
                  child: Text(
                    theme,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onThemeChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'text_fields',
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Font Size',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Spacer(),
            Text(
              '${fontSize.toInt()}sp',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: fontSize,
            min: 10,
            max: 24,
            divisions: 14,
            onChanged: onFontSizeChanged,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'function calculateSum(a, b) {\n  return a + b;\n}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    String iconName,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
