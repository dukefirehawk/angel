import 'dart:collection';

import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:charcode/ascii.dart';
import 'package:logging/logging.dart';

abstract class PostgresGenerator {
  static String columnType(MigrationColumn column) {
    var str = column.type.name;
    if (column.type.hasLength) {
      return '$str(${column.length})';
    } else {
      return str;
    }
  }

  static String compileColumn(MigrationColumn column) {
    var buf = StringBuffer(columnType(column));

    if (column.isNullable == false) buf.write(' NOT NULL');
    if (column.defaultValue != null) {
      String s;
      var value = column.defaultValue;
      if (value is RawSql) {
        s = value.value;
      } else if (value is String) {
        var b = StringBuffer();
        for (var ch in value.codeUnits) {
          if (ch == $single_quote) {
            b.write("\\'");
          } else {
            b.writeCharCode(ch);
          }
        }
        s = '\'${b.toString()}\'';
      } else {
        s = value.toString();
      }
      buf.write(' DEFAULT $s');
    }

    if (column.indexType == IndexType.unique) {
      buf.write(' UNIQUE');
    } else if (column.indexType == IndexType.primaryKey) {
      buf.write(' PRIMARY KEY');
    }

    for (var ref in column.externalReferences) {
      buf.write(' ${compileReference(ref)}');
    }

    return buf.toString();
  }

  static String compileReference(MigrationColumnReference ref) {
    var buf =
        StringBuffer('REFERENCES "${ref.foreignTable}"("${ref.foreignKey}")');
    if (ref.behavior != null) buf.write(' ${ref.behavior!}');
    return buf.toString();
  }
}

class PostgresTable extends Table {
  final _log = Logger('PostgresTable');

  final Map<String, MigrationColumn> _columns = {};

  @override
  MigrationColumn declareColumn(String name, Column column) {
    if (_columns.containsKey(name)) {
      throw StateError('Cannot redeclare column "$name".');
    }
    var col = MigrationColumn.from(column);
    _columns[name] = col;
    return col;
  }

  void compile(StringBuffer buf, int indent) {
    var i = 0;

    _columns.forEach((name, column) {
      var col = PostgresGenerator.compileColumn(column);
      if (i++ > 0) buf.writeln(',');

      for (var i = 0; i < indent; i++) {
        buf.write('  ');
      }

      buf.write('"$name" $col');
    });

    _log.fine(buf);
  }
}

class PostgresAlterTable extends Table implements MutableTable {
  final Map<String, MigrationColumn> _columns = {};
  final String tableName;
  final Queue<String> _stack = Queue<String>();

  PostgresAlterTable(this.tableName);

  void compile(StringBuffer buf, int indent) {
    var i = 0;

    while (_stack.isNotEmpty) {
      var str = _stack.removeFirst();

      if (i++ > 0) buf.writeln(',');

      for (var i = 0; i < indent; i++) {
        buf.write('  ');
      }

      buf.write(str);
    }

    if (i > 0) buf.writeln(';');

    i = 0;
    _columns.forEach((name, column) {
      var col = PostgresGenerator.compileColumn(column);
      if (i++ > 0) buf.writeln(',');

      for (var i = 0; i < indent; i++) {
        buf.write('  ');
      }

      buf.write('ADD COLUMN "$name" $col');
    });
  }

  @override
  MigrationColumn declareColumn(String name, Column column) {
    if (_columns.containsKey(name)) {
      throw StateError('Cannot redeclare column "$name".');
    }
    var col = MigrationColumn.from(column);
    _columns[name] = col;
    return col;
  }

  @override
  void dropNotNull(String name) {
    _stack.add('ALTER COLUMN "$name" DROP NOT NULL');
  }

  @override
  void setNotNull(String name) {
    _stack.add('ALTER COLUMN "$name" SET NOT NULL');
  }

  @override
  void changeColumnType(String name, ColumnType type, {int length = 255}) {
    _stack.add(
        'ALTER COLUMN "$name" TYPE ${PostgresGenerator.columnType(MigrationColumn(type, length: length))}');
  }

  @override
  void renameColumn(String name, String newName) {
    _stack.add('RENAME COLUMN "$name" TO "$newName"');
  }

  @override
  void dropColumn(String name) {
    _stack.add('DROP COLUMN "$name"');
  }

  @override
  void rename(String newName) {
    _stack.add('RENAME TO "$newName"');
  }

  @override
  void addIndex(String name, List<String> columns, IndexType type) {
    String indexType = '';

    switch (type) {
      case IndexType.primaryKey:
        indexType = 'PRIMARY KEY';
        break;
      case IndexType.unique:
        indexType = 'CONSTRAINT "$name" UNIQUE';
        break;
      case IndexType.standardIndex:
      case IndexType.none:
        // not working with postgres
        return;
    }

    // mask the column names, is more safety
    columns.map((column) => '"$column"');

    _stack.add('ADD $indexType (${columns.join(',')})');
  }

  @override
  void dropIndex(String name) {
    _stack.add('DROP CONSTRAINT "$name"');
  }

  @override
  void dropPrimaryIndex() {
    _stack.add('DROP CONSTRAINT "${tableName}_pkey"');
  }
}

class PostgresIndexes implements MutableIndexes {
  final String tableName;
  final Queue<String> _stack = Queue<String>();

  PostgresIndexes(this.tableName);

  void compile(StringBuffer buf) {
    while (_stack.isNotEmpty) {
      buf.writeln(_stack.removeFirst());
    }
  }

  @override
  void addIndex(String name, List<String> columns, IndexType type) {
    // mask the column names, is more safety
    columns.map((column) => '"$column"');

    switch (type) {
      case IndexType.primaryKey:
        _stack.add(
          'ALTER TABLE "$tableName" ADD PRIMARY KEY (${columns.join(',')});',
        );
        break;
      case IndexType.unique:
        _stack.add(
          'CREATE UNIQUE INDEX IF NOT EXISTS "$name" '
          'ON "$tableName" (${columns.join(',')});',
        );
        break;
      //case IndexType.standardIndex:
      //case IndexType.none:
      default:
        _stack.add(
          'CREATE INDEX IF NOT EXISTS "$name" '
          'ON "$tableName" (${columns.join(',')});',
        );
        break;
    }
  }

  @override
  void dropIndex(String name) {
    _stack.add('DROP INDEX "$name";');
  }

  @override
  void dropPrimaryIndex() {
    _stack.add('ALTER TABLE "$tableName" DROP CONSTRAINT "${tableName}_pkey"');
  }
}
