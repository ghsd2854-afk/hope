import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/chat_controller.dart';
import 'package:hobe/features/home/models/message_model.dart';


// ⚠️ لإرفاق ملفات، ضيفي الباكج بالـ pubspec.yaml:
// file_picker: ^8.0.0
// import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String companyName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.companyName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController controller;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ChatController(),
      tag: 'chat_${widget.conversationId}',
    );
    controller.openConversation(widget.conversationId);

    ever(controller.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    Get.delete<ChatController>(tag: 'chat_${widget.conversationId}');
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.companyName)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return const Center(child: Text('ابدأ المحادثة الآن'));
              }
              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _MessageBubble(message: msg);
                },
              );
            }),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  /*
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        controller.sendMessage(
                          textController.text,
                          attachmentPath: result.files.single.path,
                        );
                        textController.clear();
                      }
                    },
                  ),
                  */
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => IconButton(
                      icon: controller.isSending.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed: controller.isSending.value
                          ? null
                          : () {
                              final text = textController.text;
                              if (text.trim().isEmpty) return;
                              controller.sendMessage(text);
                              textController.clear();
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFF2DD4BF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.attachmentName != null)
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      message.attachmentName!,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            if (message.body.isNotEmpty)
              Text(
                message.body,
                style: TextStyle(
                  color: isMine ? Colors.white : Colors.black87,
                ),
              ),
          ],
        ),
      ),
    );
  }
}