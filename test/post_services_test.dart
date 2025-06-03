import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:postscrud/models/post.dart';
import 'package:postscrud/services/post_service.dart';

void main() {
  final postService = PostService();

  group('PostService CRUD Operations', () {
    test('Fetch posts returns a list of PostsData', () async {
      final posts = await postService.fetchPosts();
      expect(posts, isA<List<PostsData>>());
      expect(posts.isNotEmpty, true);
    });

    test('Create post returns 201 status code', () async {
      final response = await postService.createPost('Test Title', 'Test Body');
      expect(response.statusCode, 201);
    });

    test('Update post returns 200 status code', () async {
      final response = await postService.updatePost(1, 'Updated Title', 'Updated Body');
      expect(response.statusCode, 200);
    });

    test('Delete post returns 200 status code', () async {
      final response = await postService.deletePost(1);
      expect(response.statusCode, 200);
    });
  });
}
