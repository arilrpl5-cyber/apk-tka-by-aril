/// Model user.
class UserModel {
  final String name;
  final String kelas;
  final int level;
  final int currentXP;
  final int maxXP;
  final int totalXP;
  final int subscriptionDays;
  final int diamonds;
  final int coins;
  final bool isTrialActive;
  final String avatarUrl;
  final int streak;
  final String lastLoginDate; // yyyy-MM-dd, '' jika belum pernah
  final int longestStreak;

  const UserModel({
    required this.name,
    required this.kelas,
    required this.level,
    required this.currentXP,
    required this.maxXP,
    this.totalXP = 0,
    required this.subscriptionDays,
    required this.diamonds,
    required this.coins,
    required this.isTrialActive,
    this.avatarUrl = '',
    this.streak = 0,
    this.lastLoginDate = '',
    this.longestStreak = 0,
  });

  UserModel copyWith({
    String? name,
    String? kelas,
    int? level,
    int? currentXP,
    int? maxXP,
    int? totalXP,
    int? subscriptionDays,
    int? diamonds,
    int? coins,
    bool? isTrialActive,
    String? avatarUrl,
    int? streak,
    String? lastLoginDate,
    int? longestStreak,
  }) {
    return UserModel(
      name: name ?? this.name,
      kelas: kelas ?? this.kelas,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      maxXP: maxXP ?? this.maxXP,
      totalXP: totalXP ?? this.totalXP,
      subscriptionDays: subscriptionDays ?? this.subscriptionDays,
      diamonds: diamonds ?? this.diamonds,
      coins: coins ?? this.coins,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      streak: streak ?? this.streak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'kelas': kelas,
        'level': level,
        'currentXP': currentXP,
        'maxXP': maxXP,
        'totalXP': totalXP,
        'subscriptionDays': subscriptionDays,
        'diamonds': diamonds,
        'coins': coins,
        'isTrialActive': isTrialActive,
        'avatarUrl': avatarUrl,
        'streak': streak,
        'lastLoginDate': lastLoginDate,
        'longestStreak': longestStreak,
      };

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        name: (j['name'] ?? 'arill_') as String,
        kelas: (j['kelas'] ?? 'Kelas XI SMK') as String,
        level: (j['level'] ?? 1) as int,
        currentXP: (j['currentXP'] ?? 0) as int,
        maxXP: (j['maxXP'] ?? 100) as int,
        totalXP: (j['totalXP'] ?? 0) as int,
        subscriptionDays: (j['subscriptionDays'] ?? 0) as int,
        diamonds: (j['diamonds'] ?? 0) as int,
        coins: (j['coins'] ?? 1300) as int,
        isTrialActive: (j['isTrialActive'] ?? false) as bool,
        avatarUrl: (j['avatarUrl'] ?? '') as String,
        streak: (j['streak'] ?? 0) as int,
        lastLoginDate: (j['lastLoginDate'] ?? '') as String,
        longestStreak: (j['longestStreak'] ?? 0) as int,
      );
}
