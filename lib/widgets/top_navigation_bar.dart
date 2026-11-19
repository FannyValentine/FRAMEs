// lib/widgets/top_navigation_bar.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_theme.dart';

class TopNavigationBar extends StatelessWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;

  const TopNavigationBar({
    super.key,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Поле поиска
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(PhosphorIconsRegular.magnifyingGlass, color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search scores, composers, worlds...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Text('⌘ K', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Кнопки навигации
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildButton(context, 'Discover', PhosphorIconsRegular.compass, 0),
              const SizedBox(width: 8),
              _buildButton(context, 'Browse', PhosphorIconsRegular.squaresFour, 1),
              const SizedBox(width: 8),
              _buildButton(context, 'Saved', PhosphorIconsRegular.bookmarkSimple, 2),
              const SizedBox(width: 8),
              _buildButton(context, 'Listening room', PhosphorIconsRegular.waveform, 3),
              const SizedBox(width: 8),
              _buildButton(context, 'Favorites', PhosphorIconsRegular.heart, 4),
              const SizedBox(width: 8),
              _buildButton(context, 'Recently played', PhosphorIconsRegular.clockCounterClockwise, 5),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, int index) {
    final nav = context.watch<NavigationProvider>();
    final isActive = nav.currentIndex == index;

    return GestureDetector(
      onTap: () => context.read<NavigationProvider>().setIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.accent.withValues(alpha: 0.15) //заменяем withOpacity
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.accent : Colors.white24,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppTheme.accent : AppTheme.textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.accent : AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}