// lib/providers/player_provider.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/soundtrack.dart';
import '../data/supabase_track_repository.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SupabaseTrackRepository _trackRepo = SupabaseTrackRepository();

  List<Track> _allTracks = [];
  bool _isLoading = false;
  String? _errorMessage;

  Track? _currentTrack;
  bool _isPlaying = false;

  List<Track> _favoriteTracks = [];
  List<Track> _recentlyPlayed = [];
  final Set<String> _savedTrackIds = {};

  // --- Геттеры ---
  List<Track> get allTracks => List.unmodifiable(_allTracks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;

  List<Track> get favoriteTracks => List.unmodifiable(_favoriteTracks);
  List<Track> get recentlyPlayedTracks => List.unmodifiable(_recentlyPlayed);
  List<Track> get savedTracks =>
      _allTracks.where((t) => _savedTrackIds.contains(t.id)).toList();

  bool isFavorite(String trackId) => _favoriteTracks.any((t) => t.id == trackId);
  bool isSaved(String trackId) => _savedTrackIds.contains(trackId);

  PlayerProvider() {
    _audioPlayer.positionStream.listen((_) => notifyListeners());
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
    loadAllData(); // 👈 ВАЖНО: загрузка при старте
  }

  Future<void> loadAllData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      // 1. Все треки (доступны всем)
      _allTracks = await _trackRepo.fetchAllTracks();

      if (userId != null) {
        // 2. Избранное пользователя
        final favResponse = await Supabase.instance.client
            .from('user_favorites')
            .select('track_id')
            .eq('user_id', userId);
        final favIds =
            (favResponse as List).map((e) => e['track_id'].toString()).toSet();
        _favoriteTracks =
            _allTracks.where((t) => favIds.contains(t.id)).toList();

        // 3. История пользователя
        final histResponse = await Supabase.instance.client
            .from('user_history')
            .select('track_id')
            .eq('user_id', userId)
            .order('played_at', ascending: false)
            .limit(20);
        final histIds =
            (histResponse as List).map((e) => e['track_id'].toString()).toList();
        _recentlyPlayed = histIds
            .map((id) => _allTracks.firstWhere((t) => t.id == id,
                orElse: () => null as Track))
            .whereType<Track>()
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Ошибка загрузки: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String trackId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final isFav = isFavorite(trackId);
    if (isFav) {
      _favoriteTracks.removeWhere((t) => t.id == trackId);
    } else {
      final track = _allTracks.firstWhere((t) => t.id == trackId);
      _favoriteTracks.add(track);
    }
    notifyListeners();

    try {
      if (isFav) {
        await Supabase.instance.client
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('track_id', trackId);
      } else {
        await Supabase.instance.client
            .from('user_favorites')
            .insert({'user_id': userId, 'track_id': trackId});
      }
    } catch (e) {
      debugPrint('Ошибка обновления избранного: $e');
    }
  }

  void toggleSaved(String trackId) {
    if (_savedTrackIds.contains(trackId)) {
      _savedTrackIds.remove(trackId);
    } else {
      _savedTrackIds.add(trackId);
    }
    notifyListeners();
  }

  Future<void> _logHistory(Track track) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await Supabase.instance.client.from('user_history').insert({
        'user_id': userId,
        'track_id': track.id,
      });
    } catch (e) {
      debugPrint('Ошибка записи истории: $e');
    }
  }

  Future<void> playTrack(Track track) async {
  if (_currentTrack?.id == track.id &&
      _audioPlayer.processingState != ProcessingState.idle) {
    if (!_isPlaying) await _audioPlayer.play();
    return;
  }
  AudioSource? _resolveAudioSource(String url, Track track) {
    final tag = MediaItem(
      id: track.id,
      album: track.albumTitle,
      title: track.title,
      artist: track.artist,
    );

    // Сеть
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return AudioSource.uri(Uri.parse(url), tag: tag);
    }

    // Локальный ассет: assets/... (или явная схема asset://)
    if (url.startsWith('assets/') || url.startsWith('asset://')) {
      final assetPath =
          url.startsWith('asset://') ? url.substring('asset://'.length) : url;
      return AudioSource.asset(assetPath, tag: tag);
    }

    // Файл на устройстве (опционально, для полноты)
    if (url.startsWith('file://')) {
      return AudioSource.uri(Uri.parse(url), tag: tag);
    }

    return null;
  }
  _currentTrack = track;
  _recentlyPlayed.removeWhere((t) => t.id == track.id);
  _recentlyPlayed.insert(0, track);
  if (_recentlyPlayed.length > 10) _recentlyPlayed.removeLast();
  notifyListeners();

  await _logHistory(track);

  final url = track.audioUrl;
  if (url == null || url.isEmpty) {
    debugPrint('У трека ${track.title} нет audio_url');
    return;
  }

  final audioSource = _resolveAudioSource(url, track);
  if (audioSource == null) {
    debugPrint('Неподдерживаемый audio_url: $url');
    return;
  }

  try {
    await _audioPlayer.stop();
    await _audioPlayer.setAudioSource(audioSource);
    await _audioPlayer.play();
  } catch (e) {
    debugPrint('Ошибка воспроизведения: $e');
  }
}
  

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNext() async {
    if (_allTracks.isEmpty || _currentTrack == null) return;
    final currentIndex = _allTracks.indexWhere((t) => t.id == _currentTrack!.id);
    if (currentIndex == -1) return;
    final nextIndex = (currentIndex + 1) % _allTracks.length;
    await playTrack(_allTracks[nextIndex]);
  }

  Future<void> playPrevious() async {
    if (_allTracks.isEmpty || _currentTrack == null) return;
    final currentIndex = _allTracks.indexWhere((t) => t.id == _currentTrack!.id);
    if (currentIndex == -1) return;
    final prevIndex = (currentIndex - 1 + _allTracks.length) % _allTracks.length;
    await playTrack(_allTracks[prevIndex]);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}