# ⚡ Quick Start: Create a New Feature

Quick reference guide for creating a new feature in 5 minutes.

---

## 📋 Prerequisites

- Feature name (e.g., `products`, `users`, `orders`)
- API endpoints (GET, POST, etc.)

---

## 🚀 Quick Steps

### 1. Create Folders

```bash
# Replace 'products' with your feature name
mkdir -p lib/features/products/{data/{data_sources,mappers,models,repositories},domain/{entities,repositories,use_cases},presentation/{cubit,pages,widgets}}
```

### 2. Copy Template Files

Copy files from `lib/features/feature_name/` and rename:
- `clean_feature_*` → `your_feature_*`
- `CleanFeature*` → `YourFeature*`

### 3. Update Code

1. **Entity:** Update fields in `your_feature_entity.dart`
2. **Model:** Update `fromJson`/`toJson` in `your_feature_model.dart`
3. **API:** Update endpoints in `your_feature_remote_data_source_impl.dart`
4. **Params:** Update fields in `create_feature_params.dart`

### 4. Register Dependencies

Add to `lib/core/di/dependency_injection.dart`:
```dart
import '../../features/products/products_injection.dart';

// In initDependencyInjection():
initProductsInjector();
```

### 5. Add Route

Add to `lib/core/router/app_routes.dart`:
```dart
static const String products = 'products';
```

Add to `lib/core/router/app_router.dart`:
```dart
GoRoute(
  path: AppRoutes.path(AppRoutes.products),
  builder: (context, state) => BlocProvider(
    create: (context) => sl<ProductsCubit>(),
    child: const ProductsPage(),
  ),
),
```

### 6. Generate Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📝 Example: Products Feature

### Entity
```dart
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  
  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
  });
  
  @override
  List<Object?> get props => [id, name, price];
}
```

### GET API
```dart
// Remote Data Source
@override
Future<List<ProductModel>> getProducts() async {
  final response = await apiClient.get('/products');
  return (response.data as List)
      .map((json) => ProductModel.fromJson(json))
      .toList();
}
```

### POST API
```dart
// Remote Data Source
@override
Future<ProductModel> createProduct(CreateProductParams params) async {
  final response = await apiClient.post('/products', data: {
    'name': params.name,
    'price': params.price,
  });
  return ProductModel.fromJson(response.data);
}
```

---

## ✅ Checklist

- [ ] Folders created
- [ ] Files copied and renamed
- [ ] Entity fields updated
- [ ] Model JSON methods updated
- [ ] API endpoints updated
- [ ] DI registered
- [ ] Route added
- [ ] `build_runner` executed
- [ ] Tested GET API
- [ ] Tested POST API
- [ ] Tested offline (local fallback)

---

## 📚 Full Guide

For detailed explanation, see: [FEATURE_CREATION_GUIDE.md](./FEATURE_CREATION_GUIDE.md)

---

**That's it! Your feature is ready. 🎉**
