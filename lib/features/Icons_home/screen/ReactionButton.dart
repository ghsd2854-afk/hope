/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class ReactionButton extends StatelessWidget {
  final JobPostModel job;
  final ReactionController reactionController = Get.find<ReactionController>();

  ReactionButton({Key? key, required this.job}) : super(key: key);

  Map<String, dynamic> _getReactionSettings(String? type) {
    switch (type?.toLowerCase()) {
      case 'love':
        return {'text': 'أحببته', 'color': Colors.red, 'icon': '❤️'};
      case 'support':
        return {'text': 'دعم', 'color': Colors.blue, 'icon': '🤝'};
      case 'insightful':
        return {'text': 'ملهم', 'color': Colors.amber, 'icon': '💡'};
      case 'like':
        return {'text': 'أعجبني', 'color': AppColors.primaryEnd, 'icon': '👍'};
      default:
        return {'text': 'إعجاب', 'color': AppColors.textSecondary, 'icon': ''};
    }
  }

  void _showHorizontalReactionMenu(BuildContext context, Offset offset) {
    final List<String> reactionTypes = [
      'like',
      'love',
      'support',
      'insightful',
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 60,
        offset.dx + 100,
        offset.dy,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      items: [
        PopupMenuItem<void>(
          enabled: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: reactionTypes.map((type) {
              final settings = _getReactionSettings(type);
              return _AnimatedReactionItem(
                emoji: settings['icon'],
                onTap: () async {
                  Navigator.pop(context);
                  // تحديث الموديل مباشرة
                  job.isReacted.value = true;
                  job.reactionType.value = type;
                  await reactionController.addReaction(job.id, type, job);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) =>
          _showHorizontalReactionMenu(context, details.globalPosition),
      onTap: () async {
        bool isReacted = reactionController.userReactionStatus[job.id] ?? false;
        if (isReacted) {
          await reactionController.deleteReaction(job.id, job);
        } else {
          await reactionController.addReaction(job.id, 'like', job);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(() {
          // مراقبة الحالة من الـ Controller
          bool isReacted =
              reactionController.userReactionStatus[job.id] ?? false;
          print("🔘 الزر للمنشور ${job.id} يرى الحالة الآن: $isReacted");
          String? type = reactionController.userReactionTypes[job.id];

          final settings = _getReactionSettings(type);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isReacted
                  ? Text(settings['icon'], style: const TextStyle(fontSize: 18))
                  : Icon(
                      Icons.thumb_up_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
              const SizedBox(width: 8),
              Text(
                settings['text'],
                style: TextStyle(
                  color: isReacted
                      ? settings['color']
                      : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// كلاس _AnimatedReactionItem يبقى كما هو بدون تغيير

class _AnimatedReactionItem extends StatefulWidget {
  final String emoji;
  final VoidCallback onTap;

  const _AnimatedReactionItem({required this.emoji, required this.onTap});

  @override
  State<_AnimatedReactionItem> createState() => _AnimatedReactionItemState();
}

class _AnimatedReactionItemState extends State<_AnimatedReactionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/core/theme/colors.dart';
import 'package:hobe/features/Icons_home/controller/ReactionController.dart';
import 'package:hobe/features/Icons_home/models/JobPostModel.dart';

class ReactionButton extends StatelessWidget {
  final JobPostModel job;
  final ReactionController reactionController = Get.find<ReactionController>();

  ReactionButton({Key? key, required this.job}) : super(key: key);

  Map<String, dynamic> _getReactionSettings(String? type) {
    switch (type?.toLowerCase()) {
      case 'love':
        return {'text': 'أحببته', 'color': Colors.red, 'icon': '❤️'};
      case 'support':
        return {'text': 'دعم', 'color': Colors.blue, 'icon': '🤝'};
      case 'insightful':
        return {'text': 'ملهم', 'color': Colors.amber, 'icon': '💡'};
      case 'like':
        return {'text': 'أعجبني', 'color': AppColors.primaryEnd, 'icon': '👍'};
      default:
        return {'text': 'إعجاب', 'color': AppColors.textSecondary, 'icon': ''};
    }
  }

  void _showHorizontalReactionMenu(BuildContext context, Offset offset) {
    final List<String> reactionTypes = [
      'like',
      'love',
      'support',
      'insightful',
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 60,
        offset.dx + 100,
        offset.dy,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      items: [
        PopupMenuItem<void>(
          enabled: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: reactionTypes.map((type) {
              final settings = _getReactionSettings(type);
              return _AnimatedReactionItem(
                emoji: settings['icon'],
                onTap: () async {
                  Navigator.pop(context);
                  // تحديث الموديل مباشرة واستدعاء التابع
                  await reactionController.addReaction(job, type);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) =>
          _showHorizontalReactionMenu(context, details.globalPosition),
      onTap: () async {
        // الاعتماد على الحالة داخل الموديل مباشرة
        if (job.isReacted.value) {
          await reactionController.deleteReaction(job.id, job);
        } else {
          await reactionController.addReaction(job, 'like');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(() {
          // الآن الـ Obx يراقب التغيرات في الموديل نفسه
          bool isReacted = job.isReacted.value;
          String? type = job.reactionType.value;

          final settings = _getReactionSettings(type);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isReacted
                  ? Text(settings['icon'], style: const TextStyle(fontSize: 18))
                  : Icon(
                      Icons.thumb_up_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
              const SizedBox(width: 8),
              Text(
                settings['text'],
                style: TextStyle(
                  color: isReacted
                      ? settings['color']
                      : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// تأكد من وجود هذا الكلاس في نفس الملف تحت الـ ReactionButton
class _AnimatedReactionItem extends StatefulWidget {
  final String emoji;
  final VoidCallback onTap;

  const _AnimatedReactionItem({required this.emoji, required this.onTap});

  @override
  State<_AnimatedReactionItem> createState() => _AnimatedReactionItemState();
}

class _AnimatedReactionItemState extends State<_AnimatedReactionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}
