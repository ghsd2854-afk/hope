/// نموذج الكيان المحظور (يوزر أو شركة) - الحقول اختيارية لأن الشكل
/// يختلف قليلاً بين اليوزر والشركة (name/email للمستخدم، وربما
/// name/logo للشركة). عدّل الحقول حسب استجابة الـ company فعلياً.
class BlockableModel {
  final int id;
  final String? name;
  final String? email;
  final String? role;
  final String? logo; // مثال: لو الشركة عندها حقل logo/image بدل email

  BlockableModel({
    required this.id,
    this.name,
    this.email,
    this.role,
    this.logo,
  });

  factory BlockableModel.fromJson(Map<String, dynamic> json) {
    return BlockableModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      logo: json['logo'] ?? json['image'] ?? json['photo'],
    );
  }
}

class BlockModel {
  final int id;
  final int blockerId;
  final String blockableType; // "App\\Models\\User" أو "App\\Models\\Company"
  final int blockableId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BlockableModel? blockable;

  BlockModel({
    required this.id,
    required this.blockerId,
    required this.blockableType,
    required this.blockableId,
    required this.createdAt,
    required this.updatedAt,
    this.blockable,
  });

  /// true لو الكيان المحظور هو "شركة" وليس مستخدم عادي
  bool get isCompany => blockableType.toLowerCase().contains('company');

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'],
      blockerId: json['blocker_id'],
      blockableType: json['blockable_type'] ?? '',
      blockableId: json['blockable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      blockable: json['blockable'] != null
          ? BlockableModel.fromJson(json['blockable'])
          : null,
    );
  }
}
