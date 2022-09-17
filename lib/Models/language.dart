import 'dart:collection';

class Language {
  String? language;
  String? name;
  Language.fromJson(jsonBody)
      : language = jsonBody['language'],
        name = jsonBody['name'];
}
