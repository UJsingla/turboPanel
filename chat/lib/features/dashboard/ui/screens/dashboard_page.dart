import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final url = 'http://10.0.0.227:4200/';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      //   ..runJavaScript("""
      //   document.body.style.overscrollBehavior = 'none';
      //   document.documentElement.style.overscrollBehavior = 'none';
      //   document.body.style.touchAction = 'auto';
      // """)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Fade-in background to match the dashboard while the page loads.
            IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                opacity: _isLoading ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(2, 6, 23, 0.96),
                        Color.fromRGBO(2, 6, 23, 0.82),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const IgnorePointer(
                ignoring: true,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
