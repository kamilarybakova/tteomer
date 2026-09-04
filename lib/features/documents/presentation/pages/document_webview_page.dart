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
    final lower = url.toLowerCase();

    final isPresentationFile =
        lower.endsWith('.pptx') || lower.endsWith('.ppt');

    final isOfficeFile =
        isPresentationFile ||
        lower.endsWith('.doc') ||
        lower.endsWith('.docx') ||
        lower.endsWith('.xls') ||
        lower.endsWith('.xlsx');

    if (isPresentationFile) {
      return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(url)}';
    }

    if (isOfficeFile) {
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
          onPageStarted: (_) {
            if (mounted) {
              setState(() => isLoading = true);
            }
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() => isLoading = false);
            }
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');

            if (mounted) {
              setState(() => isLoading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  @override
  void dispose() {
    controller.runJavaScript('''
      document.querySelectorAll("audio, video").forEach(media => {
        media.pause();
        media.currentTime = 0;
      });
    ''');

    controller.loadHtmlString('<html><body></body></html>');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.runJavaScript('''
          document.querySelectorAll("audio, video").forEach(media => {
            media.pause();
            media.currentTime = 0;
          });
        ''');

        await controller.loadHtmlString('<html><body></body></html>');

        return true;
      },
      child: Scaffold(
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

            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
