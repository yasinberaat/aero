import 'package:flutter/material.dart';

/// Custom painted icons for categories
class CustomIcons {
  /// Dollar sign icon for Finance
  static Widget dollar({Color? color, double size = 24}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DollarIconPainter(color: color ?? Colors.white),
    );
  }

  /// Folder icon for Work
  static Widget folder({Color? color, double size = 24}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FolderIconPainter(color: color ?? Colors.white),
    );
  }

  /// Dumbbell icon for Fitness
  static Widget dumbbell({Color? color, double size = 24}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DumbbellIconPainter(color: color ?? Colors.white),
    );
  }
}

/// Dollar sign painter
class _DollarIconPainter extends CustomPainter {
  final Color color;

  _DollarIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    // Vertical line
    canvas.drawLine(
      Offset(centerX, size.height * 0.1),
      Offset(centerX, size.height * 0.9),
      paint,
    );

    // S curve
    final path = Path();
    path.moveTo(size.width * 0.7, size.height * 0.3);
    path.cubicTo(
      size.width * 0.7, size.height * 0.2,
      size.width * 0.3, size.height * 0.2,
      size.width * 0.3, size.height * 0.35,
    );
    path.cubicTo(
      size.width * 0.3, size.height * 0.5,
      size.width * 0.7, size.height * 0.5,
      size.width * 0.7, size.height * 0.65,
    );
    path.cubicTo(
      size.width * 0.7, size.height * 0.8,
      size.width * 0.3, size.height * 0.8,
      size.width * 0.3, size.height * 0.7,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Folder icon painter
class _FolderIconPainter extends CustomPainter {
  final Color color;

  _FolderIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Folder tab
    path.moveTo(size.width * 0.15, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.45, size.height * 0.2);
    path.lineTo(size.width * 0.85, size.height * 0.2);

    // Main folder body
    path.moveTo(size.width * 0.15, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.8);
    path.lineTo(size.width * 0.85, size.height * 0.8);
    path.lineTo(size.width * 0.85, size.height * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dumbbell icon painter
class _DumbbellIconPainter extends CustomPainter {
  final Color color;

  _DumbbellIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Center bar
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.5),
      paint,
    );

    // Left weight
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.5),
      size.width * 0.12,
      fillPaint,
    );

    // Right weight
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.5),
      size.width * 0.12,
      fillPaint,
    );

    // Left grip lines
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.4),
      Offset(size.width * 0.15, size.height * 0.6),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.4),
      Offset(size.width * 0.25, size.height * 0.6),
      paint,
    );

    // Right grip lines
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.6),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
