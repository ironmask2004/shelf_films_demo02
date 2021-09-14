import 'dart:io';
import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:async';

//import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';

//import 'film_class.dart';

class FilmSqlApi {
  final List data = json.decode(File('films.json').readAsStringSync());
 // late final database ;
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
   // open_filmsDB();
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
     /* var film0 = Film(
        id:await jsonDecode(payload)['id'] ,
         title: await jsonDecode(payload)['title']
      );
      await insertFilm(film0);
      */
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
