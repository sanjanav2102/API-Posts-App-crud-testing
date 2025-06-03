class PostsData {
  final int id;
  final String title;
  final String body;
  final int userId;

  PostsData({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory PostsData.fromJson(Map<String, dynamic> json) {
    return PostsData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
    };
  }
}
