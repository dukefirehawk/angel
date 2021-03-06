// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'has_map.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class HasMapMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('has_maps', (table) {
      table.declare('value', ColumnType('jsonb'));
      table.declare('list', ColumnType('jsonb'));
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('has_maps');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class HasMapQuery extends Query<HasMap, HasMapQueryWhere> {
  HasMapQuery({Query? parent, Set<String>? trampoline})
      : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = HasMapQueryWhere(this);
  }

  @override
  final HasMapQueryValues values = HasMapQueryValues();

  HasMapQueryWhere? _where;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'has_maps';
  }

  @override
  List<String> get fields {
    return const ['value', 'list'];
  }

  @override
  HasMapQueryWhere? get where {
    return _where;
  }

  @override
  HasMapQueryWhere newWhereClause() {
    return HasMapQueryWhere(this);
  }

  static Optional<HasMap> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }

    var m = {};
    m[row[0]] = row[0];
    var model = HasMap(value: m, list: [row[1]]);
    return Optional.of(model);
  }

  @override
  Optional<HasMap> deserialize(List row) {
    return parseRow(row);
  }
}

class HasMapQueryWhere extends QueryWhere {
  HasMapQueryWhere(HasMapQuery query)
      : value = MapSqlExpressionBuilder(query, 'value'),
        list = ListSqlExpressionBuilder(query, 'list');

  final MapSqlExpressionBuilder value;

  final ListSqlExpressionBuilder list;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [value, list];
  }
}

class HasMapQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'list': 'jsonb'};
  }

  Map<dynamic, dynamic> get value {
    return (values['value'] as Map<dynamic, dynamic>);
  }

  set value(Map<dynamic, dynamic> value) => values['value'] = value;
  List<dynamic> get list {
    return (json.decode((values['list'] as String)) as List);
  }

  set list(List<dynamic> value) => values['list'] = json.encode(value);
  void copyFrom(HasMap model) {
    value = model.value;
    list = model.list;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class HasMap implements _HasMap {
  const HasMap({this.value = const {}, this.list = const []});

  @override
  final Map<dynamic, dynamic> value;

  @override
  final List<dynamic> list;

  HasMap copyWith(
      {Map<dynamic, dynamic> value = const {}, List<dynamic> list = const []}) {
    return HasMap(value: value, list: list);
  }

  @override
  bool operator ==(other) {
    return other is _HasMap &&
        MapEquality<dynamic, dynamic>(
                keys: DefaultEquality(), values: DefaultEquality())
            .equals(other.value, value) &&
        ListEquality<dynamic>(DefaultEquality()).equals(other.list, list);
  }

  @override
  int get hashCode {
    return hashObjects([value, list]);
  }

  @override
  String toString() {
    return 'HasMap(value=$value, list=$list)';
  }

  Map<String, dynamic> toJson() {
    return HasMapSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const HasMapSerializer hasMapSerializer = HasMapSerializer();

class HasMapEncoder extends Converter<HasMap, Map> {
  const HasMapEncoder();

  @override
  Map convert(HasMap model) => HasMapSerializer.toMap(model);
}

class HasMapDecoder extends Converter<Map, HasMap> {
  const HasMapDecoder();

  @override
  HasMap convert(Map map) => HasMapSerializer.fromMap(map);
}

class HasMapSerializer extends Codec<HasMap, Map> {
  const HasMapSerializer();

  @override
  HasMapEncoder get encoder => const HasMapEncoder();
  @override
  HasMapDecoder get decoder => const HasMapDecoder();
  static HasMap fromMap(Map map) {
    return HasMap(
        value: map['value'] is Map
            ? (map['value'] as Map).cast<dynamic, dynamic>()
            : {},
        list: map['list'] is Iterable
            ? (map['list'] as Iterable).cast<dynamic>().toList()
            : []);
  }

  static Map<String, dynamic> toMap(_HasMap model) {
    return {'value': model.value, 'list': model.list};
  }
}

abstract class HasMapFields {
  static const List<String> allFields = <String>[value, list];

  static const String value = 'value';

  static const String list = 'list';
}
