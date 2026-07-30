import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/conversations_controller.dart';

import 'package:hobe/features/home/screens/chat_screen.dart';

class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ConversationsController>()
        ? Get.find<ConversationsController>()
        : Get.put(ConversationsController());

    return Scaffold(
      appBar: AppBar(title: const Text('المحادثات')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.conversations.isEmpty) {
          return const Center(child: Text('لا توجد محادثات بعد'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchConversations,
          child: ListView.separated(
            itemCount: controller.conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final c = controller.conversations[index];
              final hasUnread = c.applicantUnreadCount > 0;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    (c.companyUserName != null && c.companyUserName!.isNotEmpty)
                        ? c.companyUserName![0]
                        : '?',
                  ),
                ),
                title: Text(c.companyUserName ?? 'شركة'),
                subtitle: Text(
                  c.jobTitle != null
                      ? '${c.jobTitle} • ${c.lastMessage ?? "لا رسائل بعد"}'
                      : c.lastMessage ?? 'لا رسائل بعد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: hasUnread
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${c.applicantUnreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  Get.to(() => ChatScreen(
                        conversationId: c.id,
                        companyName: c.companyUserName ?? 'شركة',
                      ));
                },
              );
            },
          ),
        );
      }),
    );
  }
}