
import 'package:shelf_films_demo02/counter_api.dart';
import 'package:shelf_films_demo02/film_api.dart';
import 'package:shelf_films_demo02/filmsqlit_api.dart';
//import 'package:shelf_films_demo02/filmsqlit_api.dart';
import 'package:shelf_films_demo02/utils.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;


const String HostServer = 'localhost';
const int HostPort = 8083;

void main(List<String> arguments) async {
  const secret = '25BBD370-975D-4D45-8F5A-B3FA92155CCA';

  final app = Router();

  app.mount('/films/', FilmApi().router);
  app.mount('/filmsql/', FilmSqlApi().router);
  app.mount('/counter/', CounterApi().router);

  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : 'World!????!!!';
    return Response.ok('Hello $param!');
  });

  print('working server try:  ');
  //await io.serve(app, '192.168.0.3, 8083);curl  192.168.1.5:8083/films/2

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addMiddleware(handleAuth(secret))
      .addHandler(app);
  print ('  curl  ' + HostServer+':' + HostPort.toString() + '/films/3');
  print('curl -X POST localhost:8083/films/    -H \'Content-Type: application/json\'    -d \'{"id":1663,"title":"Running on Empty1663"}\'');
  print ('  curl  ' + HostServer+':' + HostPort.toString() + '/films/1663');
  print('curl -X DELETE localhost:8083/films/    -H \'Content-Type: application/json\'    -d \'{"id": 1663 }\'');
  await io.serve(handler, HostServer, HostPort);
}
