import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'quran_bookmarks';
  static SharedPreferences? _prefs;
  static Set<int>? _cache;
  static const String _lastReadKey = 'quran_last_read';

  /// Save the last-read page (called every time the user views a page)
  static Future<void> saveLastRead(int pageNumber) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_lastReadKey, pageNumber);
  }

  /// Get the last-read page (returns 0 if none)
  static int getLastReadSync() {
    return _prefs?.getInt(_lastReadKey) ?? 0;
  }

  /// Clear last-read
  static Future<void> clearLastRead() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_lastReadKey);
  }

  // Initialize once at app start
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs!.reload();
    _cache = _read();
  }

  static Set<int> _read() {
    final list = _prefs?.getStringList(_key) ?? [];
    return list.map((e) => int.tryParse(e) ?? -1).where((e) => e > 0).toSet();
  }

  // Synchronous cache read (fast)
  static Set<int> getBookmarksSync() => Set.unmodifiable(_cache ?? {});

  // Async fetch (fresh from disk)
  static Future<Set<int>> getBookmarks() async {
    if (_prefs == null) await init();
    await _prefs!.reload();
    _cache = _read();
    return Set.unmodifiable(_cache!);
  }

  static Future<Set<int>> toggleBookmark(int pageNumber) async {
    if (_prefs == null) await init();
    final current = _read();

    if (current.contains(pageNumber)) {
      current.remove(pageNumber);
    } else {
      current.add(pageNumber);
    }

    final success = await _prefs!.setStringList(
      _key,
      current.map((e) => e.toString()).toList(),
    );

    if (success) {
      await _prefs!.reload();
      _cache = _read();
    }

    return Set.unmodifiable(_cache ?? {});
  }

  static Future<Set<int>> removeBookmark(int pageNumber) async {
    if (_prefs == null) await init();
    final current = _read();
    current.remove(pageNumber);

    await _prefs!.setStringList(
      _key,
      current.map((e) => e.toString()).toList(),
    );
    await _prefs!.reload();
    _cache = _read();
    return Set.unmodifiable(_cache!);
  }

  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_key);
    await _prefs!.reload();
    _cache = {};
  }
}
