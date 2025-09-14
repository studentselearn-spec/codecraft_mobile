import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _progress = 0.0;
  String _currentTask = 'Initializing CodeCraft...';
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  final List<Map<String, dynamic>> _initializationTasks = [
    {'task': 'Initializing CodeCraft...', 'duration': 800},
    {'task': 'Connecting to GitHub services...', 'duration': 1000},
    {'task': 'Setting up Supabase connection...', 'duration': 900},
    {'task': 'Loading user preferences...', 'duration': 700},
    {'task': 'Preparing development environment...', 'duration': 600},
    {'task': 'Ready to code!', 'duration': 500},
  ];

  @override
  void initState() {
    super.initState();
    _setStatusBarStyle();
    _startInitialization();
  }

  void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _startInitialization() async {
    try {
      for (int i = 0; i < _initializationTasks.length; i++) {
        if (mounted) {
          setState(() {
            _currentTask = _initializationTasks[i]['task'];
            _progress = (i + 1) / _initializationTasks.length;
          });

          await Future.delayed(
            Duration(milliseconds: _initializationTasks[i]['duration']),
          );

          // Simulate potential network timeout on GitHub connection
          if (i == 1) {
            await _checkGitHubConnection();
          }

          // Simulate Supabase connection check
          if (i == 2) {
            await _checkSupabaseConnection();
          }
        }
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Connection timeout. Please check your internet connection.';
        });
      }
    }
  }

  Future<void> _checkGitHubConnection() async {
    // Simulate GitHub authentication check
    await Future.delayed(const Duration(milliseconds: 200));

    // Simulate random connection issues (10% chance)
    if (DateTime.now().millisecond % 10 == 0) {
      throw Exception('GitHub connection timeout');
    }
  }

  Future<void> _checkSupabaseConnection() async {
    // Simulate Supabase connection check
    await Future.delayed(const Duration(milliseconds: 150));

    // Check for cached user data
    final bool hasUserData = await _checkCachedUserData();
    if (!hasUserData) {
      // User needs to authenticate
      setState(() {
        _currentTask = 'Authentication required...';
      });
    }
  }

  Future<bool> _checkCachedUserData() async {
    // Simulate checking for cached authentication
    await Future.delayed(const Duration(milliseconds: 100));
    return DateTime.now().millisecond % 3 !=
        0; // 66% chance of having cached data
  }

  void _navigateToNextScreen() {
    // Determine navigation path based on user state
    final bool isAuthenticated = DateTime.now().millisecond % 2 == 0;
    final bool isNewUser = DateTime.now().millisecond % 4 == 0;

    String nextRoute;
    if (_hasError) {
      // Stay on splash with retry option
      return;
    } else if (!isAuthenticated) {
      // Navigate to GitHub login (simulated)
      nextRoute = '/project-dashboard'; // Fallback to dashboard for demo
    } else if (isNewUser) {
      // Navigate to onboarding (simulated)
      nextRoute = '/project-dashboard'; // Fallback to dashboard for demo
    } else {
      // Navigate to project dashboard
      nextRoute = '/project-dashboard';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _retryInitialization() {
    setState(() {
      _progress = 0.0;
      _currentTask = 'Retrying connection...';
      _hasError = false;
      _errorMessage = '';
      _isInitialized = false;
    });
    _startInitialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            const BackgroundGradientWidget(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content up slightly
                  SizedBox(height: 5.h),

                  // Animated logo
                  const AnimatedLogoWidget(),

                  SizedBox(height: 3.h),

                  // App name
                  Text(
                    'CodeCraft Mobile',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 6.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Tagline
                  Text(
                    'Mobile Development Environment',
                    style: GoogleFonts.inter(
                      fontSize: 3.5.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Loading indicator or error state
                  _hasError ? _buildErrorState() : _buildLoadingState(),

                  // Bottom spacer
                  SizedBox(height: 10.h),
                ],
              ),
            ),

            // Version info at bottom
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'v1.0.0 • Build 2025.09.14',
                  style: GoogleFonts.inter(
                    fontSize: 2.5.sp,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return LoadingIndicatorWidget(
      currentTask: _currentTask,
      progress: _progress,
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.errorContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Connection Error',
                style: GoogleFonts.inter(
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                _errorMessage,
                style: GoogleFonts.inter(
                  fontSize: 3.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              ElevatedButton.icon(
                onPressed: _retryInitialization,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 4.w,
                ),
                label: Text(
                  'Retry',
                  style: GoogleFonts.inter(
                    fontSize: 3.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}