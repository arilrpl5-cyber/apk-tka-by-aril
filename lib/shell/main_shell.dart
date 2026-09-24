import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../features/home/screens/home_screen.dart';
import '../features/live/screens/live_screen.dart';
import '../features/tryout/screens/tryout_screen.dart';
import '../features/purchase/screens/purchase_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/streak/widgets/streak_widgets.dart';
import '../providers/app_provider.dart';

/// Shell utama: IndexedStack 5 screens + custom bottom nav.
/// Cek login harian saat dibuka → dialog streak jika hari baru.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _checkedLogin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checkedLogin) {
      _checkedLogin = true;
      Future.microtask(() => _checkDaily());
    }
  }

  Future<void> _checkDaily() async {
    if (!mounted) return;
    final app = context.read<AppProvider>();
    await app.load();
    if (!mounted) return;
    final streak = await app.checkDailyLogin();
    if (!mounted) return;
    if (streak != null && streak > 0) {
      await DailyCheckinDialog.show(context, streak);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<AppProvider>().currentIndex;
    final userName = context.watch<AppProvider>().user.name;

    final screens = [
      const HomeScreen(),
      const LiveScreen(),
      const TryoutScreen(),
      const PurchaseScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                  child: _navItem(context, 0, Icons.home_outlined,
                      Icons.home, 'Belajar', currentIndex)),
              Expanded(child: _liveNavItem(context, currentIndex)),
              Expanded(
                  child: _navItem(context, 2, Icons.assignment_outlined,
                      Icons.assignment, 'Tryout', currentIndex)),
              Expanded(child: _promoNavItem(context, currentIndex)),
              Expanded(
                  child: _navItem(context, 4, Icons.person_outline,
                      Icons.person, userName, currentIndex)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData iconOutline,
    IconData iconFilled,
    String label,
    int currentIndex,
  ) {
    final active = currentIndex == index;
    final color =
        active ? AppColors.primaryBlue : AppColors.textSecondary;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<AppProvider>().changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(active ? iconFilled : iconOutline,
              color: color, size: 23),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight:
                  active ? FontWeight.w800 : FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab Live dengan badge orange "LIVE" + dot kuning (custom, anti-overflow).
  Widget _liveNavItem(BuildContext context, int currentIndex) {
    final active = currentIndex == 1;
    final color =
        active ? AppColors.primaryBlue : AppColors.textSecondary;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<AppProvider>().changeTab(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                  active ? Icons.live_tv : Icons.live_tv_outlined,
                  color: color,
                  size: 23),
              Positioned(
                top: -7,
                right: -26,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.liveOrange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.accentYellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text('LIVE',
                          style:
                              AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text('Live',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 11,
                fontWeight:
                    active ? FontWeight.w800 : FontWeight.w400,
              )),
        ],
      ),
    );
  }

  /// Tab Pembelian dengan badge orange "PROMO!" (custom, anti-overflow).
  Widget _promoNavItem(BuildContext context, int currentIndex) {
    final active = currentIndex == 3;
    final color =
        active ? AppColors.primaryBlue : AppColors.textSecondary;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<AppProvider>().changeTab(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                  active
                      ? Icons.shopping_bag
                      : Icons.shopping_bag_outlined,
                  color: color,
                  size: 23),
              Positioned(
                top: -8,
                right: -28,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.liveOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('PROMO!',
                      style:
                          AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text('Pembelian',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 11,
                fontWeight:
                    active ? FontWeight.w800 : FontWeight.w400,
              )),
        ],
      ),
    );
  }
}
