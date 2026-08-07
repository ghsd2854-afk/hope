import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/ReactionModel.dart';

class ReactionListScreen extends StatefulWidget {
  final int postId;
  const ReactionListScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<ReactionListScreen> createState() => _ReactionListScreenState();
}

class _ReactionListScreenState extends State<ReactionListScreen> {
  final ReactionController controller = Get.find<ReactionController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStats(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: Get.height * 0.7,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("التفاعلات", style: theme.textTheme.titleLarge),
          ),
          Obx(() {
            if (controller.reactionStats.value == null) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final stats = controller.reactionStats.value!;
            final types = stats.reactions.keys.toList();

            return DefaultTabController(
              length: types.length + 1,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: AppColors.primaryEnd,
                      labelColor: AppColors.primaryEnd,
                      unselectedLabelColor: AppColors.textSecondary,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "الكل (${stats.total})"),
                        ...types.map(
                          (type) => Tab(
                            text: "$type (${stats.reactions[type]!.count})",
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildUserList(
                            stats.reactions.entries
                                .expand(
                                  (entry) => entry.value.users.map(
                                    (user) => ReactionModel(
                                      id: user.id,
                                      userId: user.userId,
                                      jobPostId: user.jobPostId,
                                      name: user.name,
                                      type: entry.key,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          ...types.map(
                            (type) => _buildUserList(
                              stats.reactions[type]!.users
                                  .map(
                                    (user) => ReactionModel(
                                      id: user.id,
                                      userId: user.userId,
                                      jobPostId: user.jobPostId,
                                      name: user.name,
                                      type: type,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUserList(List<ReactionModel> users) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryStart.withOpacity(0.2),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
              style: TextStyle(color: AppColors.primaryEnd),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Text(
            controller.getIconString(user.type),
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
