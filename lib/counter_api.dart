import 'dart:io';
import 'dart:convert';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class CounterApi {
  int value = 0;

  Router get router {
    final router = Router();
    router.get('/', (Request request) {
      return Response.ok(value.toString(),
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/inc', (Request request) {
      value++;
      return Response.ok(value.toString(),
          headers: {'Content-Type': 'application/json'});
    });
    router.get('/dec', (Request request) {
      value--;

      return Response.ok(value.toString());
    });

    router.get('/reset', (Request request) {
      value = 0;
      return Response.ok(value.toString(),
          headers: {'Content-Type': 'application/json'});
    });
    router.post('/', (Request request) async {
      return Response.ok(value.toString(),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }
}
