import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/src/network_image_mock.dart';

Widget makeTestableWidget() => MaterialApp(home: Image.network(''));

void main() {
  group('createMockImageHttpClient', () {
    test('should return an image', () async {
      final MockHttpClient client = createMockImageHttpClient();

      final HttpClientRequest request = await client.getUrl(Uri());
      final HttpClientResponse response = await request.close();

      await response
          .listen((List<int> img) => expect(img, equals(image)))
          .asFuture();
    });

    test('should return image when listening with all callbacks', () async {
      final MockHttpClient client = createMockImageHttpClient();

      final HttpClientRequest request = await client.getUrl(Uri());
      final HttpClientResponse response = await request.close();

      await response
          .listen((List<int> img) => expect(img, equals(image)),
              onError: (err, stack) {}, onDone: () {}, cancelOnError: true)
          .asFuture();
    });
  });

  group('mockNetworkImageFor', () {
    testWidgets(
      'should properly mock Image.network and not crash',
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
            () => tester.pumpWidget(makeTestableWidget()));
      },
    );
  });
}
