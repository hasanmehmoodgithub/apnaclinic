# 🚀 Feature Creation Guide

Complete guide for creating new features using Clean Architecture in your Flutter app.

---

## 📖 Overview

This guide shows you how to create a new feature with:
- ✅ **GET API** - Fetch data from server
- ✅ **POST API** - Create data on server
- ✅ **Local Fallback** - Use local data when no internet
- ✅ **Clean Architecture** - Proper separation of layers

---

## 📁 Feature Folder Structure

```
lib/features/
└── your_feature_name/          # Replace with your feature name (e.g., products, users, orders)
    ├── data/
    │   ├── data_sources/
    │   │   ├── your_feature_remote_data_source.dart          # API interface
    │   │   ├── your_feature_remote_data_source_impl.dart     # API implementation
    │   │   ├── your_feature_local_data_source.dart           # Local interface
    │   │   └── your_feature_local_data_source_impl.dart     # Local implementation (SharedPreferences)
    │   ├── mappers/
    │   │   └── your_feature_mapper.dart                       # Model ↔ Entity converter
    │   ├── models/
    │   │   └── your_feature_model.dart                        # Data model (JSON serialization)
    │   └── repositories/
    │       └── your_feature_repository_impl.dart               # Repository implementation
    ├── domain/
    │   ├── entities/
    │   │   └── your_feature_entity.dart                      # Domain entity (pure Dart)
    │   ├── repositories/
    │   │   └── your_feature_repository.dart                   # Repository interface
    │   └── use_cases/
    │       ├── get_your_features_use_case.dart               # GET use case
    │       ├── create_your_feature_use_case.dart             # POST use case
    │       └── create_feature_params.dart                     # POST parameters
    ├── presentation/
    │   ├── cubit/
    │   │   ├── your_features_cubit.dart                      # State management
    │   │   ├── your_features_state.dart                       # State class
    │   │   └── your_features_state.freezed.dart              # Generated (run build_runner)
    │   ├── pages/
    │   │   └── your_features_page.dart                       # UI page
    │   └── widgets/
    │       └── your_feature_widget.dart                       # Feature widgets
    └── your_feature_injection.dart                            # Dependency injection
```

---

## 🎯 Step-by-Step Guide

### Step 1: Create Feature Folder

```bash
mkdir -p lib/features/your_feature_name/{data/{data_sources,mappers,models,repositories},domain/{entities,repositories,use_cases},presentation/{cubit,pages,widgets}}
```

**Example:** For a "products" feature:
```bash
mkdir -p lib/features/products/{data/{data_sources,mappers,models,repositories},domain/{entities,repositories,use_cases},presentation/{cubit,pages,widgets}}
```

---

### Step 2: Create Domain Layer (Business Logic)

#### 2.1 Entity (Domain Model)

**File:** `lib/features/your_feature_name/domain/entities/your_feature_entity.dart`

```dart
import 'package:equatable/equatable.dart';

/// Domain entity - Pure Dart class with no framework dependencies
class YourFeatureEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const YourFeatureEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  YourFeatureEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return YourFeatureEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, createdAt];
}
```

#### 2.2 Repository Interface

**File:** `lib/features/your_feature_name/domain/repositories/your_feature_repository.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../entities/your_feature_entity.dart';
import '../use_cases/create_feature_params.dart';

/// Repository interface - Defines what data operations are available
abstract class YourFeatureRepository {
  /// GET: Get all features
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> getFeatures();

  /// POST: Create a new feature
  Future<Either<ErrorMsg, YourFeatureEntity>> createFeature(
    CreateFeatureParams params,
  );
}
```

#### 2.3 Use Case Parameters

**File:** `lib/features/your_feature_name/domain/use_cases/create_feature_params.dart`

```dart
/// Parameters for creating a feature
/// This object is passed through all layers
class CreateFeatureParams {
  final String title;
  final String description;

  CreateFeatureParams({
    required this.title,
    required this.description,
  });
}
```

#### 2.4 GET Use Case

**File:** `lib/features/your_feature_name/domain/use_cases/get_your_features_use_case.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';

/// Use case for getting all features (GET)
class GetYourFeaturesUseCase
    implements UseCaseNoParams<List<YourFeatureEntity>> {
  final YourFeatureRepository repository;

  GetYourFeaturesUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> call() async {
    return await repository.getFeatures();
  }
}
```

#### 2.5 POST Use Case

**File:** `lib/features/your_feature_name/domain/use_cases/create_your_feature_use_case.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';
import 'create_feature_params.dart';

/// Use case for creating a feature (POST)
class CreateYourFeatureUseCase
    implements UseCase<YourFeatureEntity, CreateFeatureParams> {
  final YourFeatureRepository repository;

  CreateYourFeatureUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, YourFeatureEntity>> call(
    CreateFeatureParams params,
  ) async {
    return await repository.createFeature(params);
  }
}
```

---

### Step 3: Create Data Layer

#### 3.1 Data Model

**File:** `lib/features/your_feature_name/data/models/your_feature_model.dart`

```dart
import '../../domain/entities/your_feature_entity.dart';

/// Data model - Extends entity and adds JSON serialization
class YourFeatureModel extends YourFeatureEntity {
  const YourFeatureModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
  });

  /// Create from JSON (API response)
  factory YourFeatureModel.fromJson(Map<String, dynamic> json) {
    return YourFeatureModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON (for API request or local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert to entity
  YourFeatureEntity toEntity() {
    return YourFeatureEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
    );
  }
}
```

#### 3.2 Mapper

**File:** `lib/features/your_feature_name/data/mappers/your_feature_mapper.dart`

```dart
import '../../domain/entities/your_feature_entity.dart';
import '../models/your_feature_model.dart';

/// Mapper - Converts between Model and Entity
class YourFeatureMapper {
  /// Convert Model to Entity
  static YourFeatureEntity toEntity(YourFeatureModel model) {
    return YourFeatureEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      createdAt: model.createdAt,
    );
  }

  /// Convert Entity to Model
  static YourFeatureModel toModel(YourFeatureEntity entity) {
    return YourFeatureModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}
```

#### 3.3 Remote Data Source Interface

**File:** `lib/features/your_feature_name/data/data_sources/your_feature_remote_data_source.dart`

```dart
import '../models/your_feature_model.dart';
import '../../domain/use_cases/create_feature_params.dart';

/// Remote data source interface - API operations
abstract class YourFeatureRemoteDataSource {
  /// GET: Fetch all features from API
  Future<List<YourFeatureModel>> getFeatures();

  /// POST: Create a new feature via API
  Future<YourFeatureModel> createFeature(CreateFeatureParams params);
}
```

#### 3.4 Remote Data Source Implementation

**File:** `lib/features/your_feature_name/data/data_sources/your_feature_remote_data_source_impl.dart`

```dart
import '../../../../core/network/api_client.dart';
import '../models/your_feature_model.dart';
import '../../domain/use_cases/create_feature_params.dart';
import 'your_feature_remote_data_source.dart';

/// Remote data source implementation - API calls
class YourFeatureRemoteDataSourceImpl
    implements YourFeatureRemoteDataSource {
  final ApiClient apiClient;

  YourFeatureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<YourFeatureModel>> getFeatures() async {
    try {
      // GET /your-features
      final response = await apiClient.get('/your-features');
      
      // Parse JSON response
      final List<dynamic> jsonList = response.data as List<dynamic>;
      
      // Convert to models
      return jsonList
          .map((json) => YourFeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get features: ${e.toString()}');
    }
  }

  @override
  Future<YourFeatureModel> createFeature(CreateFeatureParams params) async {
    try {
      // POST /your-features
      final response = await apiClient.post(
        '/your-features',
        data: {
          'title': params.title,
          'description': params.description,
        },
      );
      
      // Parse JSON response
      return YourFeatureModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create feature: ${e.toString()}');
    }
  }
}
```

#### 3.5 Local Data Source Interface

**File:** `lib/features/your_feature_name/data/data_sources/your_feature_local_data_source.dart`

```dart
import '../models/your_feature_model.dart';

/// Local data source interface - Local storage operations
abstract class YourFeatureLocalDataSource {
  /// Get all features from local storage
  Future<List<YourFeatureModel>> getFeatures();

  /// Get a single feature by ID
  Future<YourFeatureModel?> getFeatureById(String id);

  /// Save a feature to local storage
  Future<void> saveFeature(YourFeatureModel feature);

  /// Save multiple features to local storage
  Future<void> saveFeatures(List<YourFeatureModel> features);
}
```

#### 3.6 Local Data Source Implementation

**File:** `lib/features/your_feature_name/data/data_sources/your_feature_local_data_source_impl.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/your_feature_model.dart';
import 'your_feature_local_data_source.dart';

/// Local data source implementation - SharedPreferences
class YourFeatureLocalDataSourceImpl
    implements YourFeatureLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'your_features';

  YourFeatureLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<YourFeatureModel>> getFeatures() async {
    try {
      final jsonString = sharedPreferences.getString(_key);
      if (jsonString == null) return [];

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map((json) =>
              YourFeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get features from local storage: $e');
    }
  }

  @override
  Future<YourFeatureModel?> getFeatureById(String id) async {
    try {
      final features = await getFeatures();
      return features.firstWhere(
        (feature) => feature.id == id,
        orElse: () => throw Exception('Feature not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveFeature(YourFeatureModel feature) async {
    try {
      final features = await getFeatures();
      final index = features.indexWhere((f) => f.id == feature.id);

      if (index >= 0) {
        features[index] = feature; // Update existing
      } else {
        features.add(feature); // Add new
      }

      await saveFeatures(features);
    } catch (e) {
      throw Exception('Failed to save feature to local storage: $e');
    }
  }

  @override
  Future<void> saveFeatures(List<YourFeatureModel> features) async {
    try {
      final jsonString = jsonEncode(
        features.map((feature) => feature.toJson()).toList(),
      );
      await sharedPreferences.setString(_key, jsonString);
    } catch (e) {
      throw Exception('Failed to save features to local storage: $e');
    }
  }
}
```

#### 3.7 Repository Implementation

**File:** `lib/features/your_feature_name/data/repositories/your_feature_repository_impl.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/your_feature_entity.dart';
import '../../domain/repositories/your_feature_repository.dart';
import '../../domain/use_cases/create_feature_params.dart';
import '../data_sources/your_feature_local_data_source.dart';
import '../data_sources/your_feature_remote_data_source.dart';
import '../mappers/your_feature_mapper.dart';

/// Repository implementation - Combines remote and local data sources
class YourFeatureRepositoryImpl implements YourFeatureRepository {
  final YourFeatureRemoteDataSource remoteDataSource;
  final YourFeatureLocalDataSource localDataSource;

  YourFeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> getFeatures() async {
    try {
      // GET: Try remote first (API call)
      final remoteFeatures = await remoteDataSource.getFeatures();

      // Save to local storage for offline access
      await localDataSource.saveFeatures(remoteFeatures);

      // Convert models to entities
      final entities = remoteFeatures
          .map((model) => YourFeatureMapper.toEntity(model))
          .toList();

      return Right(entities);
    } catch (e) {
      // Fallback to local storage if API fails (no internet)
      try {
        final localFeatures = await localDataSource.getFeatures();
        final entities = localFeatures
            .map((model) => YourFeatureMapper.toEntity(model))
            .toList();

        return Right(entities);
      } catch (localError) {
        return Left('Failed to load features: ${localError.toString()}');
      }
    }
  }

  @override
  Future<Either<ErrorMsg, YourFeatureEntity>> createFeature(
    CreateFeatureParams params,
  ) async {
    try {
      // POST: Create via API
      final feature = await remoteDataSource.createFeature(params);

      // Save to local storage
      await localDataSource.saveFeature(feature);

      // Convert to entity
      return Right(YourFeatureMapper.toEntity(feature));
    } catch (e) {
      return Left('Failed to create feature: ${e.toString()}');
    }
  }
}
```

---

### Step 4: Create Presentation Layer

#### 4.1 State

**File:** `lib/features/your_feature_name/presentation/cubit/your_features_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/your_feature_entity.dart';

part 'your_features_state.freezed.dart';

/// State for Your Features
@freezed
class YourFeaturesState with _$YourFeaturesState {
  const factory YourFeaturesState({
    @Default([]) List<YourFeatureEntity> features,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _YourFeaturesState;

  const YourFeaturesState._();
}
```

**Generate freezed file:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4.2 Cubit

**File:** `lib/features/your_feature_name/presentation/cubit/your_features_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/your_feature_entity.dart';
import '../../domain/use_cases/get_your_features_use_case.dart';
import '../../domain/use_cases/create_your_feature_use_case.dart';
import '../../domain/use_cases/create_feature_params.dart';
import 'your_features_state.dart';

/// Cubit for managing Your Features state
class YourFeaturesCubit extends Cubit<YourFeaturesState> {
  final GetYourFeaturesUseCase getFeaturesUseCase;
  final CreateYourFeatureUseCase createFeatureUseCase;

  YourFeaturesCubit({
    required this.getFeaturesUseCase,
    required this.createFeatureUseCase,
  }) : super(const YourFeaturesState()) {
    loadFeatures();
  }

  /// GET: Load all features
  Future<void> loadFeatures() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getFeaturesUseCase.call();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (features) {
        emit(
          state.copyWith(
            features: features,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// POST: Create a new feature
  Future<void> createFeature({
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await createFeatureUseCase.call(
      CreateFeatureParams(title: title, description: description),
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (feature) {
        // Add new feature to list
        final updatedFeatures = [feature, ...state.features];
        emit(
          state.copyWith(
            features: updatedFeatures,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
```

#### 4.3 Page (UI)

**File:** `lib/features/your_feature_name/presentation/pages/your_features_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/your_features_cubit.dart';
import '../cubit/your_features_state.dart';

/// Your Features Page
class YourFeaturesPage extends StatelessWidget {
  const YourFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Features'),
      ),
      body: BlocBuilder<YourFeaturesCubit, YourFeaturesState>(
        builder: (context, state) {
          if (state.isLoading && state.features.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.features.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<YourFeaturesCubit>().loadFeatures();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<YourFeaturesCubit>().loadFeatures(),
            child: ListView.builder(
              itemCount: state.features.length,
              itemBuilder: (context, index) {
                final feature = state.features[index];
                return ListTile(
                  title: Text(feature.title),
                  subtitle: Text(feature.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // TODO: Implement delete
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Feature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<YourFeaturesCubit>().createFeature(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
```

---

### Step 5: Dependency Injection

**File:** `lib/features/your_feature_name/your_feature_injection.dart`

```dart
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/your_feature_local_data_source.dart';
import 'data/data_sources/your_feature_local_data_source_impl.dart';
import 'data/data_sources/your_feature_remote_data_source.dart';
import 'data/data_sources/your_feature_remote_data_source_impl.dart';
import 'data/repositories/your_feature_repository_impl.dart';
import 'domain/repositories/your_feature_repository.dart';
import 'domain/use_cases/get_your_features_use_case.dart';
import 'domain/use_cases/create_your_feature_use_case.dart';
import 'presentation/cubit/your_features_cubit.dart';

/// Initialize your feature dependencies
void initYourFeatureInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<YourFeatureRemoteDataSource>(
    () => YourFeatureRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<YourFeatureLocalDataSource>(
    () => YourFeatureLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<YourFeatureRepository>(
    () => YourFeatureRepositoryImpl(
      remoteDataSource: sl<YourFeatureRemoteDataSource>(),
      localDataSource: sl<YourFeatureLocalDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetYourFeaturesUseCase>(
    () => GetYourFeaturesUseCase(
      repository: sl<YourFeatureRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateYourFeatureUseCase>(
    () => CreateYourFeatureUseCase(
      repository: sl<YourFeatureRepository>(),
    ),
  );

  // Register Cubit (Factory - creates new instance each time)
  sl.registerFactory<YourFeaturesCubit>(
    () => YourFeaturesCubit(
      getFeaturesUseCase: sl<GetYourFeaturesUseCase>(),
      createFeatureUseCase: sl<CreateYourFeatureUseCase>(),
    ),
  );
}
```

**Add to main DI file:**

**File:** `lib/core/di/dependency_injection.dart`

```dart
// Add import
import '../../features/your_feature_name/your_feature_injection.dart';

// In initDependencyInjection function, add:
Future<void> initDependencyInjection() async {
  await _initCore();
  initYourFeatureInjector(); // Add this line
  // Add more feature initializations here
}
```

---

### Step 6: Add Route

**File:** `lib/core/router/app_router.dart`

```dart
// Add import
import '../../features/your_feature_name/presentation/pages/your_features_page.dart';

// In routes, add:
GoRoute(
  path: AppRoutes.path(AppRoutes.yourFeatures),
  builder: (context, state) => BlocProvider(
    create: (context) => sl<YourFeaturesCubit>(),
    child: const YourFeaturesPage(),
  ),
),
```

**File:** `lib/core/router/app_routes.dart`

```dart
// Add route constant
static const String yourFeatures = '/your-features';
```

---

## 📋 Complete Example: Products Feature

Here's a complete example for a "products" feature:

### Entity

```dart
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final String description;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, price, description];
}
```

### GET API Call

```dart
// Remote Data Source
@override
Future<List<ProductModel>> getProducts() async {
  final response = await apiClient.get('/products');
  final List<dynamic> jsonList = response.data as List<dynamic>;
  return jsonList
      .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

// Repository (with local fallback)
@override
Future<Either<ErrorMsg, List<ProductEntity>>> getProducts() async {
  try {
    // Try API first
    final remoteProducts = await remoteDataSource.getProducts();
    await localDataSource.saveProducts(remoteProducts);
    return Right(remoteProducts.map((m) => ProductMapper.toEntity(m)).toList());
  } catch (e) {
    // Fallback to local if no internet
    try {
      final localProducts = await localDataSource.getProducts();
      return Right(localProducts.map((m) => ProductMapper.toEntity(m)).toList());
    } catch (localError) {
      return Left('Failed to load products: ${localError.toString()}');
    }
  }
}
```

### POST API Call

```dart
// Remote Data Source
@override
Future<ProductModel> createProduct(CreateProductParams params) async {
  final response = await apiClient.post(
    '/products',
    data: {
      'name': params.name,
      'price': params.price,
      'description': params.description,
    },
  );
  return ProductModel.fromJson(response.data as Map<String, dynamic>);
}

// Repository
@override
Future<Either<ErrorMsg, ProductEntity>> createProduct(
  CreateProductParams params,
) async {
  try {
    final product = await remoteDataSource.createProduct(params);
    await localDataSource.saveProduct(product);
    return Right(ProductMapper.toEntity(product));
  } catch (e) {
    return Left('Failed to create product: ${e.toString()}');
  }
}
```

---

## 🎯 Key Points

### 1. Data Flow

```
UI (Cubit) 
  → Use Case 
    → Repository 
      → Remote Data Source (API)
      → Local Data Source (Fallback)
```

### 2. Local Fallback Strategy

```dart
// Always try remote first
try {
  final remoteData = await remoteDataSource.getData();
  await localDataSource.saveData(remoteData); // Cache for offline
  return Right(remoteData);
} catch (e) {
  // If API fails, use local data
  try {
    final localData = await localDataSource.getData();
    return Right(localData);
  } catch (localError) {
    return Left('Error message');
  }
}
```

### 3. Naming Convention

- **Feature name:** `your_feature_name` (snake_case)
- **Files:** `your_feature_entity.dart`, `your_feature_model.dart`
- **Classes:** `YourFeatureEntity`, `YourFeatureModel` (PascalCase)

---

## ✅ Checklist

When creating a new feature:

- [ ] Create folder structure
- [ ] Create domain layer (entity, repository interface, use cases)
- [ ] Create data layer (model, mapper, data sources, repository impl)
- [ ] Create presentation layer (state, cubit, page)
- [ ] Setup dependency injection
- [ ] Add route
- [ ] Run `build_runner` for freezed files
- [ ] Test GET API call
- [ ] Test POST API call
- [ ] Test local fallback (turn off internet)

---

## 🎯 Summary

1. ✅ **Structure:** Follow Clean Architecture (domain → data → presentation)
2. ✅ **GET API:** Remote data source → Repository → Use case → Cubit
3. ✅ **POST API:** Cubit → Use case → Repository → Remote data source
4. ✅ **Local Fallback:** Try remote, fallback to local if fails
5. ✅ **DI:** Register all dependencies in injection file

---

That's it! You now know how to create features. 🚀
