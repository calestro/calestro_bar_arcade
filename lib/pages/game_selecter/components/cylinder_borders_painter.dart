import 'package:flutter/material.dart';

class CylinderBordersPainter extends CustomPainter {
  final double rimHeight;

  final double curvature;

  final bool showSideBorders;

  const CylinderBordersPainter({
    this.rimHeight = 26.0,
    this.curvature = 18.0,
    this.showSideBorders = true,
  });

  Shader _createMetallicShader(Rect bounds, {double brightness = 1.0}) {
    Color adjust(Color c) {
      if (brightness == 1.0) return c;
      final hsl = HSLColor.fromColor(c);
      return hsl
          .withLightness((hsl.lightness * brightness).clamp(0.0, 1.0))
          .toColor();
    }

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        adjust(const Color(0xFFEBC896)), // Brilho de contorno esquerdo
        adjust(const Color(0xFF7A5638)), // Transição
        adjust(const Color(0xFF261A13)), // Sombra vertical característica
        adjust(const Color(0xFFC79660)), // Reflexo bronze
        adjust(const Color(0xFFF3D4A5)), // Pico especular dourado
        adjust(const Color(0xFF9C7046)), // Tom médio
        adjust(const Color(0xFF3B291D)), // Sombra direita
        adjust(const Color(0xFF17110D)), // Lado escuro
        adjust(const Color(0xFF5E442E)), // Leve luz de recorte à direita
      ],
      stops: const [0.0, 0.06, 0.14, 0.29, 0.41, 0.57, 0.78, 0.94, 1.0],
    ).createShader(bounds);
  }

  /// Cria uma faixa curvada (aro) entre duas curvas elípticas paralelas
  Path _createCurvedBand({
    required double left,
    required double right,
    required double topY,
    required double bottomY,
    required double curveOffset, // negativo = curva p/ cima, positivo = p/ baixo
  }) {
    final w = right - left;
    final ctrlOffset = curveOffset * 1.33;

    return Path()
      ..moveTo(left, topY)
      ..cubicTo(
        left + w * 0.25,
        topY + ctrlOffset,
        left + w * 0.75,
        topY + ctrlOffset,
        right,
        topY,
      )
      ..lineTo(right, bottomY)
      ..cubicTo(
        left + w * 0.75,
        bottomY + ctrlOffset,
        left + w * 0.25,
        bottomY + ctrlOffset,
        left,
        bottomY,
      )
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fullBounds = Offset.zero & size;

    // 1. BORDAS LATERAIS SUTIS (Opcional - mantém o interior 100% transparente)
    if (showSideBorders) {
      final sidePaintLeft = Paint()
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xCCEBC896),
            Color(0x55C79660),
            Color(0x33C79660),
            Color(0xCCEBC896),
          ],
        ).createShader(fullBounds);

      final sidePaintRight = Paint()
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x996E5036),
            Color(0x334A3524),
            Color(0x334A3524),
            Color(0x996E5036),
          ],
        ).createShader(fullBounds);

      canvas.drawLine(
        Offset(1, curvature + rimHeight * 0.5),
        Offset(1, h - curvature - rimHeight * 0.5),
        sidePaintLeft,
      );
      canvas.drawLine(
        Offset(w - 1, curvature + rimHeight * 0.5),
        Offset(w - 1, h - curvature - rimHeight * 0.5),
        sidePaintRight,
      );
    }

    // =========================================================================
    // 2. ARO SUPERIOR (Curvatura para cima)
    // =========================================================================
    final topBaseY = curvature;

    // 2a. Tampa superior recuada (degrau de cima)
    final topCapInset = w * 0.032;
    final topCapPath = _createCurvedBand(
      left: topCapInset,
      right: w - topCapInset,
      topY: topBaseY,
      bottomY: topBaseY + rimHeight * 0.34,
      curveOffset: -curvature * 0.85,
    );
    canvas.drawPath(
      topCapPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 0.72),
    );

    // 2b. Sombra projetada pelo aro superior para dentro do cilindro
    final topShadowPath = _createCurvedBand(
      left: 0,
      right: w,
      topY: topBaseY + rimHeight * 0.85,
      bottomY: topBaseY + rimHeight * 1.45,
      curveOffset: -curvature,
    );
    canvas.drawPath(
      topShadowPath,
      Paint()
        ..color = const Color(0xAA000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // 2c. Anel principal superior (bronze/dourado)
    final topMainPath = _createCurvedBand(
      left: 0,
      right: w,
      topY: topBaseY + rimHeight * 0.28,
      bottomY: topBaseY + rimHeight * 0.88,
      curveOffset: -curvature,
    );
    canvas.drawPath(
      topMainPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 1.05),
    );

    // 2d. Friso fino inferior do aro superior
    final topLipPath = _createCurvedBand(
      left: w * 0.015,
      right: w - w * 0.015,
      topY: topBaseY + rimHeight * 0.90,
      bottomY: topBaseY + rimHeight * 1.06,
      curveOffset: -curvature * 0.96,
    );
    canvas.drawPath(
      topLipPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 0.85),
    );

    // =========================================================================
    // 3. ARO INFERIOR (Curvatura para baixo)
    // =========================================================================
    final bottomBaseY = h - curvature;

    // 3a. Sombra externa abaixo do cilindro
    final outerShadowPath = _createCurvedBand(
      left: w * 0.02,
      right: w - w * 0.02,
      topY: bottomBaseY - rimHeight * 0.3,
      bottomY: bottomBaseY + rimHeight * 0.25,
      curveOffset: curvature * 0.9,
    );
    canvas.drawPath(
      outerShadowPath,
      Paint()
        ..color = const Color(0xCC000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // 3b. Base inferior recuada (degrau de baixo)
    final bottomCapInset = w * 0.028;
    final bottomCapPath = _createCurvedBand(
      left: bottomCapInset,
      right: w - bottomCapInset,
      topY: bottomBaseY - rimHeight * 0.32,
      bottomY: bottomBaseY,
      curveOffset: curvature * 0.88,
    );
    canvas.drawPath(
      bottomCapPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 0.68),
    );

    // 3c. Anel principal inferior
    final bottomMainPath = _createCurvedBand(
      left: 0,
      right: w,
      topY: bottomBaseY - rimHeight * 0.88,
      bottomY: bottomBaseY - rimHeight * 0.26,
      curveOffset: curvature,
    );
    canvas.drawPath(
      bottomMainPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 1.0),
    );

    // 3d. Friso fino superior do aro inferior
    final bottomLipPath = _createCurvedBand(
      left: w * 0.015,
      right: w - w * 0.015,
      topY: bottomBaseY - rimHeight * 1.06,
      bottomY: bottomBaseY - rimHeight * 0.90,
      curveOffset: curvature * 0.96,
    );
    canvas.drawPath(
      bottomLipPath,
      Paint()..shader = _createMetallicShader(fullBounds, brightness: 0.82),
    );
  }

  @override
  bool shouldRepaint(covariant CylinderBordersPainter oldDelegate) {
    return oldDelegate.rimHeight != rimHeight ||
        oldDelegate.curvature != curvature ||
        oldDelegate.showSideBorders != showSideBorders;
  }
}