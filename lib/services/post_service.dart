import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostsData>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => PostsData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(PostsData post) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
  }

  Future<void> updatePost(int id, PostsData post) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
  }

  Future<void> deletePost(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
