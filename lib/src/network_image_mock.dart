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

class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri? url) {
    return super.noSuchMethod(Invocation.method(#getUrl, [url]),
        returnValue: Future.value(MockHttpClientRequest()));
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => super.noSuchMethod(Invocation.getter(#headers),
      returnValue: MockHttpHeaders());

  @override
  Future<HttpClientResponse> close() =>
      super.noSuchMethod(Invocation.method(#close, []),
          returnValue: Future.value(MockHttpClientResponse()));
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  HttpClientResponseCompressionState get compressionState =>
      super.noSuchMethod(Invocation.getter(#compressionState),
          returnValue: HttpClientResponseCompressionState.notCompressed);

  @override
  int get contentLength =>
      super.noSuchMethod(Invocation.getter(#contentLength), returnValue: 0);

  @override
  int get statusCode =>
      super.noSuchMethod(Invocation.getter(#statusCode), returnValue: 0);

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      super.noSuchMethod(
          Invocation.method(#listen, [
            onData,
          ], {
            Symbol("onError"): onError,
            Symbol("onDone"): onDone,
            Symbol("cancelOnError"): cancelOnError,
          }),
          returnValue: MockStreamSubscription<List<int>>());
}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}

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
    final bool? cancelOnError = invocation.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(<List<int>>[image]).listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  });

  return client;
}

//transparent pixel in png format
final image = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
);
