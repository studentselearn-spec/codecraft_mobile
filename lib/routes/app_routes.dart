import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/repository_browser/repository_browser.dart';
import '../presentation/code_editor/code_editor.dart';
import '../presentation/project_dashboard/project_dashboard.dart';
import '../presentation/settings_profile/settings_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String buildDeploy = '/build-deploy';
  static const String splash = '/splash-screen';
  static const String repositoryBrowser = '/repository-browser';
  static const String codeEditor = '/code-editor';
  static const String projectDashboard = '/project-dashboard';
  static const String settingsProfile = '/settings-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    repositoryBrowser: (context) => const RepositoryBrowser(),
    codeEditor: (context) => const CodeEditor(),
    projectDashboard: (context) => const ProjectDashboard(),
    settingsProfile: (context) => const SettingsProfile(),
    // TODO: Add your other routes here
  };
}