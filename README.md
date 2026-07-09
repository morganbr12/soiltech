# SoilTech LBC — Mobile Frontend

A Flutter mobile application for **SoilTech Licensed Buying Company** operations. Two distinct user experiences live in one codebase: an **Agent** app for field operations (farmer registration, produce collection, logistics, payments) and a **Customer** app for browsing and ordering fresh farm produce.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [Navigation & Routing](#navigation--routing)
- [Feature Areas](#feature-areas)
  - [Authentication](#authentication)
  - [Agent Features](#agent-features)
  - [Customer Features](#customer-features)
- [State Management](#state-management)
- [Data Models](#data-models)
- [Network Layer](#network-layer)
- [Design System](#design-system)
- [Shared Widgets](#shared-widgets)

---

## Tech Stack

| Concern | Package | Version |
|---|---|---|
| State management | flutter_riverpod | ^2.6.1 |
| Navigation | go_router | ^14.8.1 |
| HTTP client | dio + retrofit | ^5.8 / ^4.9 |
| Local storage | hive_ce + hive_ce_flutter | ^2.10 / ^2.2 |
| Responsive UI | flutter_screenutil | ^5.9.3 |
| Typography | google_fonts (Inter) | ^6.2.1 |
| Charts | fl_chart | ^0.69.0 |
| Animations | flutter_animate | ^4.5.2 |
| Image caching | cached_network_image | ^3.4.1 |
| Shimmer loading | shimmer | ^3.0.0 |
| GPS | geolocator | ^13.0.2 |
| Connectivity | connectivity_plus | ^6.1.4 |
| Code generation | freezed + json_serializable | ^4.0 / ^6.14 |
| Logging | logger | ^2.5.0 |

**Backend base URL:** `https://soiltech-backend-production.up.railway.app/v1`

---

## Project Structure

```
lib/
├── main.dart                        # Entry point — Hive init, orientation lock
├── app/
│   ├── app.dart                     # Root widget (ScreenUtil, theme, router)
│   └── core/
│       ├── constants/app_constants.dart
│       ├── network/
│       │   ├── api_constants.dart   # All endpoint strings
│       │   ├── api_response.dart    # Generic ApiResponse<T> wrapper
│       │   ├── dio_provider.dart    # Dio + interceptors
│       │   └── interceptors/
│       │       ├── auth_interceptor.dart    # Token injection & 401 refresh
│       │       └── logging_interceptor.dart # Debug HTTP logs (appLogger)
│       ├── router/
│       │   ├── app_router.dart      # Full route table
│       │   ├── main_shell.dart      # Agent 5-tab shell
│       │   └── customer_shell.dart  # Customer 4-tab shell
│       ├── storage/auth_storage.dart  # Hive session persistence
│       ├── theme/
│       │   ├── app_colors.dart      # Full colour palette
│       │   └── app_theme.dart       # M3 light + dark themes
│       └── utils/app_logger.dart    # Shared Logger instance
│
├── features/
│   ├── auth/                        # Login, register, OTP, forgot-password
│   ├── dashboard/                   # Agent home dashboard
│   ├── farmers/                     # Farmer list, profile, registration
│   ├── farms/                       # Farm registration
│   ├── produce/                     # Produce collection & records
│   ├── logistics/                   # Pickup requests & delivery tracking
│   ├── payments/                    # Farmer payment records
│   ├── notifications/               # In-app notifications
│   ├── profile/                     # Agent account & settings
│   └── customer/
│       ├── chats/                   # Customer chat with agents
│       ├── home/                    # Browse products, deals, categories
│       ├── orders/                  # Place & track orders
│       ├── products/                # Product detail & ordering
│       └── profile/                 # Customer account & delivery address
│
└── shared/
    ├── models/                      # Freezed data models + enums
    └── widgets/                     # Reusable UI components
```

Each feature follows the same internal layout:

```
feature/
├── data/
│   ├── *_api.dart          # Retrofit interface
│   └── *_repository.dart   # Business logic + provider
└── presentation/
    ├── providers/           # Riverpod providers
    ├── screens/             # Full-page widgets
    └── widgets/             # Feature-local components
```

---

## Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Regenerate code (after model changes)
dart run build_runner build

# 3. Run
flutter run
```

Minimum SDK: Flutter 3.12 / Dart 3.x. Tested on iOS and Android.

---

## Architecture

- **Feature-first** folder structure — each feature is self-contained with its own data, providers, and screens.
- **Clean layers**: Retrofit API → Repository → Riverpod Provider → Screen.
- **Riverpod** for all state. No `setState` in screens except for local ephemeral UI state (tab controllers, form fields, animations).
- **GoRouter** with `StatefulShellRoute` for the two tabbed shells. Route guards redirect unauthenticated users to `/login`.
- **Freezed** models for immutability and `fromJson`/`toJson` codegen.
- **Hive CE** stores the auth session locally so the app restores automatically on relaunch.

---

## Navigation & Routing

### Authentication routes

| Path | Screen |
|---|---|
| `/splash` | SplashScreen — restores session, redirects |
| `/login` | LoginScreen |
| `/register` | RegisterScreen (3-step: personal info → account type → confirm) |
| `/otp` | OtpScreen |
| `/forgot-password` | ForgotPasswordScreen |

### Shared route (both roles)

| Path | Screen |
|---|---|
| `/product/:id` | ProductDetailScreen |

### Agent shell — 5 tabs

| Tab | Root path | Sub-routes |
|---|---|---|
| Home | `/home` | — |
| Farmers | `/farmers` | `/farmers/profile/:id`, `/farmers/register`, `/farmers/farms/register?farmerId=` |
| Produce | `/produce` | `/produce/create?farmerId=` |
| Logistics | `/logistics` | — |
| Profile | `/profile` | `/profile/payments`, `/profile/notifications` |

### Customer shell — 4 tabs

| Tab | Root path |
|---|---|
| Home | `/customer/home` |
| Orders | `/customer/orders` |
| Chats | `/customer/chats` |
| Profile | `/customer/profile` |

---

## Feature Areas

### Authentication

**Screens:** `splash_screen`, `login_screen`, `register_screen`, `otp_screen`, `forgot_password_screen`

- **Login** — phone + password. Calls `POST /auth/login`.
- **Register** — 3-step flow:
  1. Personal info (name, phone, email, password)
  2. Account type (individual / restaurant / retail shop / market trader / processor / exporter) + delivery location (GPS or manual address)
  3. Terms acceptance
  - Calls `POST /auth/register` with `role: customer`, `accountType`, and optional `address`.
- **Session restore** — `SplashScreen` calls `AuthNotifier.restoreSession()` which reads the Hive-persisted token. Routes to the correct shell based on `role`.
- **Token refresh** — `AuthInterceptor` automatically retries 401 responses with a fresh token from `POST /auth/refresh`.

---

### Agent Features

#### Dashboard (`/home`)

- 8 real-time stat cards: today's collections, farmers visited, pending uploads, offline records, today's weight (kg), weekly weight, monthly revenue (GHS), active pickups.
- Data source: `DashboardStats` model fetched from the agent's context.

#### Farmers (`/farmers`)

**Screens:** `farmers_list_screen`, `farmer_profile_screen`, `register_farmer_screen`

- **List** — Searchable, filterable farmer roster with sync status badges.
- **Profile** — Full farmer card: contact info, ID, region, registered farms, produce history, payment summary.
- **Register** — Onboards a new farmer: name, phone, national ID, region, community.

#### Farms

**Screen:** `farm_registration_screen`

- Registers a farm for an existing farmer: GPS coordinates or manual location, size (acres), crop types, harvest period, community name, optional photos.

#### Produce Collection (`/produce`)

**Screens:** `produce_list_screen`, `produce_collection_screen`

- **List** — All collection records with filter by status (draft / submitted / approved / rejected) and crop type.
- **Collection form** — Records a pickup: farmer, crop type, weight (kg), number of bags, moisture %, quality grade (A/B/C/Reject), geo-tagged location, photos (up to 5). Supports offline draft saving.

#### Logistics (`/logistics`)

**Screen:** `logistics_screen`

- Lists pickup requests with statuses: pending → assigned → in-transit → delivered.
- Shows driver info (name, vehicle) when assigned.
- Expandable card with full timeline.

#### Payments (`/profile/payments`)

**Screen:** `payments_screen`

- Lists farmer payment records: amount due, due date, payment method, transaction reference, status (pending / processing / paid / failed).

#### Agent Profile (`/profile`)

**Screen:** `profile_screen`

- Agent code, region, performance metrics (farmers onboarded, produce collected, collection score).
- Links to payments, notifications, app settings.

#### Notifications (`/profile/notifications`)

**Screen:** `notifications_screen`

- In-app notification feed: announcements, alerts, task reminders, payment notices, sync updates. Each type has a distinct icon and colour.

---

### Customer Features

#### Home (`/customer/home`)

**Screen:** `customer_home_screen`

- **Greeting banner** with customer name and location.
- **Category chips** — horizontal scroll; selecting a category filters the product grid. Powered by `GET /product-categories`.
- **Deal products** — horizontally scrollable cards from `GET /products/deals`.
- **Featured products** — hero cards from `GET /products/featured`.
- **All / Popular products** — paginated grid, filterable by selected category.

#### Product Detail (`/product/:id`)

**Screen:** `product_detail_screen`

- Image gallery (PageView with dot indicators).
- Price, unit, rating, stock level, distance, freshness label.
- Farmer/seller card with chat button.
- Quantity selector.
- Reviews section.
- Related products horizontal list.
- **"Buy Now"** button opens a bottom sheet:
  - Delivery address field (required)
  - Notes field (optional)
  - Calls `POST /orders` via `PlaceOrderNotifier`
  - Success/error snackbar feedback
- **"Add to Cart"** — local feedback snackbar (cart not yet persisted).

#### Orders (`/customer/orders`)

**Screen:** `orders_screen`

- **4 tabs:** Active (confirmed / processing / shipped / active), Pending, Completed, Cancelled.
- Orders fetched from `GET /orders` via `allOrdersProvider`.
- Pull-to-refresh + manual refresh button in AppBar.
- **Order card** shows: short order ID (first 8 chars), date, status badge, item count, delivery address, total (GHS).
- **Timeline expansion** — taps to expand; fetches full order from `GET /orders/:id` via `orderDetailProvider` if timeline not already loaded. Shows status steps with timestamps.

#### Chats (`/customer/chats`)

**Screen:** `chats_screen`

- Conversation list with other user avatar, name, last message, unread count badge, online indicator.

#### Customer Profile (`/customer/profile`)

**Screen:** `customer_profile_screen`

- Fetched live from `GET /customer/profile` via `customerProfileProvider`.
- **Header** — avatar (initials fallback when no photo), full name.
- **Personal Information** — full name, phone, email (from auth state), member-since date.
- **Delivery Address** — address string from API; "Add New" button in section header.
- **Account section** — order history, wishlist, payment methods, notifications, dark mode toggle.
- **Support section** — help centre, live chat, privacy policy, about.
- **Sign Out** — confirmation dialog; calls `AuthNotifier.logout()` then navigates to `/login`.

---

## State Management

All global state is managed with **Riverpod**. Key providers:

### Auth

```dart
// AuthNotifier with status: initial | authenticating | authenticated | unauthenticated | error
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(...);
final isAuthenticatedProvider = Provider<bool>(...);
final userRoleProvider = Provider<UserRole?>(...);
```

### Customer Home

```dart
final customerProfileProvider       = FutureProvider.autoDispose<CustomerProfileData>(...);
final productCategoriesProvider     = FutureProvider.autoDispose<List<ProductCategoryModel>>(...);
final featuredProductsProvider      = FutureProvider.autoDispose<List<Product>>(...);
final dealProductsProvider          = FutureProvider.autoDispose<List<Product>>(...);
final recentProductsProvider        = FutureProvider.autoDispose<List<Product>>(...);
final selectedCategoryIdProvider    = StateProvider<String?>(...);
final popularProductsProvider       = FutureProvider.autoDispose.family<List<Product>, String?>(...);
```

### Orders

```dart
final allOrdersProvider    = FutureProvider<List<CustomerOrder>>(...);
final orderDetailProvider  = FutureProvider.family<CustomerOrder, String>(...);
final placeOrderProvider   = StateNotifierProvider.autoDispose<PlaceOrderNotifier, AsyncValue<CustomerOrder?>>(...);
```

`placeOrderProvider.notifier.placeOrder(deliveryAddress, productId, quantity, notes)` — submits the order and automatically invalidates `allOrdersProvider` on success.

### Customer Profile

```dart
final customerProfileProvider = FutureProvider<CustomerProfileData>(...);
```

---

## Data Models

All models are **immutable Freezed classes** with JSON serialization. Generated files (`.freezed.dart`, `.g.dart`) should not be edited manually — run `dart run build_runner build` after any model change.

### Authentication

| Model | Key fields |
|---|---|
| `AuthSession` | accessToken, refreshToken, userId, email, role, fullName, phone, address, profileImageUrl |
| `AuthState` | status, userId, email, fullName, phone, profileImageUrl, role, error |

### Agent

| Model | Key fields |
|---|---|
| `AgentProfile` | id, name, phone, email, agentCode, region, metrics (farmers, produce, score) |
| `FarmerModel` | id, name, phone, nationalId, region, status, farms, crops, totalCollected, syncStatus |
| `FarmModel` | id, farmerId, name, lat/lng, sizeAcres, cropTypes, region, district, community, photoUrls, syncStatus |
| `ProduceRecord` | id, farmerId, cropType, weightKg, qualityGrade, status, collectionDate, photoUrls, pricePerKg; computed totalValue |
| `PickupRequest` | id, produceRecordId, farmerId, cropType, weightKg, location, status, driverName/phone/vehicle |
| `PaymentRecord` | id, farmerId, amount, status, dueDate, paidDate, paymentMethod, transactionRef |
| `DashboardStats` | todayCollections, todayFarmers, pendingUploads, offlineRecords, todayWeight, weeklyWeight, monthlyRevenue, activePickups |

### Customer

| Model | Key fields |
|---|---|
| `CustomerProfileData` | id, userId, fullName, phone, address, profileImageUrl, createdAt, updatedAt |
| `CustomerProfile` | id, fullName, phone, email, accountType, profileImageUrl, addresses, totalOrders |
| `DeliveryAddress` | id, label, fullAddress, city, region, isDefault, lat, lng |
| `Product` | id, name, pricePerUnit, unit, category, farmerName, lbcName, rating, isFeatured, isOnDeal, discountPercent |
| `ProductReview` | id, reviewerName, rating, comment, reviewerAvatar |
| `CustomerOrder` | id, customerId, status, totalAmount, deliveryAddress, notes, createdAt, updatedAt, items, timeline, itemCount |
| `OrderItem` | id, productId, quantity, unitPrice, subtotal |
| `OrderTimeline` | id, status, note, createdAt, createdBy |

### Shared

| Model | Key fields |
|---|---|
| `AppNotification` | id, title, body, type, timestamp, isRead |
| `ChatConversation` | id, otherUserId, otherUserName, avatar, isOnline, lastMessage, unreadCount |
| `ChatMessage` | id, senderId, content, timestamp, type, isRead, imageUrl |

### Enums (`enums.dart`)

| Enum | Values |
|---|---|
| `OrderStatus` | pending, confirmed, processing, shipped, active, delivered, cancelled |
| `CustomerAccountType` | individual, restaurant, retailShop, marketTrader, processor, exporter |
| `ProductCategory` | tomatoes, pepper, onion, cabbage, carrot, lettuce, gardenEggs, okra, other |
| `UserRole` | agent, customer |
| `FarmerStatus` | active, inactive, suspended |
| `CollectionStatus` | draft, submitted, approved, rejected |
| `PaymentStatus` | pending, processing, paid, failed |
| `LogisticsStatus` | pending, assigned, inTransit, delivered |
| `SyncStatus` | synced, pending, failed |
| `NotificationType` | announcement, alert, task, payment, sync |
| `MessageType` | text, image, deliveryUpdate |

---

## Network Layer

### Endpoints

| Group | Endpoint |
|---|---|
| Auth | `POST /auth/login`, `POST /auth/register`, `POST /auth/logout`, `POST /auth/refresh`, `POST /auth/forgot-password`, `POST /auth/verify-otp` |
| Agent | `GET /agent/profile` |
| Farmers | `GET/POST /farmers`, `GET /farmers/:id`, `GET /farmers/:farmerId/farms` |
| Produce | `GET/POST /produce`, `GET /produce/:id` |
| Logistics | `GET/POST /logistics`, `GET /logistics/:id` |
| Payments | `GET/POST /payments`, `GET /payments/:id` |
| Products | `GET /products`, `GET /products/:id`, `GET /products/featured`, `GET /products/deals` |
| Orders | `GET/POST /orders`, `GET /orders/:id`, `PATCH /orders/:id/cancel`, `PATCH /orders/:id/status` |
| Customer | `GET /customer/profile`, `GET /customer/addresses` |
| Categories | `GET /product-categories` |
| Reviews | `GET /products/:id/reviews` |

### Interceptors

- **`AuthInterceptor`** — injects `Authorization: Bearer <token>` on every request. On 401, fetches a new token via `POST /auth/refresh` and retries the original request once.
- **`LoggingInterceptor`** (debug mode only) — logs request method/path/body and response status using `appLogger`. Errors include status code, type, and response body.

### Response shape

```json
{
  "success": true,
  "status_code": 200,
  "message": "...",
  "data": { ... },
  "meta": { "page": 1, "perPage": 20, "total": 42, "totalPages": 3 }
}
```

Parsed by the generic `ApiResponse<T>` Freezed class.

---

## Design System

### Colour Palette

| Token | Value | Usage |
|---|---|---|
| `primary` | #2D6A4F | Brand green, CTAs, active states |
| `primaryDark` | #1B4332 | AppBar, hero gradient start |
| `primaryLight` | #52B788 | Icons, secondary accents |
| `primaryContainer` | #B7E4C7 | Chip backgrounds, icon containers |
| `tertiary` | #F4A261 | Warm orange accent |
| `success` | #40916C | Success states |
| `error` | #BA1A1A | Error states |
| `warning` | #E9C46A | Warning states |
| `backgroundDark` | #0C1610 | Dark mode scaffold |
| `cardDark` | #192B1C | Dark mode cards |

### Typography

Google Fonts **Inter** across all text styles. Configured via `AppTheme` for both light and dark modes.

### Component defaults

| Component | Style |
|---|---|
| Cards | 20px radius, elevation 0, white / `cardDark` background |
| Buttons | 14px radius, 54px height, `AppButton` widget |
| Inputs | 14px radius, filled background, 2px primary border on focus |
| Bottom navigation | Material 3 `NavigationBar` (agent) / custom pill nav (customer) |
| Dialogs | 24px radius, `AlertDialog` |
| Sliver headers | `heroGradient` (primaryDark → primaryLight) |

---

## Shared Widgets

| Widget | File | Purpose |
|---|---|---|
| `AppButton` | `shared/widgets/app_button.dart` | Primary, secondary, outline, loading variants |
| `AppTextField` | `shared/widgets/app_text_field.dart` | Labelled input with validation and icons |
| `ProductCard` | `shared/widgets/product_card.dart` | Image + name + price + rating grid card |
| `MetricCard` | `shared/widgets/metric_card.dart` | Dashboard stat tile (value + label) |
| `SectionHeader` | `shared/widgets/section_header.dart` | Title row with optional action button |
| `RatingWidget` | `shared/widgets/rating_widget.dart` | Star rating (compact and full variants) |
| `ShimmerLoader` | `shared/widgets/shimmer_loader.dart` | Skeleton loading animation |
| `StatusBadge` | `shared/widgets/status_badge.dart` | Coloured pill for enum statuses |
| `OfflineBanner` | `shared/widgets/offline_banner.dart` | Top banner when `connectivity_plus` detects no network |
