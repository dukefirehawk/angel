# AI Context for Angel3

## Project Overview

**Angel3** is a production-ready, full-stack backend framework in Dart. It originated as a fork of the original Angel framework to support Dart SDK null-safety and later versions. It aims to streamline development by providing many common backend features out-of-the-box and enables developers to build both frontends and backends in Dart. It is highly modular, designed as a collection of plugins.

## Repository Structure

This repository is a **monorepo** managed using [Melos](https://pub.dev/packages/melos).

- **Packages**: Located in the `packages/` directory. Each sub-directory represents an individual plugin or module that can be published to `pub.dev` under the `angel3_` prefix.

## Core Architecture and Packages

The framework is divided into several categories of packages:

1. **Core Framework & Request Handling**:
   - `framework`: Base HTTP server, contexts, DI container, and middleware pipelines.
   - `route`: URL matching and route parameters.
   - `container`: Dependency Injection (DI) system.
   - `configuration`: Utilities for loading config files (YAML, JSON, .env).

2. **Data Modeling & Persistence (ORM)**:
   - `model`: Base model abstractions for data entities.
   - `serialize`: JSON serialization and deserialization using code generation.
   - `orm`: Main ORM library, code generator, and SQL dialects (MySQL, PostgreSQL)
   - `mongo`, `rethinkdb`, `sembast`: Specialized NoSQL database drivers.

3. **Authentication & Security**:
   - `auth`: Core authentication abstractions and strategies.
   - `auth_oauth2`, `oauth2`: OAuth2 authentication flows.
   - `security`: Security middleware (rate limiting, standard headers).
   - `cors`: Cross-Origin Resource Sharing handling.

4. **Frontend & Template Rendering**:
   - `jael`: Jael template engine built specifically for Angel.
   - `mustache`, `jinja`, `markdown`: Template integrations.
   - `html`, `seo`: Utilities for HTML responses and search engine optimization.

5. **Utilities**:
   - `websocket`: Real-time bidirectional communication.
   - `client`: Client-side library to interface directly with Angel3 backends.
   - `cache`, `redis`: Caching interfaces.
   - `hot`, `production`: Hot-reloading tooling and production load management.
   - `test`, `mock_request`: Testing utilities.

## Technology Stack & Requirements

- **Language**: Dart
- **Minimum SDK Version**: `>=3.11.0 <4.0.0`
- **Monorepo Management**: `melos` (`^7.3.0`)

## Development Workflow

- **Master Branch**: Stable production branch. Use this branch for all standard PR submissions.
- **feature/v9 Branch**: Early development for major refactoring targeting the `9.0.0` release. Contains breaking changes (e.g., restructure and rename packages).
- **Tooling**: Uses `melos` for managing dependencies and executing tasks across the monorepo (e.g., `melos exec "dart pub upgrade"`).

## Key Technical Debt and Future Roadmap

- Removal of dependency on the `dart:mirrors` library.
- Performance optimizations to address long-overdue issues.
- Integration of OpenAPI 3 support.
- Expanding ORM support for SQLite, multi-tenant architectures, and SQL schema reverse engineering.
- Out-of-the-box OIDC and SAML2 support.
