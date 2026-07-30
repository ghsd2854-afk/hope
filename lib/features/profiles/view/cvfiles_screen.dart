// lib/features/profiles/screen/cvfiles_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cvfiles_controller.dart';
import '../mpdel/cvfile_model.dart';

class CvFilesScreen extends StatelessWidget {
  CvFilesScreen({super.key});

  final CvFilesController controller = Get.put(CvFilesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة ملفاتك"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchFiles,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCCBFF), Color(0xFFF8F7FF)],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.files.isEmpty) {
            return _emptyState();
          }

          return RefreshIndicator(
            onRefresh: controller.fetchFiles,
            color: const Color(0xFF7C3AED),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.files.length,
              itemBuilder: (context, index) {
                final file = controller.files[index];
                return _fileCard(file);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C3AED).withOpacity(.08),
            ),
            child: const Icon(
              Icons.folder_open,
              size: 40,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "لا يوجد ملفات بعد",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            "ابدأي برفع ملف أو توليد CV جديد",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _fileCard(CvFileModel file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9D5FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Get.toNamed("/cv-file-details", arguments: file.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFF9333EA)],
                    ),
                  ),
                  child: Icon(
                    file.isPdf ? Icons.picture_as_pdf : Icons.description,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.originalName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (file.sizeReadable.isNotEmpty) ...[
                            Text(
                              file.sizeReadable,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: file.isConfirmed
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              file.isConfirmed ? "محفوظ" : "غير مؤكد",
                              style: TextStyle(
                                fontSize: 11,
                                color: file.isConfirmed
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: Color(0xFF7C3AED)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}