// lib/models/soundtrack.dart

/// Категории (миры), к которым относится саундтрек.
/// Используется для фильтрации на экранах Browse, Saved и т.д.
enum SoundtrackWorld {
  film,
  anime,
  animation,
}

/// Модель для одного трека (песни).
class Track {
  final String id;
  final String title;
  final String artist;
  final String albumTitle;
  final Duration? duration;
  final SoundtrackWorld world;
  final String imageUrl;
  final String audioUrl;
  final bool isFavorite;
  final bool isSaved;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumTitle,
    this.duration,
    required this.imageUrl,
    required this.audioUrl,
    this.world = SoundtrackWorld.film,
    this.isFavorite = false,
    this.isSaved = false,
  });

  /// Вспомогательный метод для форматирования длительности в строку "3:09"
  String get formattedDuration {
    if (duration == null) return '--:--';
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Метод для обновления состояния (например, когда пользователь нажимает на сердечко)
  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? albumTitle,
    Duration? duration,
    String? imageUrl,
    String? audioUrl,
    SoundtrackWorld? world,
    bool? isFavorite,
    bool? isSaved,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumTitle: albumTitle ?? this.albumTitle,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      world: world ?? this.world,
      isFavorite: isFavorite ?? this.isFavorite,
      isSaved: isSaved ?? this.isSaved,
    );
  }
  /// Фабричный метод для создания объекта из JSON (пригодится при подключении к API)
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      albumTitle: json['albumTitle'] as String,
      duration: Duration(seconds: json['durationInSeconds'] as int),
      imageUrl: json['imageUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      audioUrl: json ['audioUrl']
    );
  }
}

/// Модель для саундтрека (альбома), который содержит список треков.
class Soundtrack {
  final String id;
  final String title;
  final String composer;
  final int releaseYear;
  final SoundtrackWorld world;
  final String imageUrl;
  final String description;
  final List<Track> tracks;
  final bool isSaved;

  const Soundtrack({
    required this.id,
    required this.title,
    required this.composer,
    required this.releaseYear,
    required this.world,
    required this.imageUrl,
    required this.description,
    required this.tracks,
    this.isSaved = false,
  });

  /// Общая длительность саундтрека (вычисляется динамически на основе треков)
  Duration get totalDuration {
  return tracks.fold(
    Duration.zero,
    (sum, track) => sum + (track.duration ?? Duration.zero),
  );
}

  /// Форматированная общая длительность (например, "81 MIN")
  String get formattedTotalDuration {
    return '${totalDuration.inMinutes} MIN';
  }

  /// Количество треков
  int get trackCount => tracks.length;

  Soundtrack copyWith({
    bool? isSaved,
    List<Track>? tracks,
  }) {
    return Soundtrack(
      id: id,
      title: title,
      composer: composer,
      releaseYear: releaseYear,
      world: world,
      imageUrl: imageUrl,
      description: description,
      tracks: tracks ?? this.tracks,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

/// Модель для "Настроений" (Moods), которые мы видим на экране "Find your feeling"
class Mood {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int trackCount;
  final Duration totalDuration;

  const Mood({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.trackCount,
    required this.totalDuration,
  });

  String get formattedDuration {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes.remainder(60);
    return '${hours > 0 ? '${hours}H ' : ''}${minutes}M';
  }
}
