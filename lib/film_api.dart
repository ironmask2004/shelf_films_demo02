import 'dart:io';
import 'dart:convert';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class FilmApi {
  final List data = json.decode(File('films.json').readAsStringSync());

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
      return Response.notFound('Film not found.');
    });

    router.post('/', (Request request) async {
      final payload = await request.readAsString();
      data.add(json.decode(payload));
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
      final int parsedId= await jsonDecode(payload)['id'];
      print( 'Going to delete ID:'+ parsedId.toString());
      data.removeWhere((film) => film['id'] == parsedId);
     // data.add(json.decode(payload));
      return Response.ok(payload +'Deleted',
          headers: {'Content-Type': 'application/json'});
    });


    return router; //--------//
  }
}
