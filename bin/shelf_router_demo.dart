//import 'dart:io';
//import 'package:dart_ipify/dart_ipify.dart';

import 'package:shelf_films_demo02/film_api.dart';
import 'package:shelf_films_demo02/utils.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
//import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main(List<String> arguments) async {
  const secret = '25BBD370-975D-4D45-8F5A-B3FA92155CCA';

  final app = Router();

  app.mount('/films/', FilmApi().router); //ggggg

  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : 'World!????!!!';
    return Response.ok('Hello $param!');
  });

  print('working server try:  curl  kflino.ics.com:8083/films/3 ');
  //await io.serve(app, 'kflino.ics.com', 8083);
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addMiddleware(handleAuth(secret))
      .addHandler(app);

  await io.serve(handler, 'kflino.ics.com', 8083);
}
