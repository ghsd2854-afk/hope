import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// أيقونة HOPE متحركة — قلب ذهبي + ورقة نبتة بنفسجية 
/// + شخصين (بنفسجي وذهبي) + نجمة ذهبية
///
/// طريقة الاستخدام:
/// const AnimatedHopeLogo(size: 200)
class AnimatedHopeLogo extends StatefulWidget {
  final double size;
  final Duration duration;
  final bool showText;

  const AnimatedHopeLogo({
    super.key,
    this.size = 200,
    this.duration = const Duration(milliseconds: 2500),
    this.showText = true,
  });

  @override
  State<AnimatedHopeLogo> createState() => _AnimatedHopeLogoState();
}

class _AnimatedHopeLogoState extends State<AnimatedHopeLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _heartStroke;
  late final Animation<double> _leafStroke;
  late final Animation<double> _peopleStroke;
  late final Animation<double> _starStroke;
  late final Animation<double> _fillAnim;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _heartStroke = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.40, curve: Curves.easeInOut),
    );

    _leafStroke = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.55, curve: Curves.easeInOut),
    );

    _peopleStroke = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.40, 0.75, curve: Curves.easeInOut),
    );

    _starStroke = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 0.88, curve: Curves.easeOut),
    );

    _fillAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.50, 1.00, curve: Curves.easeOut),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.00, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_textFade);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: Size(widget.size, widget.size * 1.1),
              painter: _HopeLogoPainter(
                heartProgress: _heartStroke.value,
                leafProgress: _leafStroke.value,
                peopleProgress: _peopleStroke.value,
                starProgress: _starStroke.value,
                fillProgress: _fillAnim.value,
              ),
            ),
            if (widget.showText) ...[
             SizedBox(height: widget.size * 0.00005),
              SlideTransition(
                
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textFade,
                  child: Text(
                    "Hope",
                    style: GoogleFonts.dancingScript(
                      fontSize: widget.size * 0.45,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 122, 49, 192),
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(255, 71, 12, 114).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HopeLogoPainter extends CustomPainter {
  final double heartProgress;
  final double leafProgress;
  final double peopleProgress;
  final double starProgress;
  final double fillProgress;

  _HopeLogoPainter({
    required this.heartProgress,
    required this.leafProgress,
    required this.peopleProgress,
    required this.starProgress,
    required this.fillProgress,
  });

  // ===== الألوان من الصورة =====
  static const _goldDark = Color(0xFF7B4406);
  static const _goldMid = Color(0xFFB57C27);
  static const _goldLight = Color(0xFFD5A14B);
  static const _goldBright = Color(0xFFFED14F);
  static const _purpleDark = Color(0xFF240151);
  static const _purpleMid = Color(0xFF4E1F83);
  static const _purpleLight = Color(0xFF7233A2);

  // ===== القلب الذهبي =====
  Path _heartPath(Size s) {
    final w = s.width;
    final h = s.height;
    final p = Path();

    // قلب مفتوح من الأعلى - شكل أنيق
    p.moveTo(w * 0.50, h * 0.28);
    p.cubicTo(w * 0.35, h * 0.06, w * 0.05, h * 0.16, w * 0.05, h * 0.44);
    p.cubicTo(w * 0.05, h * 0.66, w * 0.22, h * 0.80, w * 0.50, h * 0.96);
    p.cubicTo(w * 0.78, h * 0.80, w * 0.95, h * 0.66, w * 0.95, h * 0.44);
    p.cubicTo(w * 0.95, h * 0.16, w * 0.65, h * 0.06, w * 0.50, h * 0.28);
    p.close();
    return p;
  }

  // ===== ورقة النبتة البنفسجية =====
  Path _leafPath(Size s) {
    final w = s.width;
    final h = s.height;
    final p = Path();

    // الساق الرفيعة
    p.moveTo(w * 0.38, h * 0.82);
    p.cubicTo(w * 0.38, h * 0.65, w * 0.36, h * 0.52, w * 0.35, h * 0.40);

    // الورقة العلوية (كبيرة)
    p.moveTo(w * 0.35, h * 0.52);
    p.cubicTo(w * 0.22, h * 0.48, w * 0.18, h * 0.36, w * 0.24, h * 0.28);
    p.cubicTo(w * 0.32, h * 0.32, w * 0.36, h * 0.42, w * 0.35, h * 0.52);

    // الورقة الوسطى
    p.moveTo(w * 0.36, h * 0.42);
    p.cubicTo(w * 0.42, h * 0.34, w * 0.42, h * 0.22, w * 0.35, h * 0.16);
    p.cubicTo(w * 0.29, h * 0.24, w * 0.30, h * 0.36, w * 0.36, h * 0.42);

    // الورقة السفلى (صغيرة)
    p.moveTo(w * 0.37, h * 0.62);
    p.cubicTo(w * 0.30, h * 0.58, w * 0.28, h * 0.50, w * 0.32, h * 0.44);
    p.cubicTo(w * 0.38, h * 0.48, w * 0.40, h * 0.56, w * 0.37, h * 0.62);

    return p;
  }

  // ===== شخصين — بنفسجي (يسار) وذهبي (يمين) =====
  Path _peoplePath(Size s) {
    final w = s.width;
    final h = s.height;
    final p = Path();

    // --- الشخص البنفسجي (الأقصر، يسار الوسط) ---
    final h1 = Offset(w * 0.54, h * 0.40);
    const r1 = 0.032;
    p.addOval(Rect.fromCircle(center: h1, radius: w * r1));

    // الجسم - منحني
    p.moveTo(w * 0.54, h * (0.40 + r1));
    p.cubicTo(
      w * 0.52, h * 0.56,
      w * 0.52, h * 0.64,
      w * 0.54, h * 0.78,
    );
    // الذراع المرفوعة
    p.moveTo(w * 0.54, h * 0.52);
    p.cubicTo(
      w * 0.60, h * 0.48,
      w * 0.64, h * 0.42,
      w * 0.66, h * 0.34,
    );

    // --- الشخص الذهبي (الأطول، يمين الوسط) ---
    final h2 = Offset(w * 0.68, h * 0.32);
    const r2 = 0.035;
    p.addOval(Rect.fromCircle(center: h2, radius: w * r2));

    // الجسم - منحني أنيق
    p.moveTo(w * 0.68, h * (0.32 + r2));
    p.cubicTo(
      w * 0.66, h * 0.50,
      w * 0.66, h * 0.62,
      w * 0.68, h * 0.78,
    );
    // الذراع المرفوعة عالياً
    p.moveTo(w * 0.68, h * 0.44);
    p.cubicTo(
      w * 0.72, h * 0.34,
      w * 0.74, h * 0.26,
      w * 0.72, h * 0.18,
    );

    return p;
  }

  // ===== النجمة الذهبية أعلى القلب =====
  Path _starPath(Size s) {
    final cx = s.width * 0.70;
    final cy = s.height * 0.10;
    const spikes = 5;
    final outerR = s.width * 0.075;
    final innerR = s.width * 0.032;

    final p = Path();
    final step = (math.pi * 2) / (spikes * 2);
    double rot = -math.pi / 2.4;

    p.moveTo(cx + outerR * math.cos(rot), cy + outerR * math.sin(rot));

    for (int i = 0; i < spikes; i++) {
      rot += step;
      p.lineTo(cx + innerR * math.cos(rot), cy + innerR * math.sin(rot));
      rot += step;
      p.lineTo(cx + outerR * math.cos(rot), cy + outerR * math.sin(rot));
    }

    p.close();
    return p;
  }

  Path _extractProgress(Path source, double t) {
    if (t >= 1.0) return source;
    if (t <= 0.0) return Path();

    final metrics = source.computeMetrics().toList();
    final result = Path();

    for (final metric in metrics) {
      final len = metric.length * t;
      result.addPath(metric.extractPath(0, len), Offset.zero);
    }
    return result;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final heartFull = _heartPath(size);
    final leafFull = _leafPath(size);
    final peopleFull = _peoplePath(size);
    final starFull = _starPath(size);

    final heartDraw = _extractProgress(heartFull, heartProgress);
    final leafDraw = _extractProgress(leafFull, leafProgress);
    final peopleDraw = _extractProgress(peopleFull, peopleProgress);
    final starDraw = _extractProgress(starFull, starProgress);

    // ===== التعبئة التدريجية =====
    if (fillProgress > 0) {
      // تعبئة القلب بلون ذهبي شفاف
      final heartFill = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _goldLight.withOpacity(0.18 * fillProgress),
            _goldMid.withOpacity(0.28 * fillProgress),
          ],
        ).createShader(Offset.zero & size);
      canvas.drawPath(heartFull, heartFill);

      // تعبئة الورقة بنفسجي
      final leafFill = Paint()
        ..style = PaintingStyle.fill
        ..color = _purpleLight.withOpacity(0.30 * fillProgress);
      canvas.drawPath(leafFull, leafFill);

      // تعبئة النجمة بلون ذهبي مشرق
      final starFill = Paint()
        ..style = PaintingStyle.fill
        ..color = _goldBright.withOpacity(0.85 * fillProgress);
      canvas.drawPath(starFull, starFill);
    }

    // ===== خطوط الحدود =====
    // القلب - تدرج ذهبي
    final heartPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.032
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_purpleMid, _purpleDark, _purpleLight],
      ).createShader(Offset.zero & size);

    // الورقة - بنفسجي
    final leafPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.020
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _purpleMid;

    // الأشخاص - بنفسجي غامق وذهبي
    final peoplePurplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _purpleDark;

    final peopleGoldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _goldMid;

    // النجمة - ذهبي
    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _goldBright;

    canvas.drawPath(heartDraw, heartPaint);
    canvas.drawPath(leafDraw, leafPaint);
    
    // رسم الأشخاص بلونين مختلفين
    // نحتاج لفصل مسار الشخص البنفسجي عن الذهبي
    _drawPeople(canvas, size, peopleProgress);
    
    canvas.drawPath(starDraw, starPaint);
  }

  void _drawPeople(Canvas canvas, Size size, double progress) {
    final w = size.width;
    final h = size.height;

    // الشخص البنفسجي
    final purplePath = Path();
    final h1 = Offset(w * 0.54, h * 0.40);
    const r1 = 0.032;
    purplePath.addOval(Rect.fromCircle(center: h1, radius: w * r1));
    purplePath.moveTo(w * 0.54, h * (0.40 + r1));
    purplePath.cubicTo(w * 0.52, h * 0.56, w * 0.52, h * 0.64, w * 0.54, h * 0.78);
    purplePath.moveTo(w * 0.54, h * 0.52);
    purplePath.cubicTo(w * 0.60, h * 0.48, w * 0.64, h * 0.42, w * 0.66, h * 0.34);

    // الشخص الذهبي
    final goldPath = Path();
    final h2 = Offset(w * 0.68, h * 0.32);
    const r2 = 0.035;
    goldPath.addOval(Rect.fromCircle(center: h2, radius: w * r2));
    goldPath.moveTo(w * 0.68, h * (0.32 + r2));
    goldPath.cubicTo(w * 0.66, h * 0.50, w * 0.66, h * 0.62, w * 0.68, h * 0.78);
    goldPath.moveTo(w * 0.68, h * 0.44);
    goldPath.cubicTo(w * 0.72, h * 0.34, w * 0.74, h * 0.26, w * 0.72, h * 0.18);

    final purpleDraw = _extractProgress(purplePath, progress);
    final goldDraw = _extractProgress(goldPath, progress);

    final purplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _purpleDark;

    final goldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _goldMid;

    canvas.drawPath(purpleDraw, purplePaint);
    canvas.drawPath(goldDraw, goldPaint);
  }

  @override
  bool shouldRepaint(covariant _HopeLogoPainter oldDelegate) {
    return oldDelegate.heartProgress != heartProgress ||
        oldDelegate.leafProgress != leafProgress ||
        oldDelegate.peopleProgress != peopleProgress ||
        oldDelegate.starProgress != starProgress ||
        oldDelegate.fillProgress != fillProgress;
  }
}