
import 'package:shelf_films_demo02/counter_api.dart';
import 'package:shelf_films_demo02/film_api.dart';
import 'package:shelf_films_demo02/utils.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;


void main(List<String> arguments) async {
  const secret = '25BBD370-975D-4D45-8F5A-B3FA92155CCA';

  final app = Router();

  app.mount('/films/', FilmApi().router);
  app.mount('/counter/', CounterApi().router);

  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : 'World!????!!!';
    return Response.ok('Hello $param!');
  });

  print('working server try:  ');
  //await io.serve(app, '192.168.0.3, 8083);
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addMiddleware(handleAuth(secret))
      .addHandler(app);
  print (" curl  localhost:8083/films/2");
  await io.serve(handler, 'localhost', 8083);
}
