import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CodeEditorContent extends StatefulWidget {
  final String initialCode;
  final Function(String)? onCodeChanged;
  final VoidCallback? onCursorPositionChanged;

  const CodeEditorContent({
    super.key,
    required this.initialCode,
    this.onCodeChanged,
    this.onCursorPositionChanged,
  });

  @override
  State<CodeEditorContent> createState() => _CodeEditorContentState();
}

class _CodeEditorContentState extends State<CodeEditorContent> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  int _currentLine = 1;
  int _currentColumn = 1;
  double _fontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onCodeChanged?.call(_controller.text);
    _updateCursorPosition();
  }

  void _updateCursorPosition() {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.baseOffset >= 0) {
      final lines = text.substring(0, selection.baseOffset).split('\n');
      setState(() {
        _currentLine = lines.length;
        _currentColumn = lines.last.length + 1;
      });
      widget.onCursorPositionChanged?.call();
    }
  }

  void _handleZoom(ScaleUpdateDetails details) {
    setState(() {
      _fontSize = (_fontSize * details.scale).clamp(10.0, 24.0);
    });
  }

  List<String> get _lines => _controller.text.split('\n');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
        ),
        child: GestureDetector(
          onScaleUpdate: _handleZoom,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line numbers
              Container(
                width: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
                  border: Border(
                    right: BorderSide(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _lines.length,
                  itemBuilder: (context, index) {
                    final lineNumber = index + 1;
                    final isCurrentLine = lineNumber == _currentLine;

                    return Container(
                      height: _fontSize * 1.5,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      color: isCurrentLine
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Text(
                        lineNumber.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontSize: _fontSize * 0.8,
                          color: isCurrentLine
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Code editor
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: _fontSize,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4.w),
                    hintText: '// Start coding here...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: _fontSize,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                      fontFamily: 'monospace',
                    ),
                  ),
                  scrollController: _scrollController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onTap: _updateCursorPosition,
                  onChanged: (value) => _onTextChanged(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
