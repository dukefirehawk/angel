import 'dart:async';
import 'dart:convert';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
//import 'package:angel_test/angel_test.dart';
import 'package:angel_validate/server.dart';
import 'package:logging/logging.dart';
import 'package:mock_request/mock_request.dart';
import 'package:test/test.dart';

final Validator echoSchema = Validator({'message*': isString});

void printRecord(LogRecord rec) {
  print(rec);
  if (rec.error != null) print(rec.error);
  if (rec.stackTrace != null) print(rec.stackTrace);
}

void main() {
  Angel app;
  AngelHttp http;
  //TestClient client;

  setUp(() async {
    app = Angel();
    http = AngelHttp(app, useZone: false);

    app.chain([validate(echoSchema)]).post('/echo',
        (RequestContext req, res) async {
      await req.parseBody();
      res.write('Hello, ${req.bodyAsMap['message']}!');
    });

    app.logger = Logger('angel')..onRecord.listen(printRecord);
    //client = await connectTo(app);
  });

  tearDown(() async {
    //await client.close();
    await http.close();
    app = null;
    //client = null;
  });

  group('echo', () {
    //test('validate', () async {
    //  var response = await client.post('/echo',
    //      body: {'message': 'world'}, headers: {'accept': '*/*'});
    //  print('Response: ${response.body}');
    //  expect(response, hasStatus(200));
    //  expect(response.body, equals('Hello, world!'));
    //});

    test('enforce', () async {
      var rq = MockHttpRequest('POST', Uri(path: '/echo'))
        ..headers.add('accept', '*/*')
        ..headers.add('content-type', 'application/json')
        ..write(json.encode({'foo': 'bar'}));

      scheduleMicrotask(() async {
        await rq.close();
        await http.handleRequest(rq);
      });

      var responseBody = await rq.response.transform(utf8.decoder).join();
      print('Response: $responseBody');
      expect(rq.response.statusCode, 400);
    });
  });
}