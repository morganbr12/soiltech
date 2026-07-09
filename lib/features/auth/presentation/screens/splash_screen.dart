import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/enums.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    final splashDuration = kDebugMode ? const Duration(milliseconds: 400) : const Duration(seconds: 3);
    _progressController = AnimationController(vsync: this, duration: splashDuration)..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final minWait = kDebugMode
        ? const Duration(milliseconds: 450)
        : const Duration(milliseconds: 3200);

    await Future.wait([
      Future.delayed(minWait),
      ref.read(authProvider.notifier).restoreSession(),
    ]);

    if (!mounted) return;

    final state = ref.read(authProvider);
    if (state.isAuthenticated) {
      final role = state.role;
      context.go(role == UserRole.agent ? '/home' : '/customer/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/soiltech_logo.jpeg',
          width: 220,
        )
            .animate()
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.easeOut,
            )
            .fadeIn(duration: 400.ms),
      ),
    );
  }
}
