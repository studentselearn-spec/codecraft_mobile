import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BackgroundGradientWidget extends StatefulWidget {
  const BackgroundGradientWidget({super.key});

  @override
  State<BackgroundGradientWidget> createState() =>
      _BackgroundGradientWidgetState();
}

class _BackgroundGradientWidgetState extends State<BackgroundGradientWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                _gradientAnimation.value * 0.3,
                0.7 + (_gradientAnimation.value * 0.2),
                1.0,
              ],
              colors: [
                AppTheme.lightTheme.scaffoldBackgroundColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.05),
                AppTheme.lightTheme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20.h,
                right: -10.w,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.primaryColor
                        .withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 15.h,
                left: -15.w,
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.03),
                  ),
                ),
              ),
              Positioned(
                top: 35.h,
                left: 70.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.primaryColor
                        .withValues(alpha: 0.08),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
