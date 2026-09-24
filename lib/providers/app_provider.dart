import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';

/// Hasil penambahan XP (untuk tampilkan dialog naik level).
class XpResult {
  final bool leveledUp;
  final int newLevel;
  const XpResult({required this.leveledUp, required this.newLevel});
}

/// State management utama: user + poin + streak + riwayat + persistence.
class AppProvider extends ChangeNotifier {
  int _currentIndex = 0;
  UserModel _user = DummyData.user;
  int _promoIndex = 0;

  final List<PointEvent> _history = [];
  final Set<String> _completedChapters = {};
  final Set<String> _bookmarks = {}; // chapterId yg dibookmark
  final Set<String> _downloads = {}; // chapterId yg didownload
  bool _loaded = false;
  String? _pendingLevelUp; // pesan level up yg belum ditampilkan

  int get currentIndex => _currentIndex;
  UserModel get user => _user;
  int get promoIndex => _promoIndex;
  List<PointEvent> get history => List.unmodifiable(_history);
  Set<String> get completedChapters =>
      Set.unmodifiable(_completedChapters);
  Set<String> get bookmarks => Set.unmodifiable(_bookmarks);
  Set<String> get downloads => Set.unmodifiable(_downloads);
  bool get isLoaded => _loaded;
  int get completedCount => _completedChapters.length;

  /// Bonus koin harian berdasarkan streak (hari ke-1..7 berulang).
  static int dailyBonusFor(int streakDay) {
    const table = [10, 15, 20, 25, 30, 40, 60];
    if (streakDay <= 0) return 10;
    return table[(streakDay - 1) % 7];
  }

  // ============ NAVIGASI ============
  void changeTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
    save();
  }

  void setPromoIndex(int index) {
    _promoIndex = index;
    notifyListeners();
  }

  void activateTrial() {
    _user = _user.copyWith(isTrialActive: true, subscriptionDays: 7);
    _addHistory('Aktivasi Free Trial', 0, 0);
    notifyListeners();
    save();
  }

  // ============ POIN / LEVEL ============
  /// Tambah XP, otomatis naik level jika cukup.
  /// maxXP level berikutnya = 100 + (level-1)*50.
  XpResult addXP(int xp, {String source = 'Belajar'}) {
    if (xp <= 0) return XpResult(leveledUp: false, newLevel: _user.level);
    int level = _user.level;
    int cur = _user.currentXP + xp;
    int max = _user.maxXP;
    bool up = false;
    while (cur >= max) {
      cur -= max;
      level++;
      max = 100 + (level - 1) * 50;
      up = true;
    }
    _user = _user.copyWith(
      level: level,
      currentXP: cur,
      maxXP: max,
      totalXP: _user.totalXP + xp,
    );
    if (up) {
      // Bonus naik level: diamond +1 tiap 3 level.
      final bonusDiamond = (level % 3 == 0) ? 1 : 0;
      if (bonusDiamond > 0) {
        _user =
            _user.copyWith(diamonds: _user.diamonds + bonusDiamond);
      }
      _pendingLevelUp =
          'Naik ke Level $level! 🎉${bonusDiamond > 0 ? ' Bonus 💎$bonusDiamond' : ''}';
    }
    if (source.isNotEmpty) _addHistory(source, xp, 0);
    notifyListeners();
    save();
    return XpResult(leveledUp: up, newLevel: level);
  }

  void addCoins(int coins, {String source = 'Misi'}) {
    if (coins == 0) return;
    _user = _user.copyWith(coins: _user.coins + coins);
    if (source.isNotEmpty) _addHistory(source, 0, coins);
    notifyListeners();
    save();
  }

  /// Gabungan XP + koin sekali catat (dipakai quiz & bab selesai).
  XpResult earn(
      {required int xp, int coins = 0, required String source}) {
    _addHistory(source, xp, coins);
    XpResult r = const XpResult(leveledUp: false, newLevel: 1);
    if (xp > 0) {
      // addXP juga mencatat history; hindari dobel dengan flag internal.
      _history.removeLast();
      r = addXP(xp, source: '');
      _addHistory(source, xp, 0);
    }
    if (coins != 0) {
      _history.removeLast();
      _user = _user.copyWith(coins: _user.coins + coins);
      _addHistory(source, xp, coins);
      notifyListeners();
      save();
    }
    return r;
  }

  /// Ambil & hapus pesan level-up pending (untuk dialog sekali saja).
  String? takePendingLevelUp() {
    final m = _pendingLevelUp;
    _pendingLevelUp = null;
    return m;
  }

  // ============ BAB SELESAI ============
  bool isChapterDone(String chapterId) =>
      _completedChapters.contains(chapterId);

  /// Tandai bab selesai → dapat XP + koin (sekali saja per bab).
  XpResult completeChapter(String chapterId, String title,
      {int xp = 20, int coins = 10}) {
    if (_completedChapters.contains(chapterId)) {
      return XpResult(leveledUp: false, newLevel: _user.level);
    }
    _completedChapters.add(chapterId);
    final r = earn(xp: xp, coins: coins, source: 'Selesai: $title');
    notifyListeners();
    save();
    return r;
  }

  // ============ BOOKMARK & DOWNLOAD ============
  bool isBookmarked(String id) => _bookmarks.contains(id);
  void toggleBookmark(String id) {
    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
    } else {
      _bookmarks.add(id);
    }
    notifyListeners();
    save();
  }

  bool isDownloaded(String id) => _downloads.contains(id);
  void toggleDownload(String id) {
    if (_downloads.contains(id)) {
      _downloads.remove(id);
    } else {
      _downloads.add(id);
    }
    notifyListeners();
    save();
  }

  // ============ STREAK HARIAN ============
  static String _todayKey() {
    final n = DateTime.now();
    return '${n.year.toString().padLeft(4, '0')}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  /// Dipanggil saat aplikasi dibuka.
  /// Return: jumlah streak BARU jika hari baru (untuk dialog), null jika sudah login hari ini.
  Future<int?> checkDailyLogin() async {
    await _ensureLoaded();
    final today = _todayKey();
    if (_user.lastLoginDate == today) return null;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yKey =
        '${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    int streak = _user.streak;
    if (_user.lastLoginDate == yKey) {
      streak += 1;
    } else if (_user.lastLoginDate.isEmpty && streak == 0) {
      streak = 1;
    } else if (_user.lastLoginDate != today) {
      streak = 1; // putus → ulang dari 1
    }
    final longest =
        streak > _user.longestStreak ? streak : _user.longestStreak;
    final bonus = dailyBonusFor(streak);
    _user = _user.copyWith(
      streak: streak,
      lastLoginDate: today,
      longestStreak: longest,
      coins: _user.coins + bonus,
    );
    _addHistory('Login harian (streak $streak hari)', 5, bonus);
    notifyListeners();
    await save();
    return streak;
  }

  // ============ PERSISTENCE ============
  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    await load();
  }

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString('tka_user');
      if (raw != null) {
        _user = UserModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(raw)));
      }
      final hRaw = p.getStringList('tka_history') ?? [];
      _history.clear();
      for (final s in hRaw.take(100)) {
        try {
          _history.add(PointEvent.fromJson(
              Map<String, dynamic>.from(jsonDecode(s))));
        } catch (_) {}
      }
      _completedChapters
        ..clear()
        ..addAll(p.getStringList('tka_chapters') ?? []);
      _bookmarks
        ..clear()
        ..addAll(p.getStringList('tka_bookmarks') ?? []);
      _downloads
        ..clear()
        ..addAll(p.getStringList('tka_downloads') ?? []);
    } catch (_) {
      // abaikan, pakai default
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('tka_user', jsonEncode(_user.toJson()));
      await p.setStringList('tka_history',
          _history.take(100).map((e) => jsonEncode(e.toJson())).toList());
      await p.setStringList(
          'tka_chapters', _completedChapters.toList());
      await p.setStringList(
          'tka_bookmarks', _bookmarks.toList());
      await p.setStringList(
          'tka_downloads', _downloads.toList());
    } catch (_) {}
  }

  Future<void> resetAll() async {
    _user = DummyData.user;
    _history.clear();
    _completedChapters.clear();
    _bookmarks.clear();
    _downloads.clear();
    _pendingLevelUp = null;
    notifyListeners();
    await save();
  }

  void _addHistory(String title, int xp, int coins) {
    _history.insert(
        0, PointEvent(title: title, xp: xp, coins: coins, date: DateTime.now()));
    if (_history.length > 100) {
      _history.removeRange(100, _history.length);
    }
  }
}
