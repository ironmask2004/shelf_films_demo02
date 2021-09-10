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

    router.get('/set/<number|[0-9]+>', (Request request, String number) {
      final parsedvalue = int.tryParse(number);

      if (parsedvalue != null) {
        value= parsedvalue;
        return Response.ok(json.encode(value),
            headers: {'Content-Type': 'application/json'});
      }

      return Response.notFound('Film not found.');
    });

    router.get('/json', (Request request) async {
      return Response.ok(json.encode("counter:"+value.toString()),
          headers: {'Content-Type': 'application/json'});
    });
    return router;
  }
}
