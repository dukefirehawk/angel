import 'dart:async' show Stream, StreamController;
import 'dart:html';

import 'package:path/path.dart' as p;

import 'angel_route.dart';

final RegExp _hash = RegExp(r'^#/');
final RegExp _straySlashes = RegExp(r'(^/+)|(/+$)');

/// A variation of the [Router] support both hash routing and push state.
abstract class BrowserRouter<T> extends Router<T> {
  /// Fires whenever the active route changes. Fires `null` if none is selected (404).
  Stream<RoutingResult<T>?> get onResolve;

  /// Fires whenever the active route changes. Fires `null` if none is selected (404).
  Stream<Route<T>?> get onRoute;

  /// Set `hash` to true to use hash routing instead of push state.
  /// `listen` as `true` will call `listen` after initialization.
  factory BrowserRouter({bool hash = false, bool listen = false}) {
    return hash
        ? _HashRouter<T>(listen: listen)
        : _PushStateRouter<T>(listen: listen);
  }

  BrowserRouter._() : super();

  void _goTo(String? path);

  /// Navigates to the path generated by calling
  /// [navigate] with the given [linkParams].
  ///
  /// This always navigates to an absolute path.
  void go(List linkParams);

  // Handles a route path, manually.
  // void handle(String path);

  /// Begins listen for location changes.
  void listen();

  /// Identical to [all].
  Route on(String path, T handler, {Iterable<T>? middleware});
}

abstract class _BrowserRouterImpl<T> extends Router<T>
    implements BrowserRouter<T> {
  bool _listening = false;
  Route? _current;
  StreamController<RoutingResult<T>?> _onResolve =
      StreamController<RoutingResult<T>?>();
  StreamController<Route<T>?> _onRoute = StreamController<Route<T>?>();

  Route? get currentRoute => _current;

  @override
  Stream<RoutingResult<T>?> get onResolve => _onResolve.stream;

  @override
  Stream<Route<T>?> get onRoute => _onRoute.stream;

  _BrowserRouterImpl({bool? listen}) : super() {
    if (listen != false) this.listen();
    prepareAnchors();
  }

  @override
  void go(Iterable linkParams) => _goTo(navigate(linkParams));

  Route on(String path, T handler, {Iterable<T>? middleware}) =>
      all(path, handler, middleware: middleware);

  void prepareAnchors() {
    final anchors = window.document
        .querySelectorAll('a')
        .cast<AnchorElement>(); //:not([dynamic])');

    for (final AnchorElement $a in anchors) {
      if ($a.attributes.containsKey('href') &&
          !$a.attributes.containsKey('download') &&
          !$a.attributes.containsKey('target') &&
          $a.attributes['rel'] != 'external') {
        $a.onClick.listen((e) {
          e.preventDefault();
          _goTo($a.attributes['href']);
          //go($a.attributes['href'].split('/').where((str) => str.isNotEmpty));
        });
      }

      $a.attributes['dynamic'] = 'true';
    }
  }

  void _listen();

  @override
  void listen() {
    if (_listening) {
      throw StateError('The router is already listening for page changes.');
    }
    _listening = true;
    _listen();
  }
}

class _HashRouter<T> extends _BrowserRouterImpl<T> {
  _HashRouter({required bool listen}) : super(listen: listen) {
    if (listen) this.listen();
  }

  @override
  void _goTo(String? uri) {
    window.location.hash = '#$uri';
  }

  void handleHash([_]) {
    final path = window.location.hash.replaceAll(_hash, '');
    Iterable<RoutingResult<T>> allResolved = resolveAbsolute(path);

    final resolved = allResolved.isEmpty ? null : allResolved.first;

    if (resolved == null) {
      _onResolve.add(null);
      _onRoute.add(_current = null);
    } else if (resolved != null && resolved.route != _current) {
      _onResolve.add(resolved);
      _onRoute.add(_current = resolved.route);
    }
  }

  void handlePath(String path) {
    final RoutingResult<T> resolved = resolveAbsolute(path).first;

    if (resolved == null) {
      _onResolve.add(null);
      _onRoute.add(_current = null);
    } else if (resolved != null && resolved.route != _current) {
      _onResolve.add(resolved);
      _onRoute.add(_current = resolved.route);
    }
  }

  @override
  void _listen() {
    window.onHashChange.listen(handleHash);
    handleHash();
  }
}

class _PushStateRouter<T> extends _BrowserRouterImpl<T> {
  String? _basePath;

  _PushStateRouter({required bool listen, Route? root}) : super(listen: listen) {
    var $base = window.document.querySelector('base[href]') as BaseElement;

    if ($base?.href?.isNotEmpty != true) {
      throw StateError(
          'You must have a <base href="<base-url-here>"> element present in your document to run the push state router.');
    }
    _basePath = $base.href.replaceAll(_straySlashes, '');
    if (listen) this.listen();
  }

  @override
  void _goTo(String? uri) {
    final RoutingResult<T> resolved = resolveAbsolute(uri).first;
    var relativeUri = uri;

    if (_basePath?.isNotEmpty == true) {
      relativeUri = p.join(_basePath!, uri!.replaceAll(_straySlashes, ''));
    }

    if (resolved == null) {
      _onResolve.add(null);
      _onRoute.add(_current = null);
    } else {
      final route = resolved.route!;
      window.history.pushState({'path': route.path, 'params': {}},
          route.name ?? route.path, relativeUri);
      _onResolve.add(resolved);
      _onRoute.add(_current = route);
    }
  }

  void handleState(state) {
    if (state is Map && state.containsKey('path')) {
      var path = state['path'].toString();
      final RoutingResult<T> resolved = resolveAbsolute(path).first;

      if (resolved != null && resolved.route != _current) {
        //properties.addAll(state['properties'] ?? {});
        _onResolve.add(resolved);
        _onRoute.add(_current = resolved.route);
      } else {
        _onResolve.add(null);
        _onRoute.add(_current = null);
      }
    } else {
      _onResolve.add(null);
      _onRoute.add(_current = null);
    }
  }

  @override
  void _listen() {
    window.onPopState.listen((e) {
      handleState(e.state);
    });

    handleState(window.history.state);
  }
}
