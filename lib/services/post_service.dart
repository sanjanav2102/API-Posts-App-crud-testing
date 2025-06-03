// lib/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostsData>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PostsData.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<http.Response> createPost(String title, String body) {
    return http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'body': body}),
    );
  }

  Future<http.Response> updatePost(int id, String title, String body) {
    return http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'body': body}),
    );
  }

  Future<http.Response> deletePost(int id) {
    return http.delete(Uri.parse('$baseUrl/$id'));
  }
}
