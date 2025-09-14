import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/about_section_widget.dart';
import './widgets/account_section_widget.dart';
import './widgets/editor_preferences_widget.dart';
import './widgets/git_configuration_widget.dart';
import './widgets/security_section_widget.dart';

class SettingsProfile extends StatefulWidget {
  const SettingsProfile({Key? key}) : super(key: key);

  @override
  State<SettingsProfile> createState() => _SettingsProfileState();
}

class _SettingsProfileState extends State<SettingsProfile> {
  // Mock user profile data
  final Map<String, dynamic> userProfile = {
    "id": 1,
    "username": "alex_dev",
    "email": "alex.developer@gmail.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "repositories": 24,
    "bio": "Full-stack developer passionate about mobile development",
    "location": "San Francisco, CA",
    "company": "TechCorp Inc."
  };

  // Editor preferences state
  String selectedTheme = 'System';
  double fontSize = 14.0;
  bool syntaxHighlighting = true;
  bool autoSave = true;

  // Git configuration state
  Map<String, dynamic> gitConfig = {
    "author": "Alex Developer <alex.developer@gmail.com>",
    "gpgSigning": false,
    "mergeStrategy": "Fast-forward"
  };

  // Security settings state
  bool biometricAuth = true;
  String sessionTimeout = '30 minutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings & Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _exportSettings,
            icon: CustomIconWidget(
              iconName: 'download',
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            AccountSectionWidget(
              userProfile: userProfile,
              onProfileTap: _showProfileEditor,
            ),
            EditorPreferencesWidget(
              selectedTheme: selectedTheme,
              fontSize: fontSize,
              syntaxHighlighting: syntaxHighlighting,
              autoSave: autoSave,
              onThemeChanged: (String theme) {
                setState(() {
                  selectedTheme = theme;
                });
                _showThemeChangeSnackBar(theme);
              },
              onFontSizeChanged: (double size) {
                setState(() {
                  fontSize = size;
                });
              },
              onSyntaxHighlightingChanged: (bool enabled) {
                setState(() {
                  syntaxHighlighting = enabled;
                });
              },
              onAutoSaveChanged: (bool enabled) {
                setState(() {
                  autoSave = enabled;
                });
              },
            ),
            GitConfigurationWidget(
              gitConfig: gitConfig,
              onConfigChanged: (String key, String value) {
                setState(() {
                  if (key == 'gpgSigning') {
                    gitConfig[key] = value.toLowerCase() == 'true';
                  } else {
                    gitConfig[key] = value;
                  }
                });
              },
            ),
            SecuritySectionWidget(
              biometricAuth: biometricAuth,
              sessionTimeout: sessionTimeout,
              onBiometricChanged: (bool enabled) {
                setState(() {
                  biometricAuth = enabled;
                });
                _showBiometricChangeSnackBar(enabled);
              },
              onSessionTimeoutChanged: (String timeout) {
                setState(() {
                  sessionTimeout = timeout;
                });
              },
              onClearData: _clearSecureData,
            ),
            AboutSectionWidget(
              appVersion: 'v2.1.4 (Build 2024091)',
              onChangelogTap: _showChangelog,
              onPrivacyPolicyTap: _showPrivacyPolicy,
              onTermsOfServiceTap: _showTermsOfService,
              onSupportTap: _showSupport,
            ),
            SizedBox(height: 2.h),
            _buildLogoutButton(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showLogoutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              size: 20,
              color: Theme.of(context).colorScheme.onError,
            ),
            SizedBox(width: 2.w),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileEditor() {
    final TextEditingController bioController =
        TextEditingController(text: userProfile['bio'] as String);
    final TextEditingController locationController =
        TextEditingController(text: userProfile['location'] as String);
    final TextEditingController companyController =
        TextEditingController(text: userProfile['company'] as String);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 3.h),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: CustomIconWidget(
                      iconName: 'location_on',
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    prefixIcon: CustomIconWidget(
                      iconName: 'business',
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            userProfile['bio'] = bioController.text;
                            userProfile['location'] = locationController.text;
                            userProfile['company'] = companyController.text;
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Profile updated successfully')),
                          );
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeChangeSnackBar(String theme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed to $theme'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showBiometricChangeSnackBar(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? 'Biometric authentication enabled'
            : 'Biometric authentication disabled'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearSecureData() {
    // Simulate clearing secure data
    setState(() {
      biometricAuth = false;
      sessionTimeout = '15 minutes';
    });
  }

  void _exportSettings() {
    final settingsData = {
      "theme": selectedTheme,
      "fontSize": fontSize,
      "syntaxHighlighting": syntaxHighlighting,
      "autoSave": autoSave,
      "gitConfig": gitConfig,
      "biometricAuth": biometricAuth,
      "sessionTimeout": sessionTimeout,
      "exportedAt": DateTime.now().toIso8601String(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings exported successfully'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exported Settings'),
                content: SingleChildScrollView(
                  child: Text(
                    settingsData.toString(),
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showChangelog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Changelog'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'v2.1.4 - September 14, 2024',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Text('• Enhanced code editor performance'),
                Text('• Improved Git integration'),
                Text('• Bug fixes and stability improvements'),
                SizedBox(height: 2.h),
                Text(
                  'v2.1.3 - September 1, 2024',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Text('• Added biometric authentication'),
                Text('• New theme options'),
                Text('• Repository browser improvements'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: Text(
              'CodeCraft Mobile respects your privacy and is committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use our mobile development environment.\n\nWe collect minimal data necessary for app functionality, including GitHub authentication tokens (stored securely), project files (stored locally), and usage analytics (anonymized). Your code and projects remain private and are never shared without your explicit consent.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service'),
          content: SingleChildScrollView(
            child: Text(
              'By using CodeCraft Mobile, you agree to these terms of service. The app is provided "as is" without warranties. You are responsible for your code and data. We reserve the right to update these terms and will notify users of significant changes.\n\nYou may use the app for personal and commercial development projects. Prohibited uses include illegal activities, malicious code distribution, and violation of third-party rights.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Support & Help',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 3.h),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'email',
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text('Email Support'),
                  subtitle: Text('support@codecraft.dev'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening email client...')),
                    );
                  },
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'chat',
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text('Live Chat'),
                  subtitle: Text('Available 9 AM - 6 PM PST'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Starting live chat...')),
                    );
                  },
                ),
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'help',
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text('Documentation'),
                  subtitle: Text('User guides and tutorials'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening documentation...')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'logout',
                size: 24,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: 2.w),
              Text('Logout'),
            ],
          ),
          content: Text(
            'Are you sure you want to logout? This will clear your session and you\'ll need to sign in again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/splash-screen',
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
