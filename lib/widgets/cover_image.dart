// lib/widgets/cover_image.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../theme/app_theme.dart';
class CoverImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CoverImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = _buildImage();
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildImage() {
    if (url == null || url!.isEmpty) return _placeholder();

    // Сетевой URL
    if (url!.startsWith('http://') || url!.startsWith('https://')) {
      return Image.network(
        url!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
            ),
          );
        },
      );
    }

    // Локальный ассет
    return CoverImage(
      url: '',
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(PhosphorIconsRegular.image, color: Colors.white54),
      ),
    );
  }
}