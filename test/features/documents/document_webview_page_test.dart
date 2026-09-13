import 'package:flutter_test/flutter_test.dart';
import 'package:tteomer/features/documents/presentation/pages/document_webview_page.dart';

void main() {
  group('buildDocumentViewerUrl', () {
    test('opens PDF through Google Viewer', () {
      final result = buildDocumentViewerUrl(
        'https://tteomer.dev/media/lesson.pdf',
      );

      expect(result.host, 'docs.google.com');
      expect(result.path, '/gview');
      expect(result.queryParameters['embedded'], 'true');
      expect(
        result.queryParameters['url'],
        'https://tteomer.dev/media/lesson.pdf',
      );
    });

    test('detects the file extension when URL has query parameters', () {
      final result = buildDocumentViewerUrl(
        'https://tteomer.dev/media/lesson.docx?download=1',
      );

      expect(result.host, 'docs.google.com');
      expect(
        result.queryParameters['url'],
        'https://tteomer.dev/media/lesson.docx?download=1',
      );
    });

    test('turns a relative API file URL into an absolute URL', () {
      final result = buildDocumentViewerUrl('/media/lesson.pdf');

      expect(
        result.queryParameters['url'],
        'https://tteomer.dev/media/lesson.pdf',
      );
    });

    test('opens presentations through Office Viewer', () {
      final result = buildDocumentViewerUrl(
        'https://tteomer.dev/media/lesson.pptx',
      );

      expect(result.host, 'view.officeapps.live.com');
      expect(result.path, '/op/embed.aspx');
      expect(
        result.queryParameters['src'],
        'https://tteomer.dev/media/lesson.pptx',
      );
    });

    test('opens web-compatible files directly', () {
      final result = buildDocumentViewerUrl(
        'https://tteomer.dev/media/lesson.mp4',
      );

      expect(result.toString(), 'https://tteomer.dev/media/lesson.mp4');
    });
  });
}
