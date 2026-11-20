// lib/screens/favorites_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/user_avatar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<PlayerProvider>().favoriteTracks;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TopNavigationBar(),
              ),
            ),

            SliverAppBar(
              
              backgroundColor: AppTheme.background,
              elevation: 0,
              pinned: true,
              title: RichText(
                text: const TextSpan(
                  text: 'FRAME ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textPrimary),
                  children: [TextSpan(text: '/', style: TextStyle(color: AppTheme.accent))],
                ),
              ),
              actions: [
                const SizedBox(width: 16),
                const UserAvatar(),
                const SizedBox(width: 16),
              ],
            ),
            
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOUR COLLECTION / AK', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text('Favorites', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text('${favorites.length} треков в избранном.', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
            ),
            if (favorites.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Пока нет избранных треков.\nНажмите ♡ на обложке.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TrackCard(track: favorites[index]),
                    childCount: favorites.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}