import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Image.network('https://example.com/some_image.jpg'),
    );
  }
}

void main() {
  testWidgets(
    'should properly mock Image.network and not crash',
    (WidgetTester tester) async {
      mockNetworkImagesFor(() => tester.pumpWidget(MyApp()));
    },
  );
}
