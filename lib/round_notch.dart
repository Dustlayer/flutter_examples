class TopNotchPainter extends CustomPainter {
  final Color color;
  final double notchRadius;
  final double notchWidth;

  /// can be defined to visually smoothen the curve by drawing a semi-transparent line around the shape
  final Color? backgroundColor;

  TopNotchPainter({
    required this.color,
    this.notchRadius = 60.0,
    this.notchWidth = 200,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

    final path = Path();
    final centerX = size.width / 2;
    final notchDepth = notchRadius / 2;
    final leftStartX = centerX - notchWidth / 2;
    final rightEndX = centerX + notchWidth / 2;

    path.moveTo(leftStartX, 0);

    path.quadraticBezierTo(leftStartX + notchWidth / 4, 0, leftStartX + notchWidth / 3, notchDepth);
    path.quadraticBezierTo(
      centerX,
      notchRadius * 1.2,
      leftStartX + ((2 * notchWidth) / 3),
      notchDepth,
    );

    path.quadraticBezierTo(rightEndX - notchWidth / 4, 0, rightEndX, 0);

    path.close();

    canvas.drawPath(path, paint);
    if (backgroundColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = backgroundColor!.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
