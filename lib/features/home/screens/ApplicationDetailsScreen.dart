import 'package:flutter/material.dart';
import 'package:hobe/features/home/models/MyApplicationsPaginatedModel.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  final MyApplicationItemModel application;

  const ApplicationDetailsScreen({Key? key, required this.application})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = application.jobPost;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كرت الوظيفة الأساسي
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job?.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    job?.company?.companyName ?? '',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildBadge(
                        Icons.attach_money,
                        '${job?.salaryMin} - ${job?.salaryMax} ${job?.currency}',
                      ),
                      _buildBadge(
                        Icons.business_center_outlined,
                        job?.type ?? '',
                      ),
                      if (job?.isRemote == true)
                        _buildBadge(Icons.wifi, 'عمل عن بُعد'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // الرسالة التعريفية (Cover Letter)
            if (application.coverLetter != null &&
                application.coverLetter!.isNotEmpty)
              _buildSectionCard(
                title: 'خطاب التغطية (Cover Letter)',
                child: Text(
                  application.coverLetter!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // المهارات المطلوبة في الوظيفة
            if (job != null && job.skills.isNotEmpty)
              _buildSectionCard(
                title: 'المهارات المطلوبة',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: Colors.blue.withOpacity(0.08),
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 16),

            // السيرة الذاتية المرفقة
            _buildSectionCard(
              title: 'الملف المرفق',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 32,
                ),
                title: const Text(
                  'السيرة الذاتية (CV)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  application.cvFile?.split('/').last ?? 'ملف PDF',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // فتح أو تحميل السيرة الذاتية
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
