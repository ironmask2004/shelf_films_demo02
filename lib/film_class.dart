import 'dart:ffi';

class Film {
  final int id;
  final String title;

  Film({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  @override
  String toString() {
    return "{\"id\":$id,\"title\":\"$title\"}";
  }
}


