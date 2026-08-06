import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/home/controllers/AddProjectController.dart';

class AddProjectScreen extends StatelessWidget {
  final AddProjectController controller = Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true, // لمد الخلفية المموجة خلف شريط التطبيق
      appBar: AppBar(
        title: Text(
          controller.isEditing ? "تعديل فكرة المشروع" : "إضافة فكرة مشروع",
          style: TextStyle(
            color: isDarkMode ? AppColors.textDarkPrimary : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.textDarkPrimary : Colors.white,
        ),
      ),
      body: Stack(
        children: [
          // 1. الخلفية المموجة الاحترافية في الأعلى
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: CustomPaint(
              painter: WavyHeaderPainter(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [AppColors.darkCard, AppColors.Selection]
                      : [AppColors.primaryStart, AppColors.primaryEnd],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkCard
                          : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "معلومات المشروع الأساسية",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryEnd,
                          ),
                        ),
                        SizedBox(height: 20),

                        // عنوان المشروع
                        _buildTextField(
                          controller: controller.titleController,
                          label: "عنوان المشروع",
                          icon: Icons.title,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),

                        // ملخص قصير
                        _buildTextField(
                          controller: controller.summaryController,
                          label: "ملخص قصير",
                          icon: Icons.short_text,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),

                        // الوصف الكامل
                        _buildTextField(
                          controller: controller.descController,
                          label: "الوصف الكامل",
                          icon: Icons.description,
                          maxLines: 4,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),

                        // التصنيف
                        Obx(
                          () => _buildDropdownField(
                            label: "التصنيف",
                            icon: Icons.category,
                            value:
                                [
                                  'tech',
                                  'environment',
                                  'services',
                                ].contains(controller.selectedCategory.value)
                                ? controller.selectedCategory.value
                                : 'tech',
                            items: ['tech', 'environment', 'services'],
                            itemLabels: {
                              'tech': 'تكنولوجيا',
                              'environment': 'بيئة',
                              'services': 'خدمات',
                            },
                            onChanged: (val) =>
                                controller.selectedCategory.value = val
                                    .toString(),
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 16),

                        // المرحلة
                        Obx(
                          () => _buildDropdownField(
                            label: "المرحلة",
                            icon: Icons.trending_up,
                            value:
                                [
                                  'idea',
                                  'development',
                                  'launch',
                                ].contains(controller.selectedStage.value)
                                ? controller.selectedStage.value
                                : 'idea',
                            items: ['idea', 'development', 'launch'],
                            itemLabels: {
                              'idea': 'فكرة',
                              'development': 'تطوير',
                              'launch': 'إطلاق',
                            },
                            onChanged: (val) =>
                                controller.selectedStage.value = val.toString(),
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 16),

                        // هدف التمويل
                        _buildTextField(
                          controller: controller.fundingGoalController,
                          label: "هدف التمويل (أرقام فقط)",
                          icon: Icons.monetization_on,
                          keyboardType: TextInputType.number,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),

                        // الموقع
                        _buildTextField(
                          controller: controller.locationController,
                          label: "الموقع",
                          icon: Icons.location_on,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),

                        // رابط الموقع الإلكتروني
                        _buildTextField(
                          controller: controller.websiteUrlController,
                          label: "رابط الموقع الإلكتروني",
                          icon: Icons.link,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 20),

                        // النوع المطلوب (Checkboxes)
                        Text(
                          "النوع المطلوب:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => CheckboxListTile(
                                  title: Text(
                                    "تمويل",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : AppColors.textLightPrimary,
                                    ),
                                  ),
                                  value: controller.isFunding.value,
                                  onChanged: (v) =>
                                      controller.isFunding.value = v!,
                                  activeColor: AppColors.primaryEnd,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => CheckboxListTile(
                                  title: Text(
                                    "إرشاد",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : AppColors.textLightPrimary,
                                    ),
                                  ),
                                  value: controller.isMentorship.value,
                                  onChanged: (v) =>
                                      controller.isMentorship.value = v!,
                                  activeColor: AppColors.primaryEnd,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // أزرار التحكم السفلي
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: AppColors.primaryEnd),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "إلغاء",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.primaryEnd,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submitProject,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryEnd,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: controller.isLoading.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    controller.isEditing
                                        ? "تعديل الفكرة"
                                        : "نشر الفكرة",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود مخصصة لتصميم حقول الإدخال بشكل احترافي
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: isDarkMode ? Colors.white : AppColors.textLightPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryEnd),
        filled: true,
        fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryEnd, width: 2),
        ),
      ),
    );
  }

  // ميثود مخصصة للقوائم المنسدلة Dropdowns
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Map<String, String> itemLabels,
    required Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
      style: TextStyle(
        color: isDarkMode ? Colors.white : AppColors.textLightPrimary,
      ),
      items: items.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(
            itemLabels[e] ?? e,
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textLightPrimary,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryEnd),
        filled: true,
        fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryEnd, width: 2),
        ),
      ),
    );
  }
}

// رسم الخلفية المموجة المتناسقة
class WavyHeaderPainter extends CustomPainter {
  final Gradient gradient;

  WavyHeaderPainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 40);

    var controlPoint = Offset(size.width * 0.25, size.height);
    var endPoint = Offset(size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    var controlPoint2 = Offset(size.width * 0.75, size.height - 60);
    var endPoint2 = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
