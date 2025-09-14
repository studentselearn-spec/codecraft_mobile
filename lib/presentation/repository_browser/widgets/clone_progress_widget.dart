import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CloneProgressWidget extends StatefulWidget {
  final Map<String, dynamic> repository;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const CloneProgressWidget({
    Key? key,
    required this.repository,
    required this.onCancel,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<CloneProgressWidget> createState() => _CloneProgressWidgetState();
}

class _CloneProgressWidgetState extends State<CloneProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  String _currentStep = 'Initializing...';
  double _progress = 0.0;
  bool _isCompleted = false;
  String _selectedPath = '/storage/emulated/0/CodeCraft/Projects';

  final List<String> _cloneSteps = [
    'Initializing clone operation...',
    'Connecting to GitHub...',
    'Fetching repository metadata...',
    'Downloading objects...',
    'Resolving deltas...',
    'Checking out files...',
    'Setting up local repository...',
    'Clone completed successfully!',
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startCloneProcess();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCloneProcess() {
    _pulseController.repeat(reverse: true);

    _progressController.addListener(() {
      final stepIndex =
          (_progressAnimation.value * (_cloneSteps.length - 1)).floor();
      final newStep = _cloneSteps[stepIndex.clamp(0, _cloneSteps.length - 1)];

      if (newStep != _currentStep) {
        setState(() {
          _currentStep = newStep;
          _progress = _progressAnimation.value;
        });
      }

      if (_progressAnimation.value >= 1.0 && !_isCompleted) {
        setState(() {
          _isCompleted = true;
        });
        _pulseController.stop();
        Future.delayed(const Duration(seconds: 2), () {
          widget.onComplete();
        });
      }
    });

    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),

          // Repository info
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'folder_copy',
                    size: 6.w,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cloning Repository',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppTheme.textHighEmphasisDark
                                : AppTheme.textHighEmphasisLight,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${widget.repository['owner']}/${widget.repository['name']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Storage path selection
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  (isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight)
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'folder',
                      size: 5.w,
                      color: isDark
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Clone to:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isDark
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _isCompleted
                          ? null
                          : () => _showPathSelector(context),
                      child: Text(
                        'Change',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _isCompleted
                                  ? AppTheme.textDisabledLight
                                  : AppTheme.primaryLight,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _selectedPath,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppTheme.textHighEmphasisDark
                            : AppTheme.textHighEmphasisLight,
                        fontFamily: 'monospace',
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Progress section
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isCompleted ? 1.0 : _pulseAnimation.value,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCompleted
                        ? AppTheme.successLight.withValues(alpha: 0.1)
                        : AppTheme.primaryLight.withValues(alpha: 0.1),
                    border: Border.all(
                      color: _isCompleted
                          ? AppTheme.successLight
                          : AppTheme.primaryLight,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _isCompleted
                        ? CustomIconWidget(
                            iconName: 'check',
                            size: 8.w,
                            color: AppTheme.successLight,
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 12.w,
                                height: 12.w,
                                child: CircularProgressIndicator(
                                  value: _progress,
                                  strokeWidth: 3,
                                  backgroundColor: (isDark
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.primaryLight),
                                ),
                              ),
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryLight,
                                    ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Status text
          Text(
            _currentStep,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _isCompleted
                      ? AppTheme.successLight
                      : (isDark
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight),
                  fontWeight: _isCompleted ? FontWeight.w500 : FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Action buttons
          Row(
            children: [
              if (!_isCompleted) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: Text('Cancel'),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Open in code editor
                      Navigator.pushNamed(context, '/code-editor');
                    },
                    icon: CustomIconWidget(
                      iconName: 'code',
                      size: 5.w,
                      color: Colors.white,
                    ),
                    label: Text('Open in Editor'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onComplete,
                    icon: CustomIconWidget(
                      iconName: 'folder_open',
                      size: 5.w,
                      color: AppTheme.primaryLight,
                    ),
                    label: Text('View Files'),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _showPathSelector(BuildContext context) {
    final paths = [
      '/storage/emulated/0/CodeCraft/Projects',
      '/storage/emulated/0/Documents/Code',
      '/storage/emulated/0/Download/Repositories',
      '/data/data/com.codecraft.mobile/files/projects',
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
              'Select Clone Location',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...paths
                .map(
                  (path) => ListTile(
                    leading: CustomIconWidget(
                      iconName: 'folder',
                      size: 6.w,
                      color: AppTheme.primaryLight,
                    ),
                    title: Text(
                      path,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                    trailing: _selectedPath == path
                        ? CustomIconWidget(
                            iconName: 'check',
                            size: 5.w,
                            color: AppTheme.successLight,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedPath = path;
                      });
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
}
