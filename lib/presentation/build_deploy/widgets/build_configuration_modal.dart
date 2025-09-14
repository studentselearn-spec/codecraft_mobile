import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BuildConfigurationModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onBuildStart;

  const BuildConfigurationModal({
    Key? key,
    required this.onBuildStart,
  }) : super(key: key);

  @override
  State<BuildConfigurationModal> createState() =>
      _BuildConfigurationModalState();
}

class _BuildConfigurationModalState extends State<BuildConfigurationModal> {
  String selectedPlatform = 'Android';
  String selectedBuildType = 'Debug';
  String selectedEnvironment = 'Development';
  String selectedCertificate = 'Default';
  final Map<String, String> environmentVariables = {};
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  final List<String> platforms = ['Android', 'iOS', 'Web'];
  final List<String> buildTypes = ['Debug', 'Release', 'Profile'];
  final List<String> environments = ['Development', 'Staging', 'Production'];
  final List<String> certificates = [
    'Default',
    'Release Certificate',
    'Distribution Certificate'
  ];

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 85.h,
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
                Text(
                  'New Build Configuration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(),
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

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Platform Selection'),
                  _buildPlatformSelector(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Build Configuration'),
                  _buildDropdownField(
                      'Build Type', selectedBuildType, buildTypes, (value) {
                    setState(() => selectedBuildType = value!);
                  }),
                  SizedBox(height: 2.h),
                  _buildDropdownField(
                      'Environment', selectedEnvironment, environments,
                      (value) {
                    setState(() => selectedEnvironment = value!);
                  }),
                  SizedBox(height: 2.h),
                  _buildDropdownField(
                      'Certificate', selectedCertificate, certificates,
                      (value) {
                    setState(() => selectedCertificate = value!);
                  }),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Environment Variables'),
                  _buildEnvironmentVariables(),
                  SizedBox(height: 3.h),
                  _buildSectionTitle('Deployment Settings'),
                  _buildDeploymentSettings(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _startBuild,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'build',
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        Text('Start Build'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    return Container(
      height: 12.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final isSelected = selectedPlatform == platform;

          return GestureDetector(
            onTap: () => setState(() => selectedPlatform = platform),
            child: Container(
              width: 25.w,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : Theme.of(context).cardColor,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: _getPlatformIcon(platform),
                    size: 32,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Theme.of(context).iconTheme.color!,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    platform,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : null,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildEnvironmentVariables() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: 'Key',
                  hintText: 'API_URL',
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Value',
                  hintText: 'https://api.example.com',
                ),
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: _addEnvironmentVariable,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        if (environmentVariables.isNotEmpty) ...[
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: environmentVariables.length,
              itemBuilder: (context, index) {
                final key = environmentVariables.keys.elementAt(index);
                final value = environmentVariables[key]!;

                return Card(
                  child: ListTile(
                    title: Text(key,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(value),
                    trailing: IconButton(
                      onPressed: () => _removeEnvironmentVariable(key),
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        size: 20,
                        color: AppTheme.errorLight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeploymentSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Auto-deploy to Supabase'),
          subtitle: Text('Automatically deploy backend changes'),
          value: true,
          onChanged: (value) {},
        ),
        SwitchListTile(
          title: Text('Enable notifications'),
          subtitle: Text('Get notified when build completes'),
          value: true,
          onChanged: (value) {},
        ),
        SwitchListTile(
          title: Text('Generate QR code'),
          subtitle: Text('Create QR code for easy distribution'),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  String _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'ios':
        return 'phone_iphone';
      case 'android':
        return 'android';
      case 'web':
        return 'web';
      default:
        return 'devices';
    }
  }

  void _addEnvironmentVariable() {
    if (_keyController.text.isNotEmpty && _valueController.text.isNotEmpty) {
      setState(() {
        environmentVariables[_keyController.text] = _valueController.text;
        _keyController.clear();
        _valueController.clear();
      });
    }
  }

  void _removeEnvironmentVariable(String key) {
    setState(() {
      environmentVariables.remove(key);
    });
  }

  void _startBuild() {
    final buildConfig = {
      'platform': selectedPlatform,
      'buildType': selectedBuildType,
      'environment': selectedEnvironment,
      'certificate': selectedCertificate,
      'environmentVariables': environmentVariables,
      'timestamp': DateTime.now(),
    };

    widget.onBuildStart(buildConfig);
    Navigator.pop(context);
  }
}
