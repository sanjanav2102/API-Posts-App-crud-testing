import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../services/post_service.dart';

class CrudUi extends StatefulWidget {
  const CrudUi({super.key});

  @override
  State<CrudUi> createState() => _CrudUiState();
}

class _CrudUiState extends State<CrudUi> {
  final PostService _service = PostService();
  List<Map<String, dynamic>> _data = []; // ✅ Local state for UI update

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final posts = await _service.fetchPosts();
    setState(() {
      _data = posts
          .map((post) => {
        'id': post.id,
        'title': post.title,
        'body': post.body,
      })
          .toList();
    });
  }

  void _showEditDialog(int index, int id) {
    TextEditingController titleController =
    TextEditingController(text: _data[index]['title']);
    TextEditingController bodyController =
    TextEditingController(text: _data[index]['body']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () async {
              Navigator.of(context).pop();
              await _updateData(index, id, titleController.text, bodyController.text);
            },
          )
        ],
      ),
    );
  }

  Future<void> _updateData(int index, int id, String title, String body) async {
    try {
      Map<String, String> data = {
        'title': title,
        'body': body,
      };
      final response = await http.put(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          _data[index]['title'] = title;
          _data[index]['body'] = body;
        });
      } else {
        throw Exception('Failed to update the data');
      }
    } catch (e) {
      print("error $e");
    }
  }


  Future<void> _deleteData(int index, int id) async {
    try {
      final response = await http.delete(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"),
      );
      if (response.statusCode == 200) {
        setState(() {
          _data.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete the data');
      }
    } catch (e) {
      print("error $e");
    }
  }

  void _showCreateDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Create"),
            onPressed: () async {
              Navigator.of(context).pop();
              await _createData(titleController.text, bodyController.text);
            },
          )
        ],
      ),
    );
  }
  Future<void> _createData(String title, String body) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'body': body,
      };
      final response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final newPost = jsonDecode(response.body);
        setState(() {
          _data.insert(0, newPost); // Add to top of the list
        });
      } else {
        throw Exception('Failed to create the data');
      }
    } catch (e) {
      print("error $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD operations")),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: _data.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final post = _data[index];
          return ListTile(
            title: Text(post['title']),
            subtitle: Text(post['body']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _showEditDialog(index, post['id']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _deleteData(index, post['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog, // ✅ fixed method name
        child: Icon(Icons.add),
      ),
    );
  }
}
