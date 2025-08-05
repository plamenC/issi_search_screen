import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../infrastructure/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static WebViewController? _persistentController;
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  final String _initialUrl = 'https://www.google.com';

  @override
  void initState() {
    super.initState();
    _urlController.text = _initialUrl;
    _initializeController();
  }

  Future<void> _initializeController() async {
    if (_persistentController == null) {
      _persistentController = _createWebViewController();
    }
    setState(() {});
  }

  WebViewController _createWebViewController() {
    final controller = WebViewController();

    // Set JavaScript mode only for supported platforms
    if (WebViewPlatform.instance is AndroidWebViewPlatform ||
        WebViewPlatform.instance is WebKitWebViewPlatform) {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

    // Add navigation delegate to track loading state (only for supported platforms)
    if (WebViewPlatform.instance is AndroidWebViewPlatform ||
        WebViewPlatform.instance is WebKitWebViewPlatform) {
      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _urlController.text = url;
            });
          },
        ),
      );
    }

    controller.loadRequest(Uri.parse(_initialUrl));
    return controller;
  }

  void _navigateToUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty && _persistentController != null) {
      String fullUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        fullUrl = 'https://$url';
      }
      _persistentController!.loadRequest(Uri.parse(fullUrl));
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Home header
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.home_outlined,
                size: 64,
                color: AppColors.primaryIndigo,
              ),
              const SizedBox(height: 16),
              Text(
                'Начало',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Добре дошли в приложението'),
            ],
          ),
        ),
        // Address bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () async {
                  if (_persistentController != null &&
                      await _persistentController!.canGoBack()) {
                    _persistentController!.goBack();
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
              // Forward button
              IconButton(
                onPressed: () async {
                  if (_persistentController != null &&
                      await _persistentController!.canGoForward()) {
                    _persistentController!.goForward();
                  }
                },
                icon: const Icon(Icons.arrow_forward),
              ),
              // Refresh button
              IconButton(
                onPressed: () {
                  _persistentController?.reload();
                },
                icon: const Icon(Icons.refresh),
              ),
              // URL text field
              Expanded(
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Enter URL...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    suffixIcon: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            onPressed: _navigateToUrl,
                            icon: const Icon(Icons.navigate_next),
                          ),
                  ),
                  onSubmitted: (_) => _navigateToUrl(),
                ),
              ),
            ],
          ),
        ),
        // WebView
        Expanded(
          child: _persistentController != null
              ? WebViewWidget(controller: _persistentController!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
