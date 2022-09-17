import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:translator/Models/const_values.dart';
import 'package:translator/Models/language.dart';

class TranslateService extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl =
      "https://translation.googleapis.com/language/translate/v2";
  Future<List<Language>> getListOfLanguagesSupported() async {
    try {
      Response response = await _dio
          .get("$_baseUrl/languages?key=$googleTranslateApiKey&target=en");
      List<dynamic> listOflang = response.data['data']['languages'];

      List<Language> toModelList = [
        Language.fromJson({"language": "auto", "name": "Auto Detect"})
      ];
      listOflang
          .map((each) => toModelList.add(Language.fromJson(each)))
          .toList();

      return toModelList;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future detectLangauge(String body) async {
    try {
      Response response =
          await _dio.get("$_baseUrl/detect?key=$googleTranslateApiKey&q=$body");
      print(response);
      return response.data['data']['detections'][0][0]['language'];
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<String> translateText(
      String body, String target, String? source) async {
    print(target);
    print(source);
    if (source == 'auto') {
      var languagesDetected = await detectLangauge(body);
      print(languagesDetected);
      source = languagesDetected;
    }
    print(source);

    try {
      Response response = await _dio.get(
          "$_baseUrl?target=$target&key=$googleTranslateApiKey&q=$body&source=$source");
      return response.data['data']['translations'][0]['translatedText'];
    } on DioError catch (e) {
      print(e.response);
      throw e.message;
    }
  }
}
