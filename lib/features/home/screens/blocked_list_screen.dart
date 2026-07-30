import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/home/controllers/block_controller.dart';
import 'package:hobe/features/home/models/block_model.dart';

class BlockedListScreen extends StatelessWidget {
  const BlockedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // لو الكونترولر مو مسجّل بعد (lazy) استخدم Get.put، أو سجّله بالـ Binding
    final controller = Get.isRegistered<BlockController>()
        ? Get.find<BlockController>()
        : Get.put(BlockController());

    return Scaffold(
      appBar: AppBar(title: const Text('المستخدمون والشركات المحظورة')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.blockedList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'لا يوجد أي مستخدم أو شركة محظورة حالياً',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchBlockedList,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.blockedList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final BlockModel item = controller.blockedList[index];
              final blockable = item.blockable;

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      child: Icon(
                        item.isCompany ? Icons.apartment : Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blockable?.name ?? 'غير معروف',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.isCompany ? 'شركة' : 'مستخدم',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _confirmUnblock(context, controller, item),
                      child: const Text('إلغاء الحظر'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmUnblock(
    BuildContext context,
    BlockController controller,
    BlockModel item,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء الحظر'),
        content: Text(
          'هل تريد إلغاء حظر ${item.blockable?.name ?? "هذا الحساب"}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تراجع'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.unblock(item);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
