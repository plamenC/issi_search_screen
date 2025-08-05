import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../infrastructure/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  WebViewController _createWebViewController() {
    final controller = WebViewController();

    // Set JavaScript mode only for supported platforms
    if (WebViewPlatform.instance is AndroidWebViewPlatform ||
        WebViewPlatform.instance is WebKitWebViewPlatform) {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

    controller.loadRequest(Uri.parse('https://www.corllete.com'));
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 64, color: AppColors.primaryIndigo),
          SizedBox(height: 16),
          Text(
            'Начало',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Добре дошли в приложението'),
          Expanded(
            child: WebViewWidget(controller: _createWebViewController()),
          ),
        ],
      ),
    );
  }
}
