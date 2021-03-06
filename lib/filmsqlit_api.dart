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
// final List data = json.decode(File('films.json').readAsStringSync());
  late final database;
  FilmSqlApi() {
    print('------------');
    open_filmsDB();
    print('Using sqlite3 ${sqlite3.version}');

    // print(json.decode(File('films.json').readAsStringSync()));
  }

  open_filmsDB() {
    open.overrideFor(OperatingSystem.linux, _openSqlit3OnLinux);
    //database = sqlite3.openInMemory();
    database = sqlite3.open('films_databse.db');
    try {
      var stmt = database
          .prepare('CREATE TABLE film(id INTEGER PRIMARY KEY, title TEXT)');
      stmt.execute();
      print('created table film');

      stmt.dispose();
      stmt = database.prepare('INSERT INTO film (id, title) VALUES (?,?)');
      json
          .decode(File('films.json').readAsStringSync())
          .forEach((film) => stmt.execute([film['id'], film['title']]));

      stmt.dispose();
    } catch (error) {
      print(' Table Film Already exist ' + error.toString());
    }

    // final ResultSet resultSet = database.select('SELECT * FROM film WHERE name LIKE ?', ['The %']);
    /*  final ResultSet resultSet = database.select('SELECT * FROM film ');
    resultSet.forEach((element) {
      print(element);
    }); */

    //for (final Row row in resultSet) {
    //  print('Film [id: ${row['id']}, title: ${row['title']}]');
    // }
  }

  String findFilm(final int filmID) {
    final ResultSet resultSet =
        database.select('SELECT * FROM film WHERE id = ' + filmID.toString());
    if (resultSet.isNotEmpty) {
      final Film foundfilm =
          Film(id: resultSet.first['id'], title: resultSet.first['title']);
      return (foundfilm.toString());
    } else {
      return ("Not Found!!");
    }
  }

  //----
  String InsertFilm(int filmID, String filmTitle) {
    var stmt = database.prepare('INSERT INTO film (id, title) VALUES (?,?)');

    stmt.execute([filmID, filmTitle]);

    stmt.dispose();
    return ("---");
  }

  //---

  String DeleteFilm(final int filmID) {
    print('delete  FROM film WHERE id = ' + filmID.toString());
    var stmt =
        database.prepare('delete  FROM film WHERE id = ' + filmID.toString());
    var execute;
    execute = stmt.execute();
    stmt.dispose();
    print("value of excute  delete : ");
    print(execute);

    // if (execute) {
    return (filmID.toString());
    // } else {
    //   return ("Not Found!!");
    // }
  }

  DynamicLibrary _openSqlit3OnLinux() {
    final scriptDir = File(Platform.script.toFilePath()).parent;
    print(scriptDir);
    final libraryNextToScript = File('${scriptDir.path}/libsqlite3.so');
    return DynamicLibrary.open(libraryNextToScript.path);
  }

  Router get router {
    final router = Router();

    router.get('/', (Request request) {
      final ResultSet resultSet = database.select('SELECT * FROM film ');
      return Response.ok(json.encode(resultSet.toList()),
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/<id|[0-9]+>', (Request request, String id) {
      final parsedId = int.tryParse(id);
      // final film = data.firstWhere((film) => film['id'] == parsedId, orElse: () => null);
      final film = findFilm(parsedId!);
      print('------- find film:' + id + '---- ' + film);
      return Response.ok(film, headers: {'Content-Type': 'application/json'});
    });

    router.post('/', (Request request) async {
      final payload = await request.readAsString();
      // data.add(json.decode(payload));

      var result =
          InsertFilm(jsonDecode(payload)['id'], jsonDecode(payload)['title']);

      return Response.ok(payload,
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/delete/<id>', (Request request, String id) {
      final parsedId = int.tryParse(id);
      // data.removeWhere((film) => film['id'] == parsedId);
      String result = DeleteFilm(parsedId!);
      return Response.ok(parsedId.toString() + '  Deleted.');
    });

    router.delete('/', (Request request) async {
      final payload = await request.readAsString();
      final int parsedId = await jsonDecode(payload)['id'];
      print('Going to delete ID:' + parsedId.toString());
      //data.removeWhere((film) => film['id'] == parsedId);
      String result = DeleteFilm(parsedId);

      return Response.ok(payload + 'Deleted',
          headers: {'Content-Type': 'application/json'});
    });

    return router; //--------//
  }
}
