// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'droid.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Droid extends _Droid {
  Droid({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    required this.position,
    required this.age,
  });

  @override
  String? id;

  /// The time at which this item was created.
  @override
  DateTime? createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  String? name;

  @override
  String position;

  @override
  num age;

  Droid copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? position,
    num? age,
  }) {
    return Droid(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        position: position ?? this.position,
        age: age ?? this.age);
  }

  @override
  bool operator ==(other) {
    return other is _Droid &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.name == name &&
        other.position == position &&
        other.age == age;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      name,
      position,
      age,
    ]);
  }

  @override
  String toString() {
    return 'Droid(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, name=$name, position=$position, age=$age)';
  }

  Map<String, dynamic> toJson() {
    return DroidSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const DroidSerializer droidSerializer = DroidSerializer();

class DroidEncoder extends Converter<Droid, Map> {
  const DroidEncoder();

  @override
  Map convert(Droid model) => DroidSerializer.toMap(model);
}

class DroidDecoder extends Converter<Map, Droid> {
  const DroidDecoder();

  @override
  Droid convert(Map map) => DroidSerializer.fromMap(map);
}

class DroidSerializer extends Codec<Droid, Map> {
  const DroidSerializer();

  @override
  DroidEncoder get encoder => const DroidEncoder();

  @override
  DroidDecoder get decoder => const DroidDecoder();

  static Droid fromMap(Map map) {
    return Droid(
        id: map['id'] as String?,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        name: map['name'] as String?,
        position: map['position'] as String,
        age: map['age'] as num);
  }

  static Map<String, dynamic> toMap(_Droid? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'name': model.name,
      'position': model.position,
      'age': model.age
    };
  }
}

abstract class DroidFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    name,
    position,
    age,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String name = 'name';

  static const String position = 'position';

  static const String age = 'age';
}
