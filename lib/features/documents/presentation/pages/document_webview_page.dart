import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const DocumentWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<DocumentWebViewPage> createState() => _DocumentWebViewPageState();
}

class _DocumentWebViewPageState extends State<DocumentWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  String _buildViewerUrl(String url) {
    final isPptx = url.toLowerCase().endsWith('.pptx') ||
        url.toLowerCase().contains('.pptx');

    if (isPptx) {
      return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(url)}';
    }

    return url;
  }

  @override
  void initState() {
    super.initState();

    final viewerUrl = _buildViewerUrl(widget.url);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}