// lib/models/playlist.dart
import 'soundtrack.dart';

class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    this.tracks = const [],
  });

  Playlist copyWith({
    String? name,
    String? description,
    String? coverUrl,
    List<Track>? tracks,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      tracks: tracks ?? this.tracks,
    );
  }
}