// ignore_for_file: file_names

/// Translation overrides for `en_US`.
///
/// Intentionally empty. The app calls `.tr` on ~79 distinct literal strings,
/// none of which are keyed here — GetX falls back to returning the key itself,
/// which is already correct English. Populating this map is only necessary when
/// a second locale is added; until then an entry here would just restate the
/// literal.
///
/// (This file previously held the string table from an unrelated COVID-19
/// tracker that this project was originally scaffolded from.)
const Map<String, String> enUS = {};
