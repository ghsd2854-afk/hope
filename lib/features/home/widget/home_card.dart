import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hobe/features/Icons_home/models/post_model.dart';

import 'package:hobe/features/Icons_home/screen/pst_det_screen.dart';

import '../controllers/home_controller.dart';

class HomeCard extends StatelessWidget {
  final PostModel post;

  const HomeCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: theme.cardColor,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// HEADER
          Container(
            height: 140,

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

              gradient: LinearGradient(
                colors: [Color(0xFF2DD4BF), Color(0xFF0891B2)],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TITLE
                Text(
                  post.title,

                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// DESC
                Text(
                  post.desc,

                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                /// ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    /// DETAILS
                    _icon(context, Icons.info_outline, () {
                      Get.to(() => PostDetailsScreen(post: post));
                    }),

                    /// SAVE
                    _icon(
                      context,

                      post.isSaved ? Icons.bookmark : Icons.bookmark_border,

                      () => controller.toggleSave(post),
                    ),

                    /// LIKE
                    _icon(
                      context,

                      post.isLiked ? Icons.favorite : Icons.favorite_border,

                      () => controller.toggleLike(post),

                      color: post.isLiked ? Colors.red : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(
    BuildContext context,

    IconData icon,

    VoidCallback onTap, {

    Color? color,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(50),

      child: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: theme.cardColor.withOpacity(0.7),
        ),

        child: Icon(icon, color: color ?? theme.iconTheme.color),
      ),
    );
  }
}
