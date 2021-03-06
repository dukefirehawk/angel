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

    // TODO: Missing afterAll method
    //  app.findService('authors').afterAll(
    //      relations.hasOne('books', as: 'book', foreignKey: 'authorId'));
  });

  test('index', () async {
    var authors = await app.findService('authors')!.index();
    print(authors);

    expect(authors, allOf(isList, isNotEmpty));

    for (var author in authors.whereType<Map>()) {
      expect(author.keys, contains('book'));

      var book = author['book'] as Map;
      print('Author: $author');
      print('Book: $book');
      expect(book['authorId'], equals(author['id']));
    }
  });

  test('create', () async {
    var tolstoy = await app
        .findService('authors')!
        .create(Author(name: 'Leo Tolstoy').toJson());

    print(tolstoy);
    expect(tolstoy.keys, contains('book'));
    expect(tolstoy['book'], isNull);
  });
}
