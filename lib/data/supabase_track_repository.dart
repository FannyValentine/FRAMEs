// lib/data/supabase_track_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/soundtrack.dart';
class SupabaseTrackRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'tracks';

  Future<List<Track>> fetchAllTracks() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => _mapToTrack(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      print('Ошибка БД (fetchAllTracks): ${e.message}');
      rethrow;
    }
  }

  Future<Track?> fetchTrackById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return _mapToTrack(response);
    } on PostgrestException catch (e) {
      print('Ошибка БД (fetchTrackById): ${e.message}');
      rethrow;
    }
  }

  Future<List<Track>> searchTracks(String query) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .or('title.ilike.%$query%,artist.ilike.%$query%,album_title.ilike.%$query%')
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => _mapToTrack(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      print('Ошибка БД (searchTracks): ${e.message}');
      rethrow;
    }
  }

  Future<Track> createTrack(Track track) async {
    try {
      final response = await _client
          .from(_tableName)
          .insert(_trackToMap(track))
          .select()
          .single();
      return _mapToTrack(response);
    } on PostgrestException catch (e) {
      print('Ошибка БД (createTrack): ${e.message}');
      rethrow;
    }
  }

  Future<Track> updateTrack(Track track) async {
    try {
      final response = await _client
          .from(_tableName)
          .update(_trackToMap(track))
          .eq('id', track.id)
          .select()
          .single();
      return _mapToTrack(response);
    } on PostgrestException catch (e) {
      print('Ошибка БД (updateTrack): ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteTrack(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      print('Ошибка БД (deleteTrack): ${e.message}');
      rethrow;
    }
  }

  // ============================================================
  // МАППИНГ
  // ============================================================

  Track _mapToTrack(Map<String, dynamic> json) {
  return Track(
    id: json['id'].toString(),
    title: json['title'] as String? ?? 'Без названия',
    artist: json['artist'] as String? ?? 'Неизвестный композитор',
    albumTitle: json['album_title'] as String? ?? 'Без фильма',
    duration: null,
    imageUrl: json['cover_url'] as String? ?? '',
    audioUrl: json['audio_url'] as String,
    world: _parseWorld(json['world'] as String?),
    genre: json['genre'] as String?,
  );
}

  SoundtrackWorld _parseWorld(String? value) {
    switch (value) {
      case 'anime':
        return SoundtrackWorld.anime;
      case 'animation':
        return SoundtrackWorld.animation;
      case 'film':
      default:
        return SoundtrackWorld.film;
    }
  }

  Map<String, dynamic> _trackToMap(Track track) {
    return {
      'title': track.title,
      'artist': track.artist,
      'album_title': track.albumTitle,
      'cover_url': track.imageUrl,
      'audio_url': track.audioUrl,
      'world': track.world.name,
    };
  }
}