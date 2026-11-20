// lib/widgets/user_avatar.dart
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['name'] as String? ?? 'User';
    PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'logout') {
          await Supabase.instance.client.auth.signOut();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'logout', child: Text('Sign Out')),
      ]
    );
    // Берём первые буквы слов (до 2 штук)
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();

    return CircleAvatar(
      backgroundColor: AppTheme.accent.withValues(alpha: 0.2),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: const TextStyle(color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
    
  }
}
