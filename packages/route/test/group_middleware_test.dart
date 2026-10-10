import 'package:angel3_route/angel3_route.dart';
import 'package:test/test.dart';

void main() {
  List<String> handlersFor(Router<String> router, String path) =>
      router.resolveAbsolute(path).first.allHandlers;

  test('group middleware runs before the route', () {
    var router = Router<String>()
      ..group('/a', (r) => r.get('/b', 'h'), middleware: ['mw']);
    expect(handlersFor(router, '/a/b'), ['mw', 'h']);
  });

  test('nested group middleware runs outermost first', () {
    var router = Router<String>()
      ..group('/a', (r) {
        r.group('/b', (r) => r.get('/c', 'h'), middleware: ['inner']);
      }, middleware: ['outer']);
    expect(handlersFor(router, '/a/b/c'), ['outer', 'inner', 'h']);
  });

  test('group middleware applies to a group at the root path', () {
    var router = Router<String>()
      ..group('/', (r) => r.get('/x', 'h'), middleware: ['mw']);
    expect(handlersFor(router, '/x'), ['mw', 'h']);
  });

  test('a mounted router keeps its middleware', () {
    var router = Router<String>()
      ..mount(
        '/m',
        Router<String>()
          ..group('/', (r) => r.get('/x', 'h'), middleware: ['mw']),
      );
    expect(handlersFor(router, '/m/x'), ['mw', 'h']);
  });

  test('flatten keeps group middleware', () {
    var router = Router<String>()
      ..group('/a', (r) {
        r.group('/b', (r) => r.get('/c', 'h'), middleware: ['inner']);
      }, middleware: ['outer']);
    expect(handlersFor(flatten(router), '/a/b/c'), ['outer', 'inner', 'h']);
  });

  test('chain with group does not run middleware twice', () {
    var router = Router<String>()
      ..chain(['a']).group('/b', (r) => r.get('/c', 'h'), middleware: ['m']);
    expect(handlersFor(router, '/b/c'), ['a', 'm', 'h']);
  });

  test('a router mounted on a chain gets the chained middleware', () {
    var router = Router<String>();
    router.chain(['a']).mount('/m', Router<String>()..get('/x', 'h'));
    expect(handlersFor(router, '/m/x'), ['a', 'h']);
  });
}
