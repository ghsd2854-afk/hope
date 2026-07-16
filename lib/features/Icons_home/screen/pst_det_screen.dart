import 'package:flutter/material.dart';
import 'package:hobe/features/Icons_home/models/post_model.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(post.desc),

            const SizedBox(height: 20),

            const Text(
              "Full project details:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Here you can show full description, skills required, budget, timeline...",
            ),
          ],
        ),
      ),
    );
  }
}
