import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/screens/splash_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/auth/presentation/screens/otp_screen.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/farmers/presentation/screens/farmers_list_screen.dart';
import '../../../features/farmers/presentation/screens/farmer_profile_screen.dart';
import '../../../features/farmers/presentation/screens/register_farmer_screen.dart';
import '../../../features/farms/presentation/screens/farm_registration_screen.dart';
import '../../../features/produce/presentation/screens/produce_collection_screen.dart';
import '../../../features/produce/presentation/screens/produce_list_screen.dart';
import '../../../features/logistics/presentation/screens/logistics_screen.dart';
import '../../../features/payments/presentation/screens/payments_screen.dart';
import '../../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/customer/home/presentation/screens/customer_home_screen.dart';
import '../../../features/customer/orders/presentation/screens/orders_screen.dart';
import '../../../features/customer/chats/presentation/screens/chats_screen.dart';
import '../../../features/customer/profile/presentation/screens/customer_profile_screen.dart';
import '../../../features/customer/products/presentation/screens/product_detail_screen.dart';
import 'main_shell.dart';
import 'customer_shell.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: [
    // ─── Auth routes ───────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, _) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, _) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (_, state) => OtpScreen(
        phone: state.uri.queryParameters['phone'] ?? '',
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),

    // ─── Product detail (shared, outside shells) ───────────────────────────────
    GoRoute(
      path: '/product/:id',
      builder: (_, state) => ProductDetailScreen(
        productId: state.pathParameters['id'] ?? '',
      ),
    ),

    // ─── Agent Shell (5 tabs) ──────────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => MainShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, _) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/farmers',
              builder: (_, _) => const FarmersListScreen(),
              routes: [
                GoRoute(
                  path: 'profile/:id',
                  builder: (_, state) =>
                      FarmerProfileScreen(farmerId: state.pathParameters['id'] ?? ''),
                ),
                GoRoute(
                  path: 'register',
                  builder: (_, _) => const RegisterFarmerScreen(),
                ),
                GoRoute(
                  path: 'farms/register',
                  builder: (_, state) => FarmRegistrationScreen(
                    farmerId: state.uri.queryParameters['farmerId'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/produce',
              builder: (_, _) => const ProduceListScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (_, state) => ProduceCollectionScreen(
                    farmerId: state.uri.queryParameters['farmerId'],
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logistics',
              builder: (_, _) => const LogisticsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, _) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'payments',
                  builder: (_, _) => const PaymentsScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (_, _) => const NotificationsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ─── Customer Shell (4 tabs) ───────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => CustomerShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer/home',
              builder: (_, _) => const CustomerHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer/orders',
              builder: (_, _) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer/chats',
              builder: (_, _) => const ChatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer/profile',
              builder: (_, _) => const CustomerProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
));
