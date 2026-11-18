// lib/screens/recently_played_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cover_image.dart';
class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recent = context.watch<PlayerProvider>().recentlyPlayedTracks;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            text: 'FRAME ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textPrimary),
            children: [TextSpan(text: '/', style: TextStyle(color: AppTheme.accent))],
          ),
        ),
        actions: [
          const SizedBox(width: 16),
          CircleAvatar(backgroundColor: AppTheme.accent.withOpacity(0.2), child: const Text('AK', style: TextStyle(color: AppTheme.accent, fontSize: 12))),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOUR LISTENING HISTORY', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text('Recently played', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36)),
                    const SizedBox(height: 8),
                    const Text('Pick up a feeling you left behind.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
            ),
            if (recent.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Вы ещё ничего не слушали.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final track = recent[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: track.imageUrl.isNotEmpty
                          ? CoverImage(url: track.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : Container(width: 50, height: 50, color: Colors.grey[800]),
                      title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(track.artist, style: const TextStyle(color: AppTheme.textSecondary)),
                      onTap: () => context.read<PlayerProvider>().playTrack(track),
                    );
                  },
                  childCount: recent.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}