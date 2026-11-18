// lib/providers/player_provider.dart
import 'package:material_ui/material_ui.dart';
import '../models/soundtrack.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../data/mock_data.dart'; // Импортируем моковые данные
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Track? _currentTrack;
  bool _isPlaying = false;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;

  PlayerProvider() {
    _audioPlayer.positionStream.listen((_) => notifyListeners());
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  // lib/providers/player_provider.dart
  Future<void> playTrack(Track track) async {
    _currentTrack = track;
    notifyListeners();

    if (track.audioUrl.isEmpty) return;

    try {
      final artUri = await _assetToFileUri(track.imageUrl);
      final audioSource = AudioSource.asset(
        track.audioUrl,
        tag: MediaItem(
          id: track.id,
          album: track.albumTitle,
          title: track.title,
          artist: track.artist,
          artUri: artUri, 
        ),
      );

      await _audioPlayer.setAudioSource(audioSource);
      await _audioPlayer.play();

      // 👇 Обновляем длительность после загрузки
      final realDuration = _audioPlayer.duration;
      if (realDuration != null) {
        _currentTrack = track.copyWith(duration: realDuration);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка воспроизведения: $e');
    }
  }
  Future<Uri> _assetToFileUri(String assetPath) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${tempDir.path}/$fileName');
    if (!await file.exists()) {
      final bytes = await rootBundle.load(assetPath);
      await file.writeAsBytes(bytes.buffer.asUint8List());
    }
    return Uri.file(file.path);
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  // Хранилище всех саундтреков в приложении
  final List<Soundtrack> _allSoundtracks = [
    MockData.spiritedAwaySoundtrack,
    MockData.interstellarSoundtrack, // Добавим в мок-данные
    MockData.duneSoundtrack,         // Добавим в мок-данные
    MockData.grandBudapestSoundtrack // Добавим в мок-данные
  ];

  // Геттер, который возвращает ТОЛЬКО сохраненные саундтреки
  List<Soundtrack> get allSoundtracks => List.unmodifiable(_allSoundtracks);
  List<Soundtrack> get browseSoundtracks => List.unmodifiable(MockData.browseCatalog);
  // Метод для переключения статуса "Сохранено"
  void toggleSaveSoundtrack(String id) {
    final index = _allSoundtracks.indexWhere((s) => s.id == id);
    if (index != -1) {
      _allSoundtracks[index] = _allSoundtracks[index].copyWith(
        isSaved: !_allSoundtracks[index].isSaved,
      );
      notifyListeners(); // Сообщаем UI, что данные изменились
    }
  }

}
