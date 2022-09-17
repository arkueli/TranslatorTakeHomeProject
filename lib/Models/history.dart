class History {
  String input;
  String output;
  String inputLanguage;
  String outputLanguage;
  int? id;
  History(
      {this.id,
      required this.input,
      required this.inputLanguage,
      required this.output,
      required this.outputLanguage});
  History.fromJson(jsonBody)
      : input = jsonBody['input'],
        id = jsonBody['id'],
        inputLanguage = jsonBody['inputLanguage'],
        output = jsonBody['output'],
        outputLanguage = jsonBody['outputLanguage'];

  Map<String, dynamic> get toJson => {
        "id": id,
        'input': input,
        'inputLanguage': inputLanguage,
        'output': output,
        'outputLanguage': outputLanguage
      };
}
