library news_api_flutter_package;

import 'dart:convert';

import 'package:flutter_news_app/models/response.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = "newsapi.org";

class NewsAPI {
  final String apiKey;

  NewsAPI(this.apiKey);

  Future<ResponseModel> _call(
      String endpoint, Map<String, dynamic> queryParameters) async {
    try {
      final uri = Uri.https(BASE_URL, '/v2/$endpoint', queryParameters);
      http.Response resp = await http.get(uri).timeout(Duration(seconds: 10));
      ResponseModel respModel = ResponseModel.fromJson(json.decode(resp.body));
      return respModel;
    } catch (e) {
      return ResponseModel(
        "error",
        null,
        null,
        "networkError",
        "Network error, please check your internet connection",
      );
    }
  }

  Future<ResponseModel> getArticles({
    required String sortBy,
    required String query,
    String? category,
    String domains = "techcrunch.com, engadget.com",
    String country = "us",
    String language = "en",
    required int pageSize,
    required int page,
  }) async {
    String endpoint = category == null ? "/everything" : "/top-headlines";

    Map<String, dynamic> queryParameters = {
      'pageSize': pageSize.toString(),
      'page': page.toString(),
      'apiKey': apiKey,
      ...category == null
          ? {
              'sortBy': sortBy,
              'domains': domains,
              'language': language,
            }
          : {
              'category': category,
              'country': country,
            },
      ...query.isNotEmpty ? {'q': query} : {},
    };

    return _call(
      endpoint,
      queryParameters,
    );
  }
}
