import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/bank_soal_data.dart';
import '../../../data/chapter_content_data.dart';
import '../../../data/dummy_data.dart';
import '../../../providers/app_provider.dart';
import '../../bank_soal/screens/bank_soal_screen.dart';
import '../../bank_soal/screens/subject_detail_screen.dart';
import '../../materi/screens/chapter_detail_screen.dart';
import '../../materi/screens/materi_detail_screen.dart';
import '../../points/screens/point_history_screen.dart';
import '../../streak/screens/streak_screen.dart';
import '../data/bot_brain.dart';

/// Satu pesan chat (teks bisa tumbuh saat efek mengetik).
class _Msg {
  final bool isUser;
  String text;
  final DateTime time;
  List<BotAction> actions = const [];
  _Msg({required this.isUser, required this.text, required this.time});

  Map<String, dynamic> toJson() => {
        'u': isUser ? 1 : 0,
        't': text,
        'time': time.toIso8601String(),
      };

  factory _Msg.fromJson(Map<String, dynamic> j) => _Msg(
        isUser: (j['u'] ?? 0) == 1,
        text: (j['t'] ?? '') as String,
        time: DateTime.tryParse((j['time'] ?? '') as String) ??
            DateTime.now(),
      );
}

/// Layar chatbot — dipakai MIPI & Pegasus (beda persona).
class ChatbotScreen extends StatefulWidget {
  /// 'mipi' atau 'pegasus'
  final String persona;
  const ChatbotScreen({super.key, this.persona = 'mipi'});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ctrl = TextEditingController();
  final scroll = ScrollController();
  final List<_Msg> _msgs = [];
  List<String> _suggestions = [];
  bool _typing = false;
  bool _loaded = false;

  // Efek mengetik ala AI: teks bot muncul bertahap.
  Timer? _streamTimer;
  _Msg? _streamMsg;
  String _streamFull = '';
  List<BotAction> _streamActions = const [];
  List<String> _streamSuggestions = const [];

  bool get isPegasus => widget.persona == 'pegasus';
  String get botName => isPegasus ? 'Pegasus' : 'MIPI';
  String get storeKey =>
      isPegasus ? 'tka_chat_pegasus' : 'tka_chat_mipi';

  String get _greeting =>
      isPegasus
          ? 'Halo! Aku Pegasus 🚀 — perencana belajarmu.\n\nMau susun rencana hari ini? Coba: "Bank Soal Fisika", "hitung 12²−8²", atau "tips belajar".'
          : 'Halo! Aku MIPI 💡 — tanya apa saja soal pelajaran.\n\nAku bisa jelaskan materi, hitung soal (mis. "3x+5=20"), dan info tryout/streak. Mulai dari mana?';

  List<String> get _greetSuggestions =>
      const ['Bank Soal Fisika', 'Kapan tryout?', 'Hitung 12²−8²', 'Tips belajar'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _streamTimer?.cancel();
    ctrl.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getStringList(storeKey) ?? [];
      for (final s in raw.take(50)) {
        try {
          _msgs.add(_Msg.fromJson(
              Map<String, dynamic>.from(jsonDecode(s))));
        } catch (_) {}
      }
    } catch (_) {}
    if (_msgs.isEmpty) {
      _msgs.add(_Msg(
          isUser: false,
          text: _greeting,
          time: DateTime.now()));
      _suggestions = _greetSuggestions;
    } else {
      _suggestions = _greetSuggestions;
    }
    _loaded = true;
    if (mounted) setState(() {});
    _jumpBottom();
  }

  Future<void> _save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(storeKey,
          _msgs.take(50).map((e) => jsonEncode(e.toJson())).toList());
    } catch (_) {}
  }

  void _jumpBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut);
    });
  }

  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    // Kalau bot lagi mengetik, selesaikan instan dulu.
    if (_streamTimer != null) _finalizeStream();
    if (_typing) return;
    setState(() {
      _msgs.add(
          _Msg(isUser: true, text: t, time: DateTime.now()));
      _typing = true;
      _suggestions = [];
    });
    ctrl.clear();
    _save();
    _jumpBottom();

    // Bangun konteks user untuk jawaban personal.
    BotContext ctx = const BotContext();
    try {
      final app = context.read<AppProvider>();
      ctx = BotContext(
        userName: app.user.name,
        streak: app.user.streak,
        totalXP: app.user.totalXP,
        level: app.user.level,
        coins: app.user.coins,
        diamonds: app.user.diamonds,
        completedCount: app.completedCount,
      );
    } catch (_) {}

    final reply = answerBot(t, ctx);
    Future.delayed(
        Duration(milliseconds: 550 + (t.length * 8).clamp(0, 500)),
        () {
      if (!mounted) return;
      setState(() => _typing = false);
      _startStream(
          reply.text, reply.actions, reply.suggestions);
    });
  }

  /// Mulai efek mengetik: teks muncul bertahap kayak AI.
  void _startStream(String full, List<BotAction> actions,
      List<String> suggestions) {
    final msg =
        _Msg(isUser: false, text: '', time: DateTime.now());
    setState(() => _msgs.add(msg));
    _streamMsg = msg;
    _streamFull = full;
    _streamActions = actions;
    _streamSuggestions = suggestions;
    _jumpBottom();
    final step = (full.length / 45).ceil().clamp(1, 12);
    int shown = 0;
    _streamTimer?.cancel();
    _streamTimer =
        Timer.periodic(const Duration(milliseconds: 24),
            (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      shown += step;
      if (shown >= full.length) {
        _finalizeStream();
      } else {
        setState(
            () => msg.text = full.substring(0, shown));
        if (scroll.hasClients) {
          scroll.jumpTo(
              scroll.position.maxScrollExtent);
        }
      }
    });
  }

  /// Selesaikan streaming seketika (teks penuh + aksi + saran).
  void _finalizeStream() {
    _streamTimer?.cancel();
    _streamTimer = null;
    final msg = _streamMsg;
    _streamMsg = null;
    if (msg == null) return;
    setState(() {
      msg.text = _streamFull;
      msg.actions = _streamActions;
      _suggestions = _streamSuggestions.isEmpty
          ? _greetSuggestions
          : _streamSuggestions;
    });
    _streamActions = const [];
    _streamSuggestions = const [];
    _save();
    _jumpBottom();
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus riwayat chat?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;
    _streamTimer?.cancel();
    _streamTimer = null;
    _streamMsg = null;
    setState(() {
      _msgs
        ..clear()
        ..add(_Msg(
            isUser: false,
            text: _greeting,
            time: DateTime.now()));
      _suggestions = _greetSuggestions;
    });
    _save();
  }

  /// Jalankan aksi navigasi dari tombol bot.
  void _runAction(BotAction a) {
    final t = a.target;
    if (t == 'bank_soal') {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const BankSoalScreen()));
      return;
    }
    if (t.startsWith('bank_soal:')) {
      final sid = t.split(':')[1];
      final pack = BankSoalData.packs.firstWhere(
          (p) => p.subjectId == sid,
          orElse: () => BankSoalData.packs.first);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SubjectDetailScreen(pack: pack)));
      return;
    }
    if (t.startsWith('chapter:')) {
      final cid = t.substring('chapter:'.length);
      final ch = ChapterData.all.firstWhere((c) => c.id == cid,
          orElse: () => ChapterData.all.first);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ChapterDetailScreen(chapter: ch)));
      return;
    }
    if (t.startsWith('materi:')) {
      final sid = t.split(':')[1];
      final m = DummyData.materiBelajar.firstWhere(
          (e) => e.id == sid,
          orElse: () => DummyData.materiBelajar.first);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  MateriDetailScreen(material: m)));
      return;
    }
    if (t == 'streak') {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const StreakScreen()));
      return;
    }
    if (t == 'points') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const PointHistoryScreen()));
      return;
    }
    if (t == 'tryout' || t == 'live' || t == 'purchase') {
      final tab = t == 'tryout'
          ? 2
          : t == 'live'
              ? 1
              : 3;
      Navigator.of(context).popUntil((r) => r.isFirst);
      // Tunggu pop selesai baru ganti tab.
      Future.microtask(() {
        if (!mounted) return;
        try {
          context.read<AppProvider>().changeTab(tab);
        } catch (_) {}
      });
      return;
    }
  }

  String _clock(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// Render ringan ala AI: **tebal** dan `kode`.
  TextSpan _rich(String text, TextStyle base) {
    final spans = <TextSpan>[];
    final re = RegExp(r'\*\*(.+?)\*\*|`(.+?)`');
    int last = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > last) {
        spans.add(
            TextSpan(text: text.substring(last, m.start)));
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(
            text: m.group(1),
            style: const TextStyle(
                fontWeight: FontWeight.w800)));
      } else {
        spans.add(TextSpan(
            text: m.group(2),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                backgroundColor: Colors.black
                    .withValues(alpha: 0.06))));
      }
      last = m.end;
    }
    if (last < text.length) {
      spans.add(
          TextSpan(text: text.substring(last)));
    }
    return TextSpan(style: base, children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        isPegasus ? AppColors.accentPurple : AppColors.primaryBlue;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: accent,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Text(isPegasus ? '🚀' : '💡',
                  style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                      isPegasus
                          ? 'Pegasus'
                          : 'Tanya MIPI',
                      style: AppTextStyles.h3
                          .copyWith(color: Colors.white)),
                  Text(
                      _typing
                          ? 'mengetik...'
                          : 'Online • jawab instan',
                      style:
                          AppTextStyles.caption.copyWith(
                              color: Colors.white70,
                              fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _clear,
              icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: !_loaded
                ? const Center(
                    child:
                        CircularProgressIndicator())
                : ListView.builder(
                    controller: scroll,
                    padding: const EdgeInsets.all(14),
                    itemCount: _msgs.length +
                        (_typing ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (_typing && i == _msgs.length) {
                        return _typingBubble();
                      }
                      final m = _msgs[i];
                      return m.isUser
                          ? _userBubble(m)
                          : _botBubble(m, accent);
                    },
                  ),
          ),
          // Saran cepat
          if (_suggestions.isNotEmpty && !_typing)
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final s = _suggestions[i];
                  return ActionChip(
                    label: Text(s,
                        style: AppTextStyles.caption
                            .copyWith(
                                fontWeight:
                                    FontWeight.w700,
                                color: accent)),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: accent.withValues(
                            alpha: 0.4)),
                    onPressed: () => _send(s),
                  );
                },
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 4, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow:
                            AppColors.cardShadow,
                      ),
                      child: TextField(
                        controller: ctrl,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction:
                            TextInputAction.send,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText:
                              'Tulis pertanyaan / soal...',
                          hintStyle: AppTextStyles.body
                              .copyWith(
                                  color: AppColors
                                      .textSecondary,
                                  fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      boxShadow:
                          AppColors.cardShadow,
                    ),
                    child: IconButton(
                      onPressed: () =>
                          _send(ctrl.text),
                      icon: const Icon(Icons.send,
                          color: Colors.white,
                          size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userBubble(_Msg m) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin:
            const EdgeInsets.only(left: 50, bottom: 4),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(m.text,
                style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4)),
            Text(_clock(m.time),
                style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _botBubble(_Msg m, Color accent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.only(right: 40, bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text.rich(_rich(
                m.text,
                AppTextStyles.body.copyWith(
                    fontSize: 13, height: 1.5))),
            Text(_clock(m.time),
                style: AppTextStyles.caption.copyWith(
                    fontSize: 10)),
            if (m.actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: m.actions
                    .map((a) => GestureDetector(
                          onTap: () =>
                              _runAction(a),
                          child: Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal: 12,
                                    vertical: 7),
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                            child: Text(a.label,
                                style: AppTextStyles
                                    .caption
                                    .copyWith(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .w800)),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.only(right: 40, bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(0),
            const SizedBox(width: 5),
            _dot(1),
            const SizedBox(width: 5),
            _dot(2),
          ],
        ),
      ),
    );
  }

  Widget _dot(int i) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 400 + i * 150),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
      ),
      onEnd: () {
        if (mounted && _typing) setState(() {});
      },
    );
  }
}
