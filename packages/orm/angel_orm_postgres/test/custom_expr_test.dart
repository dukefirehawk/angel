import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'common.dart';
import 'models/custom_expr.dart';

void main() {
  late Connection conn;
  late QueryExecutor executor;
  late MigrationRunner runner;
  late Numbers numbersModel;

  setUp(() async {
    Logger.root.level = Level.INFO; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.loggerName}: ${record.time}: ${record.message}');
    });

    conn = await openPgConnection();
    executor = await createExecutor(conn);
    runner =
        await createTables(conn, [NumbersMigration(), AlphabetMigration()]);

    var now = DateTime.now();
    var nQuery = NumbersQuery();
    nQuery.values
      ..createdAt = now
      ..updatedAt = now;
    var numbersModelOpt = await nQuery.insert(executor);
    numbersModelOpt.ifPresent((v) {
      numbersModel = v;
    });
  });

  tearDown(() async {
    await dropTables(runner);
    if (conn.isOpen) {
      await conn.close();
    }
  });

  test('fetches correct result', () async {
    expect(numbersModel.two, 2);
  });

  test('in relation', () async {
    var abcQuery = AlphabetQuery();
    abcQuery.values
      ..value = 'abc'
      ..numbersId = numbersModel.idAsInt
      ..createdAt = numbersModel.createdAt
      ..updatedAt = numbersModel.updatedAt;
    var abcOpt = await (abcQuery.insert(executor));
    expect(abcOpt.isPresent, true);
    abcOpt.ifPresent((abc) {
      expect(abc.numbers, numbersModel);
      expect(abc.numbers?.two, 2);
      expect(abc.value, 'abc');
    });
  });
}
