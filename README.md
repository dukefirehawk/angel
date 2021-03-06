# Angel3 Framework

[![Angel3 Framework](./logo3.png)](https://github.com/dukefirehawk/angel)

[![version](https://img.shields.io/badge/pub-v4.0.0-brightgreen)](https://pub.dartlang.org/packages/framework)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/angel_dart/discussion)

[![License](https://img.shields.io/github/license/dukefirehawk/angel)](https://github.com/dukefirehawk/angel/LICENSE)

**A polished, production-ready backend framework in Dart with NNBD support.**

-----

## About

Angel3 is a fork of the original Angel framework to support NNBD in Dart SDK 2.12.x and above.
It is a full-stack Web framework in Dart that aims to streamline development by providing many common features out-of-the-box in a consistent manner. One of the main goal is to enable developers to build both frontend
and backend in the same language, Dart. Angel3 framework is designed as a collection of plugins that enable developers to pick and choose the parts needed for their projects. A series of starter templates are also provided for quick start and trial run with Angel3 framework.  

The availabe features in Angel3 are:

* Static File Handling
* Basic Authentication
* PostgreSQL ORM
* GraphQL
* And much more...

See all the available [`packages`](https://angel3-docs.dukefirehawk.com/packages) for more information.

## Important Notes

The migration of Angel Framework to Angel3 Framework is still ongoing. About 65 out of 70++ packages have been migrated and tested to be stable and working as expected. Angel3 framework need more testing to get it to production quality. Hence, the Angel3 stable packages have been published with prefix `angel3_` on `pub.dev`for developers to try out.

In order to acknowledge contributions, AUTHORS.md has been added to every Angel3 packages. This way no matter what the contributions are, be it code review, testing or submit PR, can all be recorded in this file. If you are the original author of the Angel packages, feel free to send a PR to update that file.

Branch: master

* Stable version of `angel3` branch

Branch: angel3 (Active development)

* Dart version : 2.12.x and above. Use sdk: ">=2.12.0 <3.0.0" in pubspec.yml
* Publish      : Yes. See all packages with `angel3_` prefix on [pub.dev](https://pub.dev/publishers/dukefirehawk.com/packages).
* NNDB Support : Yes
* Status       : Beta
* Notes        : Basic, ORM and GraphQL templates are working. Not all packages are fully tested.

Branch: sdk-2.12.x-nnbd (Active development)

* Dart version : 2.12.x and above. Use sdk: ">=2.12.0 <3.0.0" in pubspec.yml
* Publish      : No (For NNBD migration use only)
* NNDB Support : Yes
* Status       : Beta
* Notes        : Basic and ORM templates are working. Not all packages are fully tested.

For more details, checkout [Project Status](https://github.com/dukefirehawk/angel/wiki/Project-Status)

## Installation and Setup

1. Download and install [Dart](https://dart.dev/get-dart)
2. Download one of the following starter projects:
   * [Angel3 Basic Template](https://github.com/dukefirehawk/boilerplates/tree/angel3-basic)
   * [Angel3 ORM Template](https://github.com/dukefirehawk/boilerplates/tree/angel3-orm)
   * [Angel3 Graphql Template](https://github.com/dukefirehawk/boilerplates/tree/angel3-graphql)
3. Next, check out the [detailed documentation](https://angel3-docs.dukefirehawk.com/) to learn to flesh out your project. For the current release of Angel3, the existing documents and tutorials for Angel are still relevant and works. In the future, these resources will be migrated and updated accordingly.

### Installation with Angel3 CLI

**Note: Still work in progress.**

Install the [Angel3 CLI](https://pub.dev/packages/angel3_cli):

```bash
pub global activate angel3_cli
```

Bootstrap a project:

```bash
angel3 init hello
```

You can even have your server run and be *hot-reloaded* on file changes:

```bash
dart --observe bin/dev.dart
```

### Migrating to Angel3

Check out [Migrating to Angel3](https://angel3-docs.dukefirehawk.com/migration/angel-2.x.x-to-angel3/migration-guide-3)

## Examples and Documentation

Visit the [User Guide](https://angel3-docs.dukefirehawk.com/) for dozens of guides and resources, including video tutorials, to get up and running as quickly as possible with Angel3 framework.

Examples and complete projects can be found [here](https://github.com/dukefirehawk/angel3-examples).

You can also view the [Angel3 API](http://www.dartdocs.org/documentation/angel_framework/latest).

There is also an [Awesome Angel :fire:](https://github.com/dukefirehawk/angel3-awesome) list.

## Contributing

Interested in contributing to Angel3? See the contribution guide [here](CONTRIBUTING.md).
