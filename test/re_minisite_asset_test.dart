import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('RE includes the full original standalone microsite offline', () async {
    final html = await rootBundle.loadString('assets/re/index.html');
    expect(html.length, greaterThan(3000000));
    expect(html, contains('<!doctype html>'));
    expect(html, contains('مسعود اتحادنژاد'));
    expect(html, contains('اتحاد سازه رویال'));
    expect(html, contains('۳۶۰۰'));
    expect(html, contains('data:image/webp;base64,'));
    expect(RegExp('data:image/webp;base64,').allMatches(html).length,
        greaterThanOrEqualTo(9));
    for (final anchor in ['#profile', '#services', '#projects',
                          '#gallery', '#contact']) {
      expect(html, contains(anchor));
    }
    expect(html, contains('https://sahand-consortium.com/'));
    expect(html, contains('copyRequest'));
    expect(html, contains('</html>'));
  });
}
