import 'dart:ui';

extension ColorOpacity on Color {
  Color opacityColor(double opacity) => withValues(alpha: opacity);
}
