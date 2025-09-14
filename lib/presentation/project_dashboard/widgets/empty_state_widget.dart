import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatefulWidget {
  final VoidCallback onCloneRepository;
  final VoidCallback onCreateNew;
  final VoidCallback onImportFromDevice;
  final VoidCallback onUseTemplate;

  const EmptyStateWidget({
    super.key,
    required this.onCloneRepository,
    required this.onCreateNew,
    required this.onImportFromDevice,
    required this.onUseTemplate,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            Text(
              'Welcome to CodeCraft',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHighEmphasisLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start your mobile development journey by cloning your first repository or creating a new project.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            _buildActionButtons(),
            SizedBox(height: 3.h),
            _buildQRCodeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 60.w,
      height: 30.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'code',
            color: AppTheme.primaryLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          CustomIconWidget(
            iconName: 'smartphone',
            color: AppTheme.accentLight,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onCloneRepository,
            icon: CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 20,
            ),
            label: Text('Clone Repository'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onCreateNew,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.primaryLight,
                  size: 18,
                ),
                label: Text('Create New'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onImportFromDevice,
                icon: CustomIconWidget(
                  iconName: 'folder',
                  color: AppTheme.primaryLight,
                  size: 18,
                ),
                label: Text('Import'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: widget.onUseTemplate,
            icon: CustomIconWidget(
              iconName: 'template',
              color: AppTheme.primaryLight,
              size: 18,
            ),
            label: Text('Use Template'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Quick Repository Access',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Scan a QR code to quickly clone a repository from GitHub',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _startQRScanning,
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.primaryLight,
                size: 18,
              ),
              label: Text('Scan QR Code'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startQRScanning() {
    setState(() {
      _isScanning = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Scan Repository QR Code',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _isScanning = false;
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryLight,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          Navigator.pop(context);
                          setState(() {
                            _isScanning = false;
                          });
                          _handleQRCodeResult(barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Point your camera at a GitHub repository QR code',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleQRCodeResult(String result) {
    // Handle the QR code result (repository URL)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Repository URL detected: $result'),
        action: SnackBarAction(
          label: 'Clone',
          onPressed: () {
            // Implement clone functionality
            widget.onCloneRepository();
          },
        ),
      ),
    );
  }
}
