import 'dart:convert';

import 'package:angel3_mock_request/angel3_mock_request.dart';
import 'package:test/test.dart';

Future<List<int>> bytesOf(Stream<List<int>> stream) =>
    stream.fold<List<int>>([], (out, chunk) => out..addAll(chunk));

void main() {
  const text = 'héllo ☺ 👋';

  group('MockHttpRequest', () {
    test('write encodes text as UTF-8', () async {
      var rq = MockHttpRequest('POST', Uri(path: '/'))
        ..write(text)
        ..writeAll(['a', 'é'], '-')
        ..writeCharCode(0x263A)
        ..writeln('!');
      await rq.close();
      expect(
        utf8.decode(await bytesOf(rq)),
        '$text'
        'a-é☺!\r\n',
      );
    });

    test('contentLength counts each byte once', () async {
      var rq = MockHttpRequest('POST', Uri(path: '/'))
        ..add(utf8.encode('hello'))
        ..write('é');
      await rq.close();
      expect(rq.contentLength, 7);
    });
  });

  group('MockHttpResponse', () {
    MockHttpResponse response({int statusCode = 200, Encoding? encoding}) =>
        MockHttpResponse(
          statusCode: statusCode,
          reasonPhrase: '',
          contentLength: 0,
          encoding: encoding ?? utf8,
          persistentConnection: false,
        );

    test('keeps the statusCode it is given', () {
      expect(response(statusCode: 404).statusCode, 404);
    });

    test('write encodes text with its encoding', () async {
      var rs = response()
        ..write(text)
        ..writeCharCode(0x263A);
      await rs.close();
      expect(utf8.decode(await bytesOf(rs)), '$text☺');

      var latin = response(encoding: latin1)..write('é');
      await latin.close();
      expect(await bytesOf(latin), [0xE9]);
    });
  });
}
