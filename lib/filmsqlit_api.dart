import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

import 'film_class.dart';

//import 'film_class.dart';

class FilmSqlApi {
  final List data = json.decode(File('films.json').readAsStringSync());
  late final database ;
  FilmSqlApi() {
    print('------------');
    print('Films Sql Data');
    print(data.runtimeType);
    print(data.toString());
    print(data[0]);
    print(data[0].runtimeType);
    print(data[0]['title']);
    //print(data[1]['title']);
    print('------------');


    open_filmsDB();
    print('Using sqlite3 ${sqlite3.version}');
  }

  open_filmsDB(){

    open.overrideFor(OperatingSystem.linux, _openOnLinux);
    // After setting all the overrides, you can use moor!
    database = sqlite3.openInMemory();
    var stmt = database.prepare('CREATE TABLE film(id INTEGER PRIMARY KEY, title TEXT)' );
    stmt.execute();
    print('created table film');
    // Dispose a statement when you don't need it anymore to clean up resources.
    stmt.dispose();

    stmt = database.prepare('INSERT INTO film (id, title) VALUES (?,?)');
    stmt.execute([1, 'The Beatles1']);
    stmt.execute([2, 'The Beatles2']);
    stmt.execute([3, 'The Beatles3']);

    // Dispose a statement when you don't need it anymore to clean up resources.
    stmt.dispose();


//    final ResultSet resultSet = database.select('SELECT * FROM film WHERE name LIKE ?', ['The %']);
    final ResultSet resultSet =database.select('SELECT * FROM film ');
    resultSet.forEach((element) {
      print(element);
    });
    for (final Row row in resultSet) {
      print('last rec : Film [id: ${row['id']}, title: ${row['title']}]');
    }

  }

  DynamicLibrary _openOnLinux() {
    final scriptDir = File(Platform.script.toFilePath()).parent;
    print(scriptDir);
    final libraryNextToScript = File('${scriptDir.path}/libsqlite3.so');
    return DynamicLibrary.open(libraryNextToScript.path);
  }


  Router get router {
    final router = Router();
    router.get('/', (Request request) {
      return Response.ok(json.encode(data),
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/<id|[0-9]+>', (Request request, String id) {
      final parsedId = int.tryParse(id);
      final film =
          data.firstWhere((film) => film['id'] == parsedId, orElse: () => null);
      print(film);
      if (film != null) {
        return Response.ok(json.encode(film),
            headers: {'Content-Type': 'application/json'});
      }

      return Response.notFound('FilmSql not found.');
    });

    router.post('/', (Request request) async {
      final payload = await request.readAsString();
      data.add(json.decode(payload));
     var film0 = Film(
        id:await jsonDecode(payload)['id'] ,
         title: await jsonDecode(payload)['title']
      );
      // await insertFilm(film0);

      return Response.ok(payload,
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/delete/<id>', (Request request, String id) {
      final parsedId = int.tryParse(id);
      data.removeWhere((film) => film['id'] == parsedId);
      return Response.ok('Deleted.');
    });

    router.delete('/', (Request request) async {
      final payload = await request.readAsString();
      final int parsedId = await jsonDecode(payload)['id'];
      print('Going to delete ID:' + parsedId.toString());
      data.removeWhere((film) => film['id'] == parsedId);

      return Response.ok(payload + 'Deleted',
          headers: {'Content-Type': 'application/json'});
    });

    return router; //--------//
  }
}
