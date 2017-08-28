// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: HttpWebappClientGenerator
// **************************************************************************

// Generated by owl 0.2.2
// https://github.com/agilord/owl

// ignore: unused_import, library_prefixes
import 'http_api_example.dart';
// ignore: unused_import, library_prefixes
import 'dart:async';
// ignore: unused_import, library_prefixes
import 'http_api_example.json.g.dart';
// ignore: unused_import, library_prefixes
import 'package:owl/util/http/webapp.dart' as _owl;
import 'dart:html' show HttpRequest;

/// API client interface of Content.
abstract class ContentClient {
  /// GET /api/content/v1/ping
  Future<String> ping();

  /// GET /api/content/v1/greet/{greeting}/{name}
  Future<String> greet(String greeting, String name);

  /// GET /api/content/v1/article/{id:int}
  Future<Article> getArticle(int id);

  /// POST /api/content/v1/article/{id:int}
  Future<Status> postArticle(int id, Article article);

  /// DELETE /api/content/v1/article/{id:int}
  Future<Status> deleteArticle(int id);
}

/// API client implementation of Content.
class ContentClientImpl implements ContentClient {
  /// Returns the request headers to set on the request.
  /// Signature: Map<String, String> headerCallback(String functionName)
  _owl.HeaderCallback headerCallback;

  /// GET /api/content/v1/ping
  @override
  Future<String> ping() async {
    final Map<String, String> _headers =
        headerCallback == null ? null : headerCallback('ping');
    final HttpRequest _r = await _owl.callHttpServer(
        'GET', // ignore: unnecessary_brace_in_string_interp
        '/api/content/v1/ping',
        headers: _headers);
    return _r.responseText;
  }

  /// GET /api/content/v1/greet/{greeting}/{name}
  @override
  Future<String> greet(String greeting, String name) async {
    final Map<String, String> _headers =
        headerCallback == null ? null : headerCallback('greet');
    final HttpRequest _r = await _owl.callHttpServer(
        'GET', // ignore: unnecessary_brace_in_string_interp
        '/api/content/v1/greet/${greeting}/${name}',
        headers: _headers);
    return _r.responseText;
  }

  /// GET /api/content/v1/article/{id:int}
  @override
  Future<Article> getArticle(int id) async {
    final Map<String, String> _headers =
        headerCallback == null ? null : headerCallback('getArticle');
    final HttpRequest _r = await _owl.callHttpServer(
        'GET', // ignore: unnecessary_brace_in_string_interp
        '/api/content/v1/article/${id}',
        headers: _headers);
    return ArticleMapper.fromJson(_r.responseText);
  }

  /// POST /api/content/v1/article/{id:int}
  @override
  Future<Status> postArticle(int id, Article article) async {
    final Map<String, String> _headers =
        headerCallback == null ? null : headerCallback('postArticle');
    final HttpRequest _r = await _owl.callHttpServer(
        'POST', // ignore: unnecessary_brace_in_string_interp
        '/api/content/v1/article/${id}',
        headers: _headers,
        body: ArticleMapper.toJson(article));
    return StatusMapper.fromJson(_r.responseText);
  }

  /// DELETE /api/content/v1/article/{id:int}
  @override
  Future<Status> deleteArticle(int id) async {
    final Map<String, String> _headers =
        headerCallback == null ? null : headerCallback('deleteArticle');
    final HttpRequest _r = await _owl.callHttpServer(
        'DELETE', // ignore: unnecessary_brace_in_string_interp
        '/api/content/v1/article/${id}',
        headers: _headers);
    return StatusMapper.fromJson(_r.responseText);
  }
}
