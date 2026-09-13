import 'package:flutter/material.dart';
import 'package:tteomer/core/utils/app_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

Uri resolveDocumentUrl(String rawUrl) {
  final value = rawUrl.trim();
  final parsed = Uri.parse(value);

  if (parsed.hasScheme) return parsed;

  return Uri.parse(AppConfig.apiBaseUrl).resolve(value);
}

Uri buildDocumentViewerUrl(String rawUrl) {
  final documentUrl = resolveDocumentUrl(rawUrl);
  final path = documentUrl.path.toLowerCase();

  final isPresentationFile = path.endsWith('.pptx') || path.endsWith('.ppt');
  final isGoogleViewerFile =
      path.endsWith('.pdf') ||
      path.endsWith('.doc') ||
      path.endsWith('.docx') ||
      path.endsWith('.xls') ||
      path.endsWith('.xlsx');

  if (isPresentationFile) {
    return Uri.https('view.officeapps.live.com', '/op/embed.aspx', {
      'src': documentUrl.toString(),
    });
  }

  // Android WebView cannot render PDF files by itself. Google Viewer also
  // gives Word and Excel files a consistent in-app preview on both platforms.
  if (isGoogleViewerFile) {
    return Uri.https('docs.google.com', '/gview', {
      'embedded': 'true',
      'url': documentUrl.toString(),
    });
  }

  return documentUrl;
}

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

  @override
  void initState() {
    super.initState();

    final viewerUrl = buildDocumentViewerUrl(widget.url);

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
      ..loadRequest(viewerUrl);
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

          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
