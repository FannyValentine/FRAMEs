// lib/data/supabase_playlist_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/playlist.dart';
import '../models/soundtrack.dart';
import 'supabase_track_repository.dart';

class SupabasePlaylistRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final SupabaseTrackRepository _trackRepo = SupabaseTrackRepository();

  // Получить все плейлисты пользователя
  Future<List<Playlist>> fetchUserPlaylists() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('playlists')
        .select('*, playlist_tracks(track_id, position, tracks(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      final tracksJson = (json['playlist_tracks'] as List)
          .map((e) => e['tracks'] as Map<String, dynamic>)
          .toList();
      final tracks = tracksJson.map((j) => _trackRepo.mapToTrack(j)).toList();

      return Playlist(
        id: json['id'].toString(),
        name: json['name'] as String,
        description: json['description'] as String?,
        coverUrl: json['cover_url'] as String?,
        tracks: tracks,
      );
    }).toList();
  }

  // Создать плейлист
  Future<Playlist> createPlaylist({
    required String name,
    String? description,
    String? coverUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Не авторизован');

    final response = await _client
        .from('playlists')
        .insert({
          'user_id': userId,
          'name': name,
          'description': description,
          'cover_url': coverUrl,
        })
        .select()
        .single();

    return Playlist(
      id: response['id'].toString(),
      name: response['name'] as String,
      description: response['description'] as String?,
      coverUrl: response['cover_url'] as String?,
    );
  }

  // Добавить трек в плейлист
  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    // Получаем текущую максимальную позицию
    final existing = await _client
        .from('playlist_tracks')
        .select('position')
        .eq('playlist_id', playlistId)
        .order('position', ascending: false)
        .limit(1);

    int nextPosition = 0;
    if (existing.isNotEmpty) {
      nextPosition = (existing.first['position'] as int) + 1;
    }

    await _client.from('playlist_tracks').insert({
      'playlist_id': playlistId,
      'track_id': trackId,
      'position': nextPosition,
    });
  }

  // Удалить трек из плейлиста
  Future<void> removeTrackFromPlaylist(String playlistId, String trackId) async {
    await _client
        .from('playlist_tracks')
        .delete()
        .eq('playlist_id', playlistId)
        .eq('track_id', trackId);
  }

  // Удалить плейлист
  Future<void> deletePlaylist(String playlistId) async {
    await _client.from('playlists').delete().eq('id', playlistId);
  }
}