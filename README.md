# Network Image Mock

[![Pub Version](https://img.shields.io/pub/v/network_image_mock?color=%233dc6fd&logo=flutter&logoColor=%233dc6fd)](https://pub.dev/packages/network_image_mock)
![Lint & Test](https://github.com/stelynx/network_image_mock/workflows/Lint%20&%20Test/badge.svg)
[![codecov.io](https://codecov.io/gh/stelynx/network_image_mock/branch/master/graphs/badge.svg)](https://codecov.io/gh/stelynx/network_image_mock/branch/master)

A utility for providing mocked response to `Image.network` in Flutter widget tests.

## Introduction

Since you are here you probably already know that calling Image.network results in 400
response in Flutter widget tests. The reason for this is that default HTTP client in tests
always return a 400.

So, what can we do about it? Instead of copying the whole code over and over again for mocking
the HTTP client, I created this package. It is heavily inspired by [roughike/image_test_utils](https://github.com/roughike/image_test_utils), however that package is not being maintained despite multiple pull requests
asking for bumping the `mockito` version and making the package usable again.

## Installing

This package should be installed under `dev_dependencies` like

```yaml
dev_dependencies:
  network_image_mock: ^1.0.2
```

## Example

The package is quite straightforward to use. All you have to do is include it in your test
file and wrap widget testing functions that require proper `Image.network` response in
`mockNetworkImagesFor()` function provided by this package. A full test example could look like this.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

Widget makeTestableWidget() => MaterialApp(home: Image.network(''));

void main() {
  testWidgets(
    'should properly mock Image.network and not crash',
    (WidgetTester tester) async {
      mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidget()));
    },
  );
}
```

This is actually an example taken from tests for this package.

## Contributing

There is not much to contribute since the package serves its purpose, however, in chance of needing to bump or adjust some version, or any other suggestion for that matter, please read [CONTRIBUTING](CONTRIBUTING.md).
