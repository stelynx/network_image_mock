import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';

/// Runs [body] in separate [Zone] with [MockHttpClient].
R mockNetworkImagesFor<R>(R body()) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => createMockImageHttpClient(),
  );
}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

/// Returns a [MockHttpClient] that responds with demo image to all requests.
MockHttpClient createMockImageHttpClient() {
  final MockHttpClient client = MockHttpClient();
  final MockHttpClientRequest request = MockHttpClientRequest();
  final MockHttpClientResponse response = MockHttpClientResponse();
  final MockHttpHeaders headers = MockHttpHeaders();

  when(client.getUrl(any))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));
  when(request.headers).thenReturn(headers);
  when(request.close())
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(response.contentLength).thenReturn(image.length);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(
    any,
    onError: anyNamed("onError"),
    onDone: anyNamed("onDone"),
    cancelOnError: anyNamed("cancelOnError"),
  )).thenAnswer((Invocation invocation) {
    final void Function(List<int>) onData = invocation.positionalArguments[0];
    final onDone = invocation.namedArguments[#onDone];
    final onError = invocation.namedArguments[#onError];
    final bool cancelOnError = invocation.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(<List<int>>[image]).listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  });

  return client;
}

//transparent pixel in png format
final image = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
);
