import '../models/soundtrack.dart';

class MockData {
  // --- Spirited Away (Joe Hisaishi) ---
  static final Track oneSummersDay = Track(
    id: 't1',
    title: "One Summer's Day",
    artist: 'Joe Hisaishi',
    albumTitle: 'Spirited Away',
    imageUrl: 'assets/images/spirited_away.jpg',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    isFavorite: true,
  );

  static final Track merryGoRoundOfLife = Track(
    id: 't2',
    title: 'Merry-Go-Round of Life',
    artist: 'Joe Hisaishi',
    albumTitle: "Howl's Moving Castle",
    imageUrl: 'assets/images/spirited_away.jpg',
    audioUrl: 'assets/audio/merryGoRoundOfLife.mp3',
    isFavorite: true,
  );

  // --- Interstellar (Hans Zimmer) ---
  static final Track cornfieldChase = Track(
    id: 't3',
    title: 'Cornfield Chase',
    artist: 'Hans Zimmer',
    albumTitle: 'Interstellar',
    imageUrl: 'assets/images/interstellar.jpg',
    audioUrl: 'assets/audio/cornfieldChase.mp3',
    isFavorite: true,
  );

  static final Track dayOne = Track(
    id: 't4',
    title: 'Day One',
    artist: 'Hans Zimmer',
    albumTitle: 'Interstellar',
    audioUrl: 'assets/audio/dayOne.mp3',
    imageUrl: 'assets/images/interstellar.jpg',
  );

  static final Track mountains = Track(
    id: 't5',
    title: 'Mountains',
    artist: 'Hans Zimmer',
    albumTitle: 'Interstellar',
    audioUrl: 'assets/audio/mountains.mp3',
    imageUrl: 'assets/images/interstellar.jpg',
  );

  static final Track stay = Track(
    id: 't6',
    title: 'Stay',
    artist: 'Hans Zimmer',
    albumTitle: 'Interstellar',
    audioUrl: 'assets/audio/stay.mp3',
    imageUrl: 'assets/images/interstellar.jpg',
  );

  static final Track noTimeForCaution = Track(
    id: 't7',
    title: 'No Time for Caution',
    artist: 'Hans Zimmer',
    albumTitle: 'Interstellar',
    audioUrl: 'assets/audio/noTimeForCaution.mp3',
    imageUrl: 'assets/images/interstellar.jpg',
  );

  // --- Dune: Part Two (Hans Zimmer) ---
  static final Track heraldOfChange = Track(
    id: 't8',
    title: 'Herald of the Change',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/heraldOfChange.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  static final Track beginningsAreSuchDelicateTimes = Track(
    id: 't9',
    title: 'Beginnings Are Such Delicate Times',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  static final Track eclipse = Track(
    id: 't10',
    title: 'Eclipse',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  static final Track aTimeOfQuietBetweenTheStorms = Track(
    id: 't11',
    title: 'A Time of Quiet Between the Storms',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  static final Track wormRide = Track(
    id: 't12',
    title: 'Worm Ride',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  static final Track aKissOnTheBeach = Track(
    id: 't13',
    title: 'A Kiss on the Beach',
    artist: 'Hans Zimmer',
    albumTitle: 'Dune: Part Two',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/dune.jpg',
  );

  // --- The Grand Budapest Hotel (Alexandre Desplat) ---
  static final Track aPoisonousFable = Track(
    id: 't14',
    title: 'A Poisonous Fable',
    artist: 'Alexandre Desplat',
    albumTitle: 'The Grand Budapest Hotel',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/budapest.jpg',
  );

  static final Track mrMoustafa = Track(
    id: 't15',
    title: 'Mr. Moustafa',
    artist: 'Alexandre Desplat',
    albumTitle: 'The Grand Budapest Hotel',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/budapest.jpg',
  );

  static final Track theNewLobbyBoy = Track(
    id: 't16',
    title: 'The New Lobby Boy',
    artist: 'Alexandre Desplat',
    albumTitle: 'The Grand Budapest Hotel',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/budapest.jpg',
  );

  static final Track mendlAndHisWork = Track(
    id: 't17',
    title: "Mendl's And His Work",
    artist: 'Alexandre Desplat',
    albumTitle: 'The Grand Budapest Hotel',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/budapest.jpg',
  );

  static final Track joplingArrives = Track(
    id: 't18',
    title: 'Jopling Arrives',
    artist: 'Alexandre Desplat',
    albumTitle: 'The Grand Budapest Hotel',
    audioUrl: 'assets/audio/one_summers_day.mp3',
    imageUrl: 'assets/images/budapest.jpg',
  );

  // ============================================================
  // УДОБНЫЕ ССЫЛКИ (для мини-плеера и прочего)
  // ============================================================

  // --- Mulan (Jerry Goldsmith) ---
static final Track mulanReflection = Track(
  id: 't19',
  title: 'Reflection',
  artist: 'Matthew Wilder',
  albumTitle: 'Mulan',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/mulan.jpg',
);

static final Track mulanMainTitle = Track(
  id: 't20',
  title: 'Main Title',
  artist: 'Jerry Goldsmith',
  albumTitle: 'Mulan',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/mulan.jpg',
);

// --- Cowboy Bebop (SEATBELTS) ---
static final Track tank = Track(
  id: 't21',
  title: 'Tank!',
  artist: 'SEATBELTS',
  albumTitle: 'Cowboy Bebop',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/cowboy_bebop.jpg',
);

static final Track spaceLion = Track(
  id: 't22',
  title: 'Space Lion',
  artist: 'SEATBELTS',
  albumTitle: 'Cowboy Bebop',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/cowboy_bebop.jpg',
);

// --- Fantasia (Mussorgsky & Beethoven) ---
static final Track nightOnBaldMountain = Track(
  id: 't23',
  title: 'Night on Bald Mountain',
  artist: 'Modest Mussorgsky',
  albumTitle: 'Fantasia',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/fantasia.jpg',
);

static final Track pastoralSymphony = Track(
  id: 't24',
  title: 'Pastoral Symphony',
  artist: 'Ludwig van Beethoven',
  albumTitle: 'Fantasia',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/fantasia.jpg',
);

// --- Saving Private Ryan (John Williams) ---
static final Track hymnToTheFallen = Track(
  id: 't25',
  title: 'Hymn to the Fallen',
  artist: 'John Williams',
  albumTitle: 'Saving Private Ryan',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/saving_private_ryan.jpg',
);

// --- Spirited Away (альтернативный постер) ---
static final Track theNameOfLife = Track(
  id: 't26',
  title: 'The Name of Life',
  artist: 'Joe Hisaishi',
  albumTitle: 'Spirited Away',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/spirited_away_2.jpg',
);

// --- The Grand Budapest Hotel (альтернативный постер) ---
static final Track mrMoustafaReprise = Track(
  id: 't27',
  title: 'Mr. Moustafa (Reprise)',
  artist: 'Alexandre Desplat',
  albumTitle: 'The Grand Budapest Hotel',
  audioUrl: 'assets/audio/one_summers_day.mp3',
  imageUrl: 'assets/images/grand_budapest_2.jpg',
);
  static final Track theyNotLikeUs = Track(
  id: 'easter_egg_1',
  title: 'They Not Like Us',
  artist: 'Kendrick Lamar',
  albumTitle: 'GNX',
  imageUrl: 'assets/images/they_not_like_us.jpg',
  audioUrl: 'assets/audio/they_not_like_us.mp3',
);
}