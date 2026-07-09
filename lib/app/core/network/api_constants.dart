class ApiConstants {
  ApiConstants._();

  // Physical device → use Mac's local IP. Simulator → use localhost.
  static const String baseUrl = 'https://soiltech-backend-production.up.railway.app/v1';

  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';

  // ─── Agent Profile ─────────────────────────────────────────────────────────
  static const String agentProfile = '/agent/profile';

  // ─── Farmers ───────────────────────────────────────────────────────────────
  static const String farmers = '/farmers';
  static const String farmerById = '/farmers/{id}';
  static const String farmsByFarmer = '/farmers/{farmerId}/farms';

  // ─── Produce ───────────────────────────────────────────────────────────────
  static const String produce = '/produce';
  static const String produceById = '/produce/{id}';

  // ─── Logistics ─────────────────────────────────────────────────────────────
  static const String logistics = '/logistics';
  static const String logisticsById = '/logistics/{id}';

  // ─── Payments ──────────────────────────────────────────────────────────────
  static const String payments = '/payments';
  static const String paymentById = '/payments/{id}';

  // ─── Customer — Products ───────────────────────────────────────────────────
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String featuredProducts = '/products/featured';
  static const String dealProducts = '/products/deals';

  // ─── Customer — Orders ─────────────────────────────────────────────────────
  static const String orders = '/orders';
  static const String orderById = '/orders/{id}';
  static const String cancelOrder = '/orders/{id}/cancel';

  // ─── Customer — Profile ────────────────────────────────────────────────────
  static const String customerProfile = '/customer/me';
  static const String customerAddresses = '/customer/addresses';

  // ─── Product Categories ────────────────────────────────────────────────────
  static const String productCategories = '/product-categories';

  // ─── Product Reviews ──────────────────────────────────────────────────────
  static const String productReviews = '/products/{id}/reviews';
}
