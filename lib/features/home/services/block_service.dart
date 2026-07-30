import 'package:hobe/features/APIS/api_constants.dart';
import 'package:hobe/features/APIS/dio_services.dart';
import 'package:hobe/features/home/models/block_model.dart';

class BlockService {
  final _dio = DioService().dio;

  /// حظر مستخدم أو شركة
  /// blockableType: "user" أو "company"
  Future<void> blockEntity({
    required String blockableType,
    required int blockableId,
  }) async {
    final response = await _dio.post(
      ApiConstants.blocks, // ⚠️ ضيف: static const String blocks = "/blocks";
      data: {
        'blockable_type': blockableType,
        'blockable_id': blockableId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data['message'] ?? 'فشل تنفيذ الحظر');
    }
  }

  /// فحص هل الكيان محظور مسبقاً
  Future<bool> isBlocked({
    required String blockableType,
    required int blockableId,
  }) async {
    final response = await _dio.post(
      ApiConstants.checkBlock, // ⚠️ ضيف: static const String checkBlock = "/blocks/check";
      data: {
        'blockable_type': blockableType,
        'blockable_id': blockableId,
      },
    );

    if (response.statusCode == 200) {
      return response.data['is_blocked'] == true;
    }
    return false;
  }

  /// جلب قائمة المحظورين (باجينيشن)
  Future<List<BlockModel>> getBlockedList({int page = 1}) async {
    final response = await _dio.get(
      ApiConstants.blocks,
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      return data.map((e) => BlockModel.fromJson(e)).toList();
    }
    throw Exception('فشل تحميل قائمة المحظورين');
  }

  /// إلغاء الحظر عبر id سجل الحظر (وليس id المستخدم/الشركة)
  Future<void> unblock(int blockId) async {
    final response = await _dio.delete('${ApiConstants.blocks}/$blockId');

    if (response.statusCode != 200) {
      throw Exception('فشل إلغاء الحظر');
    }
  }
}
