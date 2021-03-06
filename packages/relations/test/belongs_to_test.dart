import 'package:angel_framework/angel_framework.dart';
import 'package:angel_seeder/angel_seeder.dart';
import 'package:test/test.dart';
import 'common.dart';

void main() {
  late Angel app;

  setUp(() async {
    app = Angel()..use('/authors', MapService())..use('/books', MapService());

    await app.configure(seed(
        'authors',
        SeederConfiguration<Map>(
            count: 10,
            template: {'name': (Faker faker) => faker.person.name()},
            callback: (Map author, seed) {
              return seed(
                  'books',
                  SeederConfiguration(delete: false, count: 10, template: {
                    'authorId': author['id'],
                    'title': (Faker faker) =>
                        'I love to eat ${faker.food.dish()}'
                  }));
            })));

    // TODO: Missing method afterAll
    //app.findService ('books').afterAll(relations.belongsTo('authors'));
  });

  test('index', () async {
    var books = await app.findService('books')!.index();
    print(books);

    expect(books, allOf(isList, isNotEmpty));

    for (var book in books.whereType<Map>()) {
      expect(book.keys, contains('author'));

      var author = book['author'] as Map;
      expect(author['id'], equals(book['authorId']));
    }
  });

  test('create', () async {
    var warAndPeace = await app
        .findService('books')!
        .create(Book(title: 'War and Peace').toJson());

    print(warAndPeace);
    expect(warAndPeace.keys, contains('author'));
    expect(warAndPeace['author'], isNull);
  });
}
