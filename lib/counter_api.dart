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
     // final parsedId = int.tryParse(id);
      value ++;
      final counter = value;
    //  data.firstWhere((counter) => counter['id'] == parsedId, orElse: () => null);

      if (counter != null) {
        return Response.ok(counter.toString());
      }

      return Response.notFound('Counter not found.');
    });
    router.get('/dec', (Request request) {
      // final parsedId = int.tryParse(id);
      value --;
      final counter = value;
      //  data.firstWhere((counter) => counter['id'] == parsedId, orElse: () => null);

      if (counter != null) {
        return Response.ok(counter.toString());
      }

      return Response.notFound('Counter not found.');
    });

    router.get('/reset', (Request request) {
      // final parsedId = int.tryParse(id);
      value =0;
      final counter = value;
      //  data.firstWhere((counter) => counter['id'] == parsedId, orElse: () => null);

      if (counter != null) {
        return Response.ok(counter.toString());
      }

      return Response.notFound('Counter not found.');
    });
    router.post('/', (Request request) async {

      return Response.ok(value.toString(),
          headers: {'Content-Type': 'application/json'});
    });

    return router; //--------//
  }
}
