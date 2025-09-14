import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_toolbar.dart';
import './widgets/code_editor_content.dart';
import './widgets/code_editor_toolbar.dart';
import './widgets/file_explorer_panel.dart';
import './widgets/git_panel.dart';
import './widgets/search_replace_dialog.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> with TickerProviderStateMixin {
  late TextEditingController _codeController;
  bool _hasUnsavedChanges = false;
  bool _isFileExplorerVisible = false;
  bool _isGitPanelVisible = false;
  String _currentCode = '';

  // Mock initial code content
  final String _initialCode = '''

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '\$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}''';

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: _initialCode);
    _currentCode = _initialCode;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            // Handle edge swipes for panels
            if (details.globalPosition.dx < 50 && !_isFileExplorerVisible) {
              setState(() {
                _isFileExplorerVisible = true;
              });
            } else if (details.globalPosition.dx >
                    MediaQuery.of(context).size.width - 50 &&
                !_isGitPanelVisible) {
              setState(() {
                _isGitPanelVisible = true;
              });
            }
          },
          child: Stack(
            children: [
              // Main editor area
              Column(
                children: [
                  // Top toolbar
                  CodeEditorToolbar(
                    hasUnsavedChanges: _hasUnsavedChanges,
                    onSave: _saveCode,
                    onUndo: _undoChanges,
                    onRedo: _redoChanges,
                    onSearch: _showSearchDialog,
                  ),

                  // Code editor content
                  CodeEditorContent(
                    initialCode: _currentCode,
                    onCodeChanged: _onCodeChanged,
                    onCursorPositionChanged: () {
                      // Handle cursor position changes
                      HapticFeedback.selectionClick();
                    },
                  ),

                  // Bottom toolbar
                  BottomToolbar(
                    onSymbolInsert: _insertSymbol,
                    onIndentIncrease: _increaseIndent,
                    onIndentDecrease: _decreaseIndent,
                  ),
                ],
              ),

              // File explorer panel (left)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: FileExplorerPanel(
                  isVisible: _isFileExplorerVisible,
                  onClose: () {
                    setState(() {
                      _isFileExplorerVisible = false;
                    });
                  },
                  onFileSelected: _openFile,
                ),
              ),

              // Git panel (right)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GitPanel(
                  isVisible: _isGitPanelVisible,
                  onClose: () {
                    setState(() {
                      _isGitPanelVisible = false;
                    });
                  },
                ),
              ),

              // Panel overlay (to close panels when tapping outside)
              if (_isFileExplorerVisible || _isGitPanelVisible)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFileExplorerVisible = false;
                        _isGitPanelVisible = false;
                      });
                    },
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Floating action button for search
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'search',
          size: 6.w,
          color: Colors.white,
        ),
      ),

      // App bar with navigation
      appBar: AppBar(
        title: Text(
          'CodeCraft Editor',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/project-dashboard'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFileExplorerVisible = !_isFileExplorerVisible;
              });
            },
            icon: CustomIconWidget(
              iconName: 'folder',
              size: 6.w,
              color: _isFileExplorerVisible
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isGitPanelVisible = !_isGitPanelVisible;
              });
            },
            icon: CustomIconWidget(
              iconName: 'source',
              size: 6.w,
              color: _isGitPanelVisible
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'build',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'build',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    Text('Build & Deploy'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'repository',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'cloud',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 3.w),
                    Text('Repository'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _onCodeChanged(String newCode) {
    setState(() {
      _currentCode = newCode;
      _hasUnsavedChanges = newCode != _initialCode;
    });
  }

  void _saveCode() {
    // Simulate saving code
    HapticFeedback.lightImpact();
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _undoChanges() {
    HapticFeedback.selectionClick();
    // Implement undo functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Undo performed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _redoChanges() {
    HapticFeedback.selectionClick();
    // Implement redo functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redo performed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _insertSymbol(String symbol) {
    HapticFeedback.selectionClick();
    final currentPosition = _codeController.selection.baseOffset;
    final newText = _currentCode.substring(0, currentPosition) +
        symbol +
        _currentCode.substring(currentPosition);

    setState(() {
      _currentCode = newText;
      _hasUnsavedChanges = true;
    });
  }

  void _increaseIndent() {
    HapticFeedback.selectionClick();
    _insertSymbol('    '); // 4 spaces for indentation
  }

  void _decreaseIndent() {
    HapticFeedback.selectionClick();
    // Implement decrease indent logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Indent decreased'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openFile(String fileName) {
    HapticFeedback.selectionClick();
    setState(() {
      _isFileExplorerVisible = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opened: $fileName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => SearchReplaceDialog(
        onSearch: (searchText,
            {bool caseSensitive = false, bool useRegex = false}) {
          Navigator.pop(context);
          _performSearch(searchText,
              caseSensitive: caseSensitive, useRegex: useRegex);
        },
        onReplace: (searchText, replaceText, {bool replaceAll = false}) {
          Navigator.pop(context);
          _performReplace(searchText, replaceText, replaceAll: replaceAll);
        },
      ),
    );
  }

  void _performSearch(String searchText,
      {bool caseSensitive = false, bool useRegex = false}) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: $searchText'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _performReplace(String searchText, String replaceText,
      {bool replaceAll = false}) {
    HapticFeedback.lightImpact();
    final action = replaceAll ? 'Replace all' : 'Replace';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: "$searchText" with "$replaceText"'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        Navigator.pushNamed(context, '/settings-profile');
        break;
      case 'build':
        Navigator.pushNamed(context, '/build-deploy');
        break;
      case 'repository':
        Navigator.pushNamed(context, '/repository-browser');
        break;
    }
  }
}
