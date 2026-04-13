import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../components/app_img/app_image_widget.dart';
import '../../../../core/router/app_routes.dart';

/// Comprehensive examples screen with all project information
class ComprehensiveExamplesScreen extends StatefulWidget {
  const ComprehensiveExamplesScreen({super.key});

  @override
  State<ComprehensiveExamplesScreen> createState() =>
      _ComprehensiveExamplesScreenState();
}

class _ComprehensiveExamplesScreenState
    extends State<ComprehensiveExamplesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  // GlobalKeys for each section
  final Map<String, GlobalKey> _sectionKeys = {
    'introduction': GlobalKey(),
    'architecture': GlobalKey(),
    'coreFolder': GlobalKey(),
    'cleanArchitecture': GlobalKey(),
    'components': GlobalKey(),
    'shimmer': GlobalKey(),
    'imageWidget': GlobalKey(),
    'liveExamples': GlobalKey(),
    'router': GlobalKey(),
    'dependencyInjection': GlobalKey(),
    'createFeature': GlobalKey(),
    'localization': GlobalKey(),
    'theme': GlobalKey(),
    'keyFeatures': GlobalKey(),
    'quickReference': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 400) {
      if (!_showScrollToTop) {
        setState(() {
          _showScrollToTop = true;
        });
      }
    } else {
      if (_showScrollToTop) {
        setState(() {
          _showScrollToTop = false;
        });
      }
    }
  }

  void _scrollToSection(String sectionKey) {
    final key = _sectionKeys[sectionKey];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      Navigator.of(context).pop(); // Close drawer
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Examples'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      drawer: _buildDrawer(context, theme, colorScheme),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo at top
                Center(
                  child: AppImageWidget(
                    imagePath: 'assets/images/app_logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),

                // Introduction
                _buildSection(
                  context,
                  '📱 Project Introduction',
                  Icons.info_outline,
                  _sectionKeys['introduction']!,
                  [
                    _buildInfoCard(
                      context,
                      'Teknosys Flutter Base Architecture',
                      'A production-ready Flutter base architecture with Clean Architecture, dependency injection, and comprehensive guides.',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      'Key Features',
                      '• Clean Architecture\n• MVVM Pattern Support\n• Dependency Injection\n• Encrypted API Calls\n• Isolate Processing\n• Secure Storage\n• Theme Management',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Architecture
                _buildSection(
                  context,
                  '🏗️ Architecture Patterns',
                  Icons.architecture,
                  _sectionKeys['architecture']!,
                  [
                    _buildCodeCard(context, 'Clean Architecture Structure', '''
lib/features/your_clean_feature/
├── data/
│   ├── data_sources/      # Remote & Local
│   ├── mappers/           # Model ↔ Entity
│   ├── models/            # JSON serialization
│   └── repositories/      # Implementation
├── domain/
│   ├── entities/          # Pure Dart (no deps)
│   ├── repositories/      # Interfaces
│   └── use_cases/         # Business logic
└── presentation/
    ├── cubit/            # State management
    ├── screens/          # UI screens
    └── widgets/          # Feature widgets
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Data Flow', '''
UI (Presentation)
    ↓
Cubit (State Management)
    ↓
Use Case (Business Logic)
    ↓
Repository (Data Coordination)
    ↓
Data Source (API/Local)
'''),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context,
                      'MVVM Pattern',
                      'Also supports MVVM architecture with ViewModel pattern. Check your_mvvm_feature for examples.',
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Core Folder Usage
                _buildSection(
                  context,
                  '📂 Core Folder Usage',
                  Icons.folder,
                  _sectionKeys['coreFolder']!,
                  [
                  _buildInfoCard(
                    context,
                    'lib/core/constants/',
                    'App-wide constants: colors, sizes, strings, text styles',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/di/',
                    'Dependency Injection using GetIt. Register all dependencies here.',
                  ),
                  const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      'lib/core/network/',
                      'API client, interceptors, and network configuration',
                    ),

                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/services/',
                    'App services: encryption, connectivity, notifications',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/theme/',
                    'Theme configuration: light/dark mode, custom colors',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/router/',
                    'GoRouter configuration and navigation setup',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/extensions/',
                    'Dart extensions: BuildContext, String, DateTime, etc.',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/core/isolate/',
                    'Background API calls in isolates for better performance',
                  ),
                ]),

                const SizedBox(height: 32),

                // Clean Architecture - State & Cubit
                _buildSection(
                  context,
                  '🎯 Clean Architecture: State & Cubit',
                  Icons.code,
                  _sectionKeys['cleanArchitecture']!,
                  [
                    _buildCodeCard(context, '1. Create State (Freezed)', r'''
// your_features_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_features_state.freezed.dart';

@freezed
class YourFeaturesState with _$YourFeaturesState {
  const factory YourFeaturesState({
    @Default([]) List<YourFeatureEntity> features,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _YourFeaturesState;
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, '2. Create Cubit', '''
// your_features_cubit.dart
class YourFeaturesCubit extends Cubit<YourFeaturesState> {
  final GetYourFeaturesUseCase getFeaturesUseCase;

  YourFeaturesCubit({required this.getFeaturesUseCase})
      : super(const YourFeaturesState());

  Future<void> loadFeatures() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await getFeaturesUseCase.call();
    
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error,
      )),
      (features) => emit(state.copyWith(
        features: features,
        isLoading: false,
      )),
    );
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, '3. Use in UI', '''
// In your screen
BlocBuilder<YourFeaturesCubit, YourFeaturesState>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    if (state.errorMessage != null) {
      return Text('Error: \${state.errorMessage}');
    }
    return ListView.builder(
      itemCount: state.features.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state.features[index].title),
        );
      },
    );
  },
)
'''),
                  ],
                ),

                const SizedBox(height: 32),

                // Components
                _buildSection(
                  context,
                  '🧩 Components',
                  Icons.widgets,
                  _sectionKeys['components']!,
                  [
                  _buildInfoCard(
                    context,
                    'lib/components/widgets/',
                    'Reusable form widgets: AppButton, AppTextField, AppPasswordField, AppEmailField',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/components/app_img/',
                    'Advanced image widget: network, asset, SVG, base64, caching, shimmer',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'lib/components/shimmer/',
                    'Loading effects: list, grid, custom layouts with shimmer animation',
                  ),
                ]),

                const SizedBox(height: 32),

                // Shimmer Examples
                _buildSection(
                  context,
                  '✨ Shimmer Examples',
                  Icons.auto_awesome,
                  _sectionKeys['shimmer']!,
                  [
                    _buildExampleCard(
                      context,
                      'Single Rounded Rectangle',
                      const AppShimmer(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 12,
                        shape: ShimmerShape.roundedRectangle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Circle',
                      const AppShimmer(
                        width: 80,
                        height: 80,
                        shape: ShimmerShape.circle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Vertical List',
                      const AppShimmer(
                        width: double.infinity,
                        height: 60,
                        layout: ShimmerLayout.list,
                        itemCount: 3,
                        direction: ShimmerDirection.vertical,
                        spacing: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Grid Layout',
                      const AppShimmer(
                        layout: ShimmerLayout.grid,
                        itemCount: 4,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // AppImageWidget Guide
                _buildSection(
                  context,
                  '🖼️ AppImageWidget Guide',
                  Icons.image,
                  _sectionKeys['imageWidget']!,
                  [
                  _buildCodeCard(context, 'Basic Usage - Network Image', r'''
AppImageWidget(
  imagePath: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: 12,
  useCache: true, // Default: true
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Asset Image', r'''
AppImageWidget(
  imagePath: 'assets/images/app_logo.png',
  width: 150,
  height: 150,
  borderRadius: 12,
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Circular Image (Avatar)', r'''
AppImageWidget(
  imagePath: 'https://example.com/avatar.jpg',
  width: 100,
  height: 100,
  isCircular: true,
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'With Shimmer Loading', r'''
AppImageWidget(
  imagePath: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  showShimmer: true, // Default: true
  borderRadius: 12,
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Icon Display', r'''
AppImageWidget(
  icon: Icons.home,
  iconColor: Colors.blue,
  iconSize: 48,
  width: 80,
  height: 80,
  backgroundColor: Colors.blue[50],
  borderRadius: 12,
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Full Screen on Tap', r'''
AppImageWidget(
  imagePath: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  enableFullScreenOnTap: true,
  showAsDialog: true, // or false for route
  heroTag: 'image-123',
  showCloseButton: true,
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Error Handling', r'''
AppImageWidget(
  imagePath: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  errorWidget: Container(
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 48),
        Text('Image not available'),
      ],
    ),
  ),
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'SVG Image', r'''
// Network SVG
AppImageWidget(
  imagePath: 'https://example.com/icon.svg',
  width: 100,
  height: 100,
)

// Asset SVG
AppImageWidget(
  imagePath: 'assets/icons/icon.svg',
  width: 100,
  height: 100,
)
'''),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Supported Image Types',
                    '• Network URLs (http://, https://)\n• Asset images (assets/...)\n• SVG images (network & local)\n• File paths (/path/to/file.jpg)\n• Base64 images\n• Memory images (Uint8List)\n• Icons (IconData)',
                  ),
                ]),

                const SizedBox(height: 32),

                // Image Widget Examples
                _buildSection(
                  context,
                  '🖼️ Live Examples',
                  Icons.photo_library,
                  _sectionKeys['liveExamples']!,
                  [
                    _buildExampleCard(
                      context,
                      'Network Image',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/200/200?random=1',
                        width: 150,
                        height: 150,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Circular Image',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/200/200?random=2',
                        width: 100,
                        height: 100,
                        isCircular: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'With Shimmer Loading',
                      AppImageWidget(
                        imagePath: 'https://picsum.photos/200/200?random=3',
                        width: 150,
                        height: 150,
                        borderRadius: 12,
                        showShimmer: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Asset Image',
                      AppImageWidget(
                        imagePath: 'assets/images/app_logo.png',
                        width: 150,
                        height: 150,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExampleCard(
                      context,
                      'Icon Display',
                      AppImageWidget(
                        icon: Icons.home,
                        iconColor: colorScheme.primary,
                        iconSize: 48,
                        width: 80,
                        height: 80,
                        backgroundColor: colorScheme.primaryContainer,
                        borderRadius: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Router Details
                _buildSection(
                  context,
                  '🧭 Router: Navigation & Shell Router',
                  Icons.navigation,
                  _sectionKeys['router']!,
                  [
                    _buildCodeCard(context, 'Basic Navigation', r'''
// Push to new screen
context.push(AppRoutes.path(AppRoutes.login));

// Pop (go back)
context.pop();

// Go (replace current)
context.go(AppRoutes.path(AppRoutes.home));

// Push with parameters
context.push(
  AppRoutes.path(AppRoutes.profile),
  extra: {'userId': '123'},
);
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Add New Route', r'''
// 1. Add route constant
// app_routes.dart
static const String myRoute = 'my-route';

// 2. Add GoRoute
// app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.myRoute),
  name: AppRoutes.myRoute,
  builder: (context, state) => const MyScreen(),
),
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Shell Router for Tabs', r'''
// Create shell route with bottom navigation
ShellRoute(
  builder: (context, state, child) {
    return ScaffoldWithNavBar(child: child);
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
),

// ScaffoldWithNavBar widget
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Route with Path Parameters', r'''
// Define route with parameter
GoRoute(
  path: '/user/:id',
  builder: (context, state) {
    final userId = state.pathParameters['id'];
    return UserScreen(userId: userId);
  },
),

// Navigate with parameter
context.push('/user/123');
'''),
                  ],
                ),

                const SizedBox(height: 32),

                // Dependency Injection Guide
                _buildSection(
                  context,
                  '💉 Dependency Injection Guide',
                  Icons.science,
                  _sectionKeys['dependencyInjection']!,
                  [
                    _buildCodeCard(context, 'Register Dependencies', r'''
// In your feature injection file
void initYourFeatureInjector() {
  // Singleton (shared instance)
  sl.registerLazySingleton<YourService>(
    () => YourService(),
  );

  // Factory (new instance each time)
  sl.registerFactory<YourCubit>(
    () => YourCubit(service: sl<YourService>()),
  );

  // With dependencies
  sl.registerLazySingleton<YourRepository>(
    () => YourRepositoryImpl(
      dataSource: sl<YourDataSource>(),
      apiService: sl<ApiService>(),
    ),
  );
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Use Dependencies', r'''
// Get dependency
final service = sl<YourService>();

// In widget
BlocProvider(
  create: (context) => sl<YourCubit>(),
  child: YourScreen(),
)

// In repository
class YourRepositoryImpl {
  final YourDataSource dataSource;
  
  YourRepositoryImpl({required this.dataSource});
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Register in Main DI', r'''
// lib/core/di/dependency_injection.dart
Future<void> initDependencyInjection() async {
  await _initCore();
  initYourFeatureInjector(); // Add here
  // initAuthInjector(); // Removed auth feature
}
'''),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context,
                      'DI Registration Types',
                      '• registerLazySingleton: Shared instance, created on first access\n• registerSingleton: Created immediately\n• registerFactory: New instance every time\n• registerLazySingletonAsync: Async initialization',
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Clean Architecture Feature Creation
                _buildSection(
                  context,
                  '🚀 Create New Feature (Clean Architecture)',
                  Icons.rocket_launch,
                  _sectionKeys['createFeature']!,
                  [
                    _buildCodeCard(
                      context,
                      'Step 1: Create Folder Structure',
                      r'''
lib/features/your_clean_feature/
├── data/
│   ├── data_sources/
│   ├── mappers/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── cubit/
    ├── screens/
    └── widgets/
''',
                    ),
                    const SizedBox(height: 16),
                    _buildCodeCard(
                      context,
                      'Step 2: Create Entity (Domain)',
                      r'''
// domain/entities/your_feature_entity.dart
class YourFeatureEntity extends Equatable {
  final String id;
  final String title;
  
  const YourFeatureEntity({
    required this.id,
    required this.title,
  });
  
  @override
  List<Object?> get props => [id, title];
}
''',
                    ),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 3: Create Model (Data)', r'''
// data/models/your_feature_model.dart
class YourFeatureModel extends YourFeatureEntity {
  const YourFeatureModel({
    required super.id,
    required super.title,
  });
  
  factory YourFeatureModel.fromJson(Map<String, dynamic> json) {
    return YourFeatureModel(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(
                      context,
                      'Step 4: Create Repository Interface',
                      r'''
// domain/repositories/your_feature_repository.dart
abstract class YourFeatureRepository {
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> getFeatures();
  Future<Either<ErrorMsg, YourFeatureEntity>> createFeature(
    CreateFeatureParams params,
  );
}
''',
                    ),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 5: Create Use Case', r'''
// domain/use_cases/get_your_features_use_case.dart
class GetYourFeaturesUseCase
    implements UseCaseNoParams<List<YourFeatureEntity>> {
  final YourFeatureRepository repository;
  
  GetYourFeaturesUseCase({required this.repository});
  
  @override
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> call() async {
    return await repository.getFeatures();
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 6: Create Data Source', r'''
// data/data_sources/your_feature_remote_data_source_impl.dart
class YourFeatureRemoteDataSourceImpl
    implements YourFeatureRemoteDataSource {
  final ApiService apiService;
  
  YourFeatureRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<YourFeatureModel>> getFeatures() async {
    final response = await apiClient.get('/features');
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((json) => YourFeatureModel.fromJson(
            json as Map<String, dynamic>))
        .toList();
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(
                      context,
                      'Step 7: Setup Dependency Injection',
                      r'''
// your_feature_injection.dart
void initYourFeatureInjector() {
  // Register data source
  sl.registerLazySingleton<YourFeatureRemoteDataSource>(
    () => YourFeatureRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
    ),
  );
  
  // Register repository
  sl.registerLazySingleton<YourFeatureRepository>(
    () => YourFeatureRepositoryImpl(
      remoteDataSource: sl<YourFeatureRemoteDataSource>(),
    ),
  );
  
  // Register use case
  sl.registerLazySingleton<GetYourFeaturesUseCase>(
    () => GetYourFeaturesUseCase(
      repository: sl<YourFeatureRepository>(),
    ),
  );
  
  // Register cubit (factory)
  sl.registerFactory<YourFeaturesCubit>(
    () => YourFeaturesCubit(
      getFeaturesUseCase: sl<GetYourFeaturesUseCase>(),
    ),
  );
}

// Add to main DI file
Future<void> initDependencyInjection() async {
  await _initCore();
  initYourFeatureInjector(); // Add this
}
''',
                    ),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 8: Add Route', r'''
// app_routes.dart
static const String yourFeature = 'your-feature';

// app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.yourFeature),
  name: AppRoutes.yourFeature,
  builder: (context, state) => BlocProvider(
    create: (context) => sl<YourFeaturesCubit>(),
    child: const YourFeaturesScreen(),
  ),
),
'''),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context,
                      'Step 9: Run Build Runner',
                      'Run: flutter pub run build_runner build --delete-conflicting-outputs\n\nThis generates freezed files for state classes.',
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Localization Guide
                _buildSection(
                  context,
                  '🌍 Localization: Add New Language',
                  Icons.language,
                  _sectionKeys['localization']!,
                  [
                    _buildCodeCard(context, 'Step 1: Create ARB File', r'''
// Create lib/core/l10n/app_es.arb for Spanish
{
  "@@locale": "es",
  "appTitle": "Arquitectura de Muestra Flutter",
  "welcome": "Bienvenido",
  "login": "Iniciar sesión"
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 2: Update Service', r'''
// lib/core/l10n/app_localization_service.dart
static const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('ur'),
  Locale('es'), // Add new language
];

static String getLocaleName(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'ur':
      return 'اردو';
    case 'es':
      return 'Español'; // Add display name
    default:
      return locale.languageCode;
  }
}
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Step 3: Regenerate', r'''
// Run this command
flutter gen-l10n

// This creates app_localizations_es.dart automatically
'''),
                    const SizedBox(height: 16),
                    _buildCodeCard(
                      context,
                      'Step 4: Change Language at Runtime',
                      r'''
// Using AppCubit
context.read<AppCubit>().changeLocale(Locale('es'));

// Using AppLocalizationService
await AppLocalizationService.setLocale(Locale('es'));

// Get current locale
final locale = AppLocalizationService.getSavedLocale();
''',
                    ),
                    const SizedBox(height: 16),
                    _buildCodeCard(context, 'Using Translations in Code', r'''
// Get translations
final l10n = AppLocalizations.of(context)!;

// Use in widget
Text(l10n.welcome); // "Welcome" or "Bienvenido"

// In TextField
TextField(
  decoration: InputDecoration(
    labelText: l10n.email,
  ),
)
'''),
                  ],
                ),

                const SizedBox(height: 32),

                // Theme Guide
                _buildSection(
                  context,
                  '🎨 Theme: Change Colors',
                  Icons.palette,
                  _sectionKeys['theme']!,
                  [
                  _buildCodeCard(context, 'Step 1: Add Custom Color', r'''
// lib/core/theme/app_theme_colors.dart
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;
  final Color myCustomColor; // Add your color
  
  const AppThemeColors({
    required this.primary,
    required this.myCustomColor, // Add here
  });

  // Light theme
  static const AppThemeColors light = AppThemeColors(
    primary: Color(0xFF6750A4),
    myCustomColor: Color(0xFF4CAF50), // Light color
  );

  // Dark theme
  static const AppThemeColors dark = AppThemeColors(
    primary: Color(0xFFD0BCFF),
    myCustomColor: Color(0xFF690005), // Dark color
  );
}
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Step 2: Use Custom Color', r'''
// Get theme extension
final themeColors = Theme.of(context)
    .extension<AppThemeColors>();

// Use in widget
Container(
  color: themeColors?.myCustomColor ?? Colors.grey,
  child: Text('Hello'),
)
'''),
                  const SizedBox(height: 16),
                  _buildCodeCard(context, 'Change Theme Mode', r'''
// Using AppCubit
context.read<AppCubit>().changeTheme(ThemeMode.dark);
context.read<AppCubit>().changeTheme(ThemeMode.light);
context.read<AppCubit>().changeTheme(ThemeMode.system);

// Get current theme
final themeMode = context.read<AppCubit>().state.themeMode;
'''),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Theme Access Methods',
                    '• Theme.of(context).colorScheme.primary\n• Theme.of(context).extension<AppThemeColors>()\n• AppColors.primaryColor (constants)',
                  ),
                ]),

                const SizedBox(height: 32),

                // Key Features & Components
                _buildSection(
                  context,
                  '🔑 Key Features & Components',
                  Icons.star,
                  _sectionKeys['keyFeatures']!,
                  [
                  _buildInfoCard(
                    context,
                    '📂 Core Folder',
                    '• Constants: Colors, sizes, strings, text styles\n• Extensions: BuildContext, String, DateTime\n• Network: API client, interceptors\n• Services: Encryption, connectivity, notifications\n• Theme: Light/dark mode, custom colors\n• Router: GoRouter navigation\n• Utils: Validators, helpers',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    '🏗️ Clean Architecture',
                    '• Domain: Entities, use cases, repository interfaces\n• Data: Models, data sources, repository implementations\n• Presentation: Screens, widgets, cubit/state\n• Separation of concerns\n• Testable and maintainable',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    '💉 Dependency Injection (DI)',
                    '• GetIt for service locator pattern\n• LazySingleton for shared instances\n• Factory for new instances\n• Centralized in lib/core/di/\n• Feature-specific injection files',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    '🗄️ Local Database (Drift)',
                    '• Type-safe SQL database\n• Reactive queries\n• Migrations support\n• DAOs for data access\n• Tables defined in features\n• Auto-generated code',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    '🌍 Localization',
                    '• ARB files for translations\n• Multiple language support\n• RTL support (Urdu)\n• Runtime language switching\n• Generated localization classes\n• Easy to add new languages',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    '🔐 Encryption',
                    '• AES-256 encryption\n• Native key from platform\n• Secure storage integration\n• Encrypted API calls\n• Isolate processing\n• HMAC for integrity',
                  ),
                ]),

                const SizedBox(height: 32),

                // Quick Reference
                _buildSection(
                  context,
                  '📚 Quick Reference',
                  Icons.book,
                  _sectionKeys['quickReference']!,
                  [
                  _buildInfoCard(
                    context,
                    'Use Theme',
                    'Access via Theme.of(context)\n• colorScheme.primary\n• colorScheme.surface\n• theme.textTheme\n• theme.colorScheme.onSurface',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    'Asset Images',
                    'Use: assets/images/app_logo.png\nMake sure path is registered in pubspec.yaml',
                  ),
                ]),

                const SizedBox(height: 48),

                // Made By Footer
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.code, size: 48, color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Made by',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hasan Mehmood',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '03086121766',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For Contact',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
              // Scroll to Top Button
              if (_showScrollToTop)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.arrow_upward,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final topics = [
      {'key': 'introduction', 'title': '📱 Project Introduction', 'icon': Icons.info_outline},
      {'key': 'architecture', 'title': '🏗️ Architecture Patterns', 'icon': Icons.architecture},
      {'key': 'coreFolder', 'title': '📂 Core Folder Usage', 'icon': Icons.folder},
      {'key': 'cleanArchitecture', 'title': '🎯 Clean Architecture: State & Cubit', 'icon': Icons.code},
      {'key': 'components', 'title': '🧩 Components', 'icon': Icons.widgets},
      {'key': 'shimmer', 'title': '✨ Shimmer Examples', 'icon': Icons.auto_awesome},
      {'key': 'imageWidget', 'title': '🖼️ AppImageWidget Guide', 'icon': Icons.image},
      {'key': 'liveExamples', 'title': '🖼️ Live Examples', 'icon': Icons.photo_library},
      {'key': 'router', 'title': '🧭 Router: Navigation & Shell Router', 'icon': Icons.navigation},
      {'key': 'dependencyInjection', 'title': '💉 Dependency Injection Guide', 'icon': Icons.science},
      {'key': 'createFeature', 'title': '🚀 Create New Feature', 'icon': Icons.rocket_launch},
      {'key': 'localization', 'title': '🌍 Localization: Add New Language', 'icon': Icons.language},
      {'key': 'theme', 'title': '🎨 Theme: Change Colors', 'icon': Icons.palette},
      {'key': 'keyFeatures', 'title': '🔑 Key Features & Components', 'icon': Icons.star},
      {'key': 'quickReference', 'title': '📚 Quick Reference', 'icon': Icons.book},
    ];

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book,
                    color: colorScheme.onPrimaryContainer,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Topics',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Topics List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return ListTile(
                    leading: Icon(
                      topic['icon'] as IconData,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      topic['title'] as String,
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () => _scrollToSection(topic['key'] as String),
                    hoverColor: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  );
                },
              ),
            ),
            // Footer
            Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tap any topic to scroll',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    GlobalKey key,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(BuildContext context, String title, String code) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                code,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, String title, Widget example) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Center(child: example),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableCard(
    BuildContext context,
    String title,
    String content, {
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
