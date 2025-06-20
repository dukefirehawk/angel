// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fortune.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class FortuneMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('fortune', (table) {
      table.integer('id').primaryKey();
      table.varChar('message', length: 2048);
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('fortune');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class FortuneQuery extends Query<Fortune, FortuneQueryWhere> {
  FortuneQuery({
    super.parent,
    Set<String>? trampoline,
  }) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = FortuneQueryWhere(this);
  }

  @override
  final FortuneQueryValues values = FortuneQueryValues();

  List<String> _selectedFields = [];

  FortuneQueryWhere? _where;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'fortune';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'message',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  FortuneQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  FortuneQueryWhere? get where {
    return _where;
  }

  @override
  FortuneQueryWhere newWhereClause() {
    return FortuneQueryWhere(this);
  }

  Optional<Fortune> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Fortune(
      id: fields.contains('id') ? mapToInt(row[0]) : null,
      message: fields.contains('message') ? (row[1] as String?) : null,
    );
    return Optional.of(model);
  }

  @override
  Optional<Fortune> deserialize(List row) {
    return parseRow(row);
  }
}

class FortuneQueryWhere extends QueryWhere {
  FortuneQueryWhere(FortuneQuery query)
      : id = NumericSqlExpressionBuilder<int>(
          query,
          'id',
        ),
        message = StringSqlExpressionBuilder(
          query,
          'message',
        );

  final NumericSqlExpressionBuilder<int> id;

  final StringSqlExpressionBuilder message;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      message,
    ];
  }
}

class FortuneQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
  }

  int? get id {
    return (values['id'] as int?);
  }

  set id(int? value) => values['id'] = value;

  String? get message {
    return (values['message'] as String?);
  }

  set message(String? value) => values['message'] = value;

  void copyFrom(Fortune model) {
    id = model.id;
    message = model.message;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Fortune extends FortuneEntity {
  Fortune({
    this.id,
    this.message,
  });

  @override
  int? id;

  @override
  String? message;

  Fortune copyWith({
    int? id,
    String? message,
  }) {
    return Fortune(id: id ?? this.id, message: message ?? this.message);
  }

  @override
  bool operator ==(other) {
    return other is FortuneEntity && other.id == id && other.message == message;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      message,
    ]);
  }

  @override
  String toString() {
    return 'Fortune(id=$id, message=$message)';
  }

  Map<String, dynamic> toJson() {
    return FortuneSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const FortuneSerializer fortuneSerializer = FortuneSerializer();

class FortuneEncoder extends Converter<Fortune, Map> {
  const FortuneEncoder();

  @override
  Map convert(Fortune model) => FortuneSerializer.toMap(model);
}

class FortuneDecoder extends Converter<Map, Fortune> {
  const FortuneDecoder();

  @override
  Fortune convert(Map map) => FortuneSerializer.fromMap(map);
}

class FortuneSerializer extends Codec<Fortune, Map> {
  const FortuneSerializer();

  @override
  FortuneEncoder get encoder => const FortuneEncoder();

  @override
  FortuneDecoder get decoder => const FortuneDecoder();

  static Fortune fromMap(Map map) {
    return Fortune(id: map['id'] as int?, message: map['message'] as String?);
  }

  static Map<String, dynamic> toMap(FortuneEntity? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {'id': model.id, 'message': model.message};
  }
}

abstract class FortuneFields {
  static const List<String> allFields = <String>[
    id,
    message,
  ];

  static const String id = 'id';

  static const String message = 'message';
}
