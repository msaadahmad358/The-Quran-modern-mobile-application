import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'bookmark_service.dart';
import 'quran_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookmarkService.init();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const QuranApp(),
    ),
  );
}

// --- APP COLORS (unchanged) ---
class AppColors {
  static const Color teal = Color(0xFF008080);
  static const Color tealDark = Color(0xFF00595A);
  static const Color tealFaint = Color(0xFFE0F0F0);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF6B6B6B);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerSoft = Color(0xFFF0F0F0);
}

// --- PREMIUM TEXT STYLES ---
class AppText {
  static const TextStyle headline = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );
  static const TextStyle title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );
  static const TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const TextStyle caption = TextStyle(
    color: AppColors.textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  static const TextStyle overline = TextStyle(
    color: AppColors.tealDark,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

// --- MOTION CONSTANTS ---
class AppMotion {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'The Quran',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.teal,
        colorScheme: const ColorScheme.light(
          primary: AppColors.teal,
          secondary: AppColors.tealDark,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: AppText.headline,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 0.5,
          space: 1,
        ),
        splashFactory: InkSparkle.splashFactory,
        splashColor: AppColors.teal.withOpacity(0.08),
        highlightColor: AppColors.teal.withOpacity(0.04),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<int> _bookmarks = {};
  int _lastReadPage = 0;

  @override
  void initState() {
    super.initState();
    _bookmarks = BookmarkService.getBookmarksSync();
    _lastReadPage = BookmarkService.getLastReadSync();
  }

  Future<void> _refresh() async {
    final updatedBookmarks = await BookmarkService.getBookmarks();
    final updatedLastRead = BookmarkService.getLastReadSync();
    if (!mounted) return;
    setState(() {
      _bookmarks = updatedBookmarks;
      _lastReadPage = updatedLastRead;
    });
  }

  Future<void> _openLastRead() async {
    if (_lastReadPage <= 0) return;
    final surah = QuranData.surahForPage(_lastReadPage);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReadingScreen(
          surahName: surah['name'],
          startPage: _lastReadPage,
        ),
      ),
    );
    _refresh();
  }

  Future<void> _openSurah(int index) async {
    final surah = QuranData.surahs[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReadingScreen(
          surahName: surah['name'],
          startPage: surah['startPage'],
        ),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // --- Minimal AppBar with only actions ---
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 52,
        titleSpacing: 20,
        title: const SizedBox.shrink(),
        actions: [
          if (_bookmarks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _BookmarkBadgeButton(
                count: _bookmarks.length,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookmarksScreen(),
                    ),
                  );
                  _refresh();
                },
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // --- FIXED TOP AREA (does not scroll) ---
          _HomeHeroHeader(
            lastReadPage: _lastReadPage,
            totalBookmarks: _bookmarks.length,
            onContinueTap: _lastReadPage > 0 ? _openLastRead : null,
          ),

          // --- FIXED SECTION HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('All Surahs', style: AppText.overline),
                const Spacer(),
                Text(
                  '${QuranData.surahs.length} total',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider between header and list
          const Divider(height: 1, color: AppColors.dividerSoft),

          // --- ONLY THE LIST SCROLLS ---
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: QuranData.surahs.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 76,
                endIndent: 20,
                color: AppColors.dividerSoft,
              ),
              itemBuilder: (context, index) {
                final surah = QuranData.surahs[index];
                return _SurahTile(
                  surah: surah,
                  index: index + 1,
                  bookmarkCount: _getSurahBookmarkCount(index),
                  onTap: () => _openSurah(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getSurahBookmarkCount(int index) {
    final startPage = QuranData.surahs[index]['startPage'] as int;
    final endPage = (index < QuranData.surahs.length - 1)
        ? (QuranData.surahs[index + 1]['startPage'] as int) - 1
        : QuranData.totalPages;

    int count = 0;
    for (final p in _bookmarks) {
      if (p >= startPage && p <= endPage) count++;
    }
    return count;
  }
}

// --- HOME HERO HEADER (with banner image) ---
class _HomeHeroHeader extends StatelessWidget {
  final int lastReadPage;
  final int totalBookmarks;
  final VoidCallback? onContinueTap;

  const _HomeHeroHeader({
    required this.lastReadPage,
    required this.totalBookmarks,
    required this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BANNER IMAGE ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Banner image
                  Image.asset(
                    'assets/banner.png',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),

                  // Subtle dark gradient overlay for text legibility
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.25),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Text overlay (bottom-left)
                  Positioned(
                    left: 20,
                    bottom: 18,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'The Quran',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Read · Reflect · Remember',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- STATS ROW ---
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  icon: Icons.menu_book_rounded,
                  label: 'Surahs',
                  value: '114',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  icon: Icons.description_outlined,
                  label: 'Pages',
                  value: '604',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBlock(
                  icon: Icons.bookmark_rounded,
                  label: 'Saved',
                  value: '$totalBookmarks',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- CONTINUE READING / START READING CARD ---
          if (onContinueTap != null)
            _ContinueReadingCard(
              page: lastReadPage,
              surahName: QuranData.surahForPage(lastReadPage)['name'] as String,
              onTap: onContinueTap!,
            )
          else
            _StartReadingCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReadingScreen(
                      surahName: 'Al-Fatihah',
                      startPage: 1,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// --- STAT BLOCK (small info card) ---
class _StatBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBlock({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerSoft, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.teal,
              ),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// --- START READING CARD (shown when no last-read) ---
class _StartReadingCard extends StatelessWidget {
  final VoidCallback onTap;

  const _StartReadingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'START READING',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Begin with Al-Fatihah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- BOOKMARK BADGE BUTTON (AppBar action) ---
class _BookmarkBadgeButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _BookmarkBadgeButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.bookmark_rounded,
                size: 18,
                color: AppColors.teal,
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tealFaint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.tealDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CONTINUE READING CARD (elevated, premium) ---
class _ContinueReadingCard extends StatelessWidget {
  final int page;
  final String surahName;
  final VoidCallback onTap;

  const _ContinueReadingCard({
    required this.page,
    required this.surahName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.teal.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon block
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.tealFaint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    size: 22,
                    color: AppColors.tealDark,
                  ),
                ),
                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CONTINUE READING', style: AppText.overline),
                      const SizedBox(height: 4),
                      Text(
                        surahName,
                        style: AppText.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Page $page',
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ),

                // Arrow with circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SURAH TILE (premium) ---
class _SurahTile extends StatelessWidget {
  final Map<String, dynamic> surah;
  final int index;
  final int bookmarkCount;
  final VoidCallback onTap;

  const _SurahTile({
    required this.surah,
    required this.index,
    required this.bookmarkCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Number block (sharp, refined)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(
                    color: AppColors.teal.withOpacity(0.35),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: AppColors.tealDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Text block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            surah['name'],
                            style: AppText.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (bookmarkCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bookmark_rounded,
                                  color: AppColors.teal,
                                  size: 10,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '$bookmarkCount',
                                  style: const TextStyle(
                                    color: AppColors.tealDark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Page ${surah['startPage']}',
                          style: AppText.caption,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.textMuted.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${surah['pages']}',
                          style: AppText.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arabic name
              Text(
                surah['arabic'],
                style: const TextStyle(
                  color: AppColors.tealDark,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),

              // Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- READING SCREEN ---
class ReadingScreen extends StatefulWidget {
  final String surahName;
  final int startPage;

  const ReadingScreen({
    super.key,
    required this.surahName,
    required this.startPage,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late PageController _pageController;
  late int _currentPage;
  Set<int> _bookmarks = {};
  bool _showChrome = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.startPage;
    _pageController = PageController(
      initialPage: widget.startPage - 1,
      viewportFraction: 1.0,
    );
    _bookmarks = BookmarkService.getBookmarksSync();
    _precacheAround(widget.startPage);
    BookmarkService.saveLastRead(widget.startPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _precacheAround(int page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final p in [page - 1, page + 1, page + 2]) {
        if (p >= 1 && p <= QuranData.totalPages) {
          precacheImage(AssetImage(QuranData.pagePath(p)), context);
        }
      }
    });
  }

  Future<void> _toggleBookmark() async {
    final updated = await BookmarkService.toggleBookmark(_currentPage);
    if (!mounted) return;

    final isNowBookmarked = updated.contains(_currentPage);
    setState(() => _bookmarks = updated);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.tealDark,
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 96),
          duration: const Duration(milliseconds: 1400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            children: [
              Icon(
                isNowBookmarked
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_remove_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                isNowBookmarked
                    ? 'Bookmarked page $_currentPage'
                    : 'Bookmark removed',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      );
  }

  bool get _isBookmarked => _bookmarks.contains(_currentPage);

  void _toggleChrome() {
    setState(() => _showChrome = !_showChrome);
  }

  void _showSurahPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _SurahPickerSheet(
          currentSurah: widget.surahName,
          bookmarkCount: _bookmarks.length,
          onSelected: (page) {
            Navigator.pop(context);
            _pageController.animateToPage(
              page - 1,
              duration: AppMotion.medium,
              curve: AppMotion.easeInOut,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 4,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surahName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Page $_currentPage of ${QuranData.totalPages}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 21),
            onPressed: _showSurahPicker,
            tooltip: 'Change Surah',
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 6),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.divider),
        ),
      ),
      body: Stack(
        children: [
          // --- PAGE VIEWER ---
          PageView.builder(
            controller: _pageController,
            itemCount: QuranData.totalPages,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentPage = index + 1);
              _precacheAround(index + 1);
              BookmarkService.saveLastRead(index + 1);
            },
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              return GestureDetector(
                onTap: _toggleChrome,
                behavior: HitTestBehavior.opaque,
                child: _PageView(pageNumber: pageNumber),
              );
            },
          ),

          // --- BOTTOM FLOATING BAR (with animation) ---
          AnimatedPositioned(
            duration: AppMotion.medium,
            curve: AppMotion.easeOut,
            bottom: _showChrome ? 16 : -80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.teal.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text(
                            '$_currentPage',
                            style: const TextStyle(
                              color: AppColors.tealDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            ' / ${QuranData.totalPages}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.divider,
                    ),
                    // Bookmark toggle
                    InkWell(
                      onTap: _toggleBookmark,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: AppMotion.fast,
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                _isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                key: ValueKey(_isBookmarked),
                                size: 18,
                                color: _isBookmarked
                                    ? AppColors.teal
                                    : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isBookmarked ? 'Saved' : 'Save',
                              style: TextStyle(
                                color: _isBookmarked
                                    ? AppColors.teal
                                    : AppColors.textMuted,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- PAGE VIEW ---
class _PageView extends StatelessWidget {
  final int pageNumber;

  const _PageView({required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 4.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
        child: Center(
          child: Image.asset(
            QuranData.pagePath(pageNumber),
            fit: BoxFit.contain,
            gaplessPlayback: true,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textMuted,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Page $pageNumber not found',
                    style: AppText.body,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ensure assets/quranpages/page${pageNumber.toString().padLeft(3, '0')}.png exists",
                    textAlign: TextAlign.center,
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- SURAH PICKER SHEET (premium) ---
class _SurahPickerSheet extends StatefulWidget {
  final String currentSurah;
  final int bookmarkCount;
  final void Function(int) onSelected;

  const _SurahPickerSheet({
    required this.currentSurah,
    required this.bookmarkCount,
    required this.onSelected,
  });

  @override
  State<_SurahPickerSheet> createState() => _SurahPickerSheetState();
}

class _SurahPickerSheetState extends State<_SurahPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filtered = QuranData.surahs;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    if (query.isEmpty) {
      setState(() => _filtered = QuranData.surahs);
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _filtered = QuranData.surahs.where((s) {
        return (s['name'] as String).toLowerCase().contains(q) ||
            (s['arabic'] as String).contains(query) ||
            (s['startPage'].toString()).contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.tealFaint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.tealDark,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Surah',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                if (widget.bookmarkCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealFaint,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          size: 11,
                          color: AppColors.tealDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.bookmarkCount}',
                          style: const TextStyle(
                            color: AppColors.tealDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search Surah, Arabic, or page…',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filter('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.teal, width: 1.2),
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.dividerSoft),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No Surah found',
                      style: AppText.caption,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemExtent: 64,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemBuilder: (context, index) {
                      final surah = _filtered[index];
                      final isActive = surah['name'] == widget.currentSurah;
                      final realIndex = QuranData.surahs.indexOf(surah) + 1;
                      return _SurahPickerTile(
                        surah: surah,
                        realIndex: realIndex,
                        isActive: isActive,
                        onTap: () =>
                            widget.onSelected(surah['startPage'] as int),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SurahPickerTile extends StatelessWidget {
  final Map<String, dynamic> surah;
  final int realIndex;
  final bool isActive;
  final VoidCallback onTap;

  const _SurahPickerTile({
    required this.surah,
    required this.realIndex,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          isActive ? AppColors.tealFaint.withOpacity(0.5) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Index block
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.teal : AppColors.surface,
                  border: Border.all(
                    color: isActive
                        ? AppColors.teal
                        : AppColors.teal.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$realIndex',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.tealDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah['name'],
                      style: TextStyle(
                        color: isActive
                            ? AppColors.tealDark
                            : AppColors.textPrimary,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Page ${surah['startPage']} · ${surah['pages']}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing
              if (isActive)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                )
              else
                Text(
                  surah['arabic'],
                  style: const TextStyle(
                    color: AppColors.tealDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- BOOKMARKS SCREEN (premium) ---
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  Set<int> _bookmarks = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bookmarks = await BookmarkService.getBookmarks();
    if (mounted) {
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    }
  }

  Future<void> _remove(int pageNumber) async {
    final updated = await BookmarkService.removeBookmark(pageNumber);
    if (mounted) setState(() => _bookmarks = updated);
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text(
          'Clear all bookmarks?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            letterSpacing: -0.2,
          ),
        ),
        content: const Text(
          'This will remove all your saved bookmarks. This action cannot be undone.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await BookmarkService.clearAll();
      if (mounted) setState(() => _bookmarks = {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _bookmarks.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'My Bookmarks',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            if (sorted.isNotEmpty) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tealFaint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${sorted.length}',
                  style: const TextStyle(
                    color: AppColors.tealDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_bookmarks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 22),
              onPressed: _clearAll,
              tooltip: 'Clear all',
              color: AppColors.textPrimary,
            ),
          const SizedBox(width: 6),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.divider),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.teal,
                strokeWidth: 2.5,
              ),
            )
          : sorted.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    indent: 76,
                    endIndent: 20,
                    color: AppColors.dividerSoft,
                  ),
                  itemBuilder: (context, index) {
                    final pageNum = sorted[index];
                    final surah = QuranData.surahForPage(pageNum);

                    return _BookmarkTile(
                      pageNum: pageNum,
                      surahName: surah['name'] as String,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReadingScreen(
                              surahName: surah['name'],
                              startPage: pageNum,
                            ),
                          ),
                        );
                        _load();
                      },
                      onRemove: () => _remove(pageNum),
                    );
                  },
                ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final int pageNum;
  final String surahName;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _BookmarkTile({
    required this.pageNum,
    required this.surahName,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Page number block
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$pageNum',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: AppText.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          size: 11,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Page $pageNum',
                          style: AppText.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remove button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.bookmark_remove_outlined,
                      color: AppColors.textMuted.withOpacity(0.7),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.tealFaint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.teal.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 44,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Bookmarks Yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the bookmark icon while reading\nany page to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
