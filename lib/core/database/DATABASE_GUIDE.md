# 🗄️ Database Guide - Drift

Complete guide for adding tables, DAOs, and migrations using Drift in your Flutter app.

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Folder Structure](#folder-structure)
3. [Adding a New Table in a Feature](#adding-a-new-table-in-a-feature)
4. [Registering Table in Database](#registering-table-in-database)
5. [Creating DAO](#creating-dao)
6. [Migrations](#migrations)
7. [Using in Code](#using-in-code)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This project uses **Drift** (formerly Moor) for local database management. Drift is a reactive persistence library for Flutter and Dart.

### Key Concepts

- **Table**: Defines the database schema (columns, types, constraints)
- **DAO**: Data Access Object - provides methods to interact with tables
- **Migration**: Handles database schema changes
- **Companion**: Used for inserts and updates

---

## 📁 Folder Structure

### Recommended Structure

```
lib/
├── core/
│   └── database/
│       ├── app_database.dart          # Main database class
│       ├── app_database.g.dart        # Generated (don't edit)
│       └── DATABASE_GUIDE.md          # This guide
│
└── features/
    └── [feature_name]/
        └── data/
            └── database/
                ├── [table_name]_table.dart    # Table definition
                └── [table_name]_dao.dart      # DAO (Data Access Object)
```

### Example: Products Feature

```
lib/
├── core/
│   └── database/
│       └── app_database.dart
│
└── features/
    └── products/
        └── data/
            └── database/
                ├── products_table.dart
                └── products_dao.dart
```

---

## ➕ Adding a New Table in a Feature

### Step 1: Create Table File

Create: `lib/features/[feature_name]/data/database/[table_name]_table.dart`

**Example: Products Table**

```dart
import 'package:drift/drift.dart';

/// Products table for storing product information
class Products extends Table {
  // Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();
  
  // Text columns
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  
  // Numeric columns
  RealColumn get price => real()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  
  // Boolean
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  // Timestamps (stored as milliseconds)
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer().nullable()();
  
  // Foreign key example (if needed)
  // IntColumn get userId => integer().nullable()();
  
  // Primary key definition
  @override
  Set<Column> get primaryKey => {id};
  
  // Indexes (optional, for better query performance)
  // @override
  // List<Set<Column>> get uniqueKeys => [
  //   {name}, // Unique constraint on name
  // ];
}
```

### Step 2: Column Types Reference

| Type | Syntax | Example |
|------|--------|---------|
| **Integer** | `IntColumn get field => integer()();` | `IntColumn get age => integer()();` |
| **Auto Increment** | `IntColumn get id => integer().autoIncrement()();` | Primary key |
| **Text** | `TextColumn get field => text()();` | `TextColumn get name => text()();` |
| **Nullable Text** | `TextColumn get field => text().nullable()();` | `TextColumn get notes => text().nullable()();` |
| **Real (Float)** | `RealColumn get field => real()();` | `RealColumn get price => real()();` |
| **Boolean** | `BoolColumn get field => boolean()();` | `BoolColumn get isActive => boolean()();` |
| **Boolean with Default** | `BoolColumn get field => boolean().withDefault(const Constant(false))();` | Default value |
| **DateTime** | `DateTimeColumn get field => dateTime()();` | `DateTimeColumn get createdAt => dateTime()();` |
| **Blob** | `BlobColumn get field => blob()();` | For binary data |
| **Timestamp (Int)** | `IntColumn get field => integer()();` | Store as milliseconds |

### Step 3: Common Patterns

**With Default Values:**
```dart
IntColumn get quantity => integer().withDefault(const Constant(0))();
BoolColumn get isActive => boolean().withDefault(const Constant(true))();
TextColumn get status => text().withDefault(const Constant('pending'))();
```

**With Constraints:**
```dart
// Unique constraint
@override
List<Set<Column>> get uniqueKeys => [
  {email}, // Email must be unique
];

// Composite primary key
@override
Set<Column> get primaryKey => {userId, productId};
```

---

## 📝 Registering Table in Database

### Step 1: Import Table

Edit: `lib/core/database/app_database.dart`

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import feature tables
import '../../features/products/data/database/products_table.dart';
// Add more table imports here

part 'app_database.g.dart';

@DriftDatabase(tables: [Products]) // Add your table here
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // Increment when adding migrations

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here (see Migrations section)
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));
    return NativeDatabase(file);
  });
}
```

### Step 2: Generate Code

Run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or with watch mode (auto-regenerates on changes):

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Step 3: Verify Generation

After generation, you should see:
- `app_database.g.dart` updated
- Data class `Product` (singular) generated
- Companion class `ProductCompanion` generated

---

## 📚 Creating DAO

### Step 1: Create DAO File

Create: `lib/features/[feature_name]/data/database/[table_name]_dao.dart`

**Example: Products DAO**

```dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

/// Data Access Object for Products table
@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(AppDatabase db) : super(db);

  // ==================== READ Operations ====================

  /// Get all products
  Future<List<Product>> getAll() {
    return select(products).get();
  }

  /// Get product by ID
  Future<Product?> getById(int id) {
    return (select(products)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get products by category
  Future<List<Product>> getByCategory(String category) {
    return (select(products)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();
  }

  /// Get active products only
  Future<List<Product>> getActiveProducts() {
    return (select(products)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
          .get();
  }

  /// Search products by name
  Future<List<Product>> searchByName(String query) {
    return (select(products)
          ..where((t) => t.name.like('%$query%')))
          .get();
  }

  /// Get products with pagination
  Future<List<Product>> getPaginated({
    required int limit,
    required int offset,
  }) {
    return (select(products)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(limit, offset: offset))
          .get();
  }

  /// Count all products
  Future<int> count() {
    return (selectOnly(products)..addColumns([products.id.count()]))
        .getSingle()
        .then((row) => row.read(products.id.count()) ?? 0);
  }

  // ==================== CREATE Operations ====================

  /// Insert a new product
  Future<int> insert(ProductCompanion product) {
    return into(products).insert(product);
  }

  /// Insert multiple products
  Future<void> insertAll(List<ProductCompanion> productList) {
    return batch((batch) {
      batch.insertAll(products, productList);
    });
  }

  // ==================== UPDATE Operations ====================

  /// Update product by ID
  Future<bool> updateById(int id, ProductCompanion product) {
    return (update(products)..where((t) => t.id.equals(id))).write(product);
  }

  /// Update product price
  Future<bool> updatePrice(int id, double newPrice) {
    return (update(products)
          ..where((t) => t.id.equals(id)))
          .write(ProductCompanion(price: Value(newPrice)));
  }

  /// Toggle product active status
  Future<bool> toggleActive(int id) async {
    final product = await getById(id);
    if (product == null) return false;
    
    return (update(products)
          ..where((t) => t.id.equals(id)))
          .write(ProductCompanion(isActive: Value(!product.isActive)));
  }

  // ==================== DELETE Operations ====================

  /// Delete product by ID
  Future<int> deleteById(int id) {
    return (delete(products)..where((t) => t.id.equals(id))).go();
  }

  /// Delete products by category
  Future<int> deleteByCategory(String category) {
    return (delete(products)..where((t) => t.category.equals(category))).go();
  }

  /// Delete all products
  Future<int> deleteAll() {
    return delete(products).go();
  }
}
```

### Step 2: Register DAO in Database

Edit: `lib/core/database/app_database.dart`

```dart
// Import DAO
import '../../features/products/data/database/products_dao.dart';

@DriftDatabase(
  tables: [Products],
  daos: [ProductsDao], // Add your DAO here
)
class AppDatabase extends _$AppDatabase {
  // ...
}
```

### Step 3: Generate Code Again

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔄 Migrations

### When to Use Migrations

- Adding a new table to an existing database
- Adding/removing columns
- Changing column types
- Adding indexes or constraints
- Renaming tables or columns

### Migration Strategy

### Scenario 1: Adding New Table (Existing Database)

**Step 1: Increment Schema Version**

```dart
@override
int get schemaVersion => 2; // Increment from 1 to 2
```

**Step 2: Add Migration**

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new table
        await m.createTable(products);
      }
    },
  );
}
```

### Scenario 2: Adding Column to Existing Table

**Step 1: Update Table Definition**

```dart
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  
  // NEW COLUMN
  TextColumn get sku => text().nullable()(); // Added column
}
```

**Step 2: Increment Schema Version**

```dart
@override
int get schemaVersion => 3; // Increment
```

**Step 3: Add Migration**

```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from < 2) {
    await m.createTable(products);
  }
  if (from < 3) {
    // Add new column
    await m.addColumn(products, products.sku);
  }
},
```

### Scenario 3: Multiple Changes

```dart
@override
int get schemaVersion => 4;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Version 2: Add products table
        await m.createTable(products);
      }
      if (from < 3) {
        // Version 3: Add sku column
        await m.addColumn(products, products.sku);
      }
      if (from < 4) {
        // Version 4: Add category column and index
        await m.addColumn(products, products.category);
        await m.createIndex(Index('idx_category', 'CREATE INDEX idx_category ON products(category)'));
      }
    },
  );
}
```

### Migration Methods

| Method | Description | Example |
|--------|-------------|---------|
| `createTable()` | Create a new table | `await m.createTable(products);` |
| `addColumn()` | Add column to table | `await m.addColumn(products, products.sku);` |
| `dropTable()` | Remove a table | `await m.dropTable(products);` |
| `deleteTable()` | Delete table data | `await m.deleteTable(products);` |
| `renameTable()` | Rename a table | `await m.renameTable(oldName, newName);` |
| `createIndex()` | Create an index | `await m.createIndex(Index(...));` |

### Important Notes

- **Always increment `schemaVersion`** when making schema changes
- **Test migrations** on a copy of production data
- **Backup data** before major migrations
- **Use `if (from < version)`** to handle multiple migrations
- **New databases** use `onCreate` (creates all tables)

---

## 💻 Using in Code

### Step 1: Get Database Instance

```dart
import 'core/di/dependency_injection.dart';
import 'core/database/app_database.dart';

// Get database from DI
final database = sl<AppDatabase>();

// Or get DAO directly
final productsDao = database.productsDao;
```

### Step 2: CRUD Operations

#### CREATE (Insert)

```dart
// Using Companion
final product = ProductCompanion.insert(
  name: 'iPhone 15',
  description: const Value('Latest iPhone model'),
  category: 'Electronics',
  price: 999.99,
  quantity: 10,
  isActive: const Value(true),
  createdAt: DateTime.now().millisecondsSinceEpoch,
);

// Insert
final id = await database.productsDao.insert(product);
print('Inserted product with ID: $id');
```

#### READ (Select)

```dart
// Get all products
final allProducts = await database.productsDao.getAll();

// Get by ID
final product = await database.productsDao.getById(1);

// Get by category
final electronics = await database.productsDao.getByCategory('Electronics');

// Search
final results = await database.productsDao.searchByName('iPhone');

// Pagination
final page1 = await database.productsDao.getPaginated(limit: 10, offset: 0);
final page2 = await database.productsDao.getPaginated(limit: 10, offset: 10);

// Count
final total = await database.productsDao.count();
```

#### UPDATE

```dart
// Update by ID
await database.productsDao.updateById(
  1,
  ProductCompanion(
    name: const Value('iPhone 15 Pro'),
    price: const Value(1199.99),
    updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
  ),
);

// Update price only
await database.productsDao.updatePrice(1, 899.99);

// Toggle active status
await database.productsDao.toggleActive(1);
```

#### DELETE

```dart
// Delete by ID
await database.productsDao.deleteById(1);

// Delete by category
await database.productsDao.deleteByCategory('Electronics');

// Delete all
await database.productsDao.deleteAll();
```

### Step 3: Using in Repository

```dart
class ProductsRepository {
  final ProductsDao _productsDao;

  ProductsRepository(this._productsDao);

  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await _productsDao.getAll();
      return Right(products);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  Future<Either<Failure, Product>> createProduct(ProductCompanion product) async {
    try {
      final id = await _productsDao.insert(product);
      final created = await _productsDao.getById(id);
      return Right(created!);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

### Step 4: Using in Cubit/BLoC

```dart
class ProductsCubit extends Cubit<ProductsState> {
  final ProductsDao _productsDao;

  ProductsCubit(this._productsDao) : super(ProductsInitial());

  Future<void> loadProducts() async {
    emit(ProductsLoading());
    try {
      final products = await _productsDao.getAll();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> addProduct(ProductCompanion product) async {
    try {
      await _productsDao.insert(product);
      loadProducts(); // Reload list
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
```

---

## ✅ Best Practices

### 1. Keep Tables in Feature Database Folders

```dart
// ✅ Good - Feature-specific in database folder
lib/features/products/data/database/products_table.dart
lib/features/products/data/database/products_dao.dart

// ❌ Bad - In core
lib/core/database/products_table.dart

// ❌ Bad - Separate folders
lib/features/products/data/database/products_table.dart
lib/features/products/data/database/products_dao.dart
```

### 2. Use DAOs for All Database Operations

```dart
// ✅ Good - Use DAO
await database.productsDao.insert(product);

// ❌ Bad - Direct database access
await database.into(database.products).insert(product);
```

### 3. Always Increment Schema Version

```dart
// ✅ Good
@override
int get schemaVersion => 2; // Incremented

// ❌ Bad
@override
int get schemaVersion => 1; // Not incremented after changes
```

### 4. Handle Nullable Fields Properly

```dart
// ✅ Good - Use Value() for nullable
ProductCompanion.insert(
  name: 'Product',
  description: const Value(null), // Explicit null
  notes: const Value('Optional notes'),
);

// ❌ Bad - Don't use null directly
ProductCompanion.insert(
  name: 'Product',
  description: null, // Wrong!
);
```

### 5. Use Transactions for Multiple Operations

```dart
// ✅ Good - Transaction
await database.transaction(() async {
  await database.productsDao.insert(product1);
  await database.productsDao.insert(product2);
  await database.productsDao.updateById(1, update);
});

// ❌ Bad - No transaction
await database.productsDao.insert(product1);
await database.productsDao.insert(product2);
// If second fails, first is still inserted
```

### 6. Test Migrations

- Always test migrations on a copy of production data
- Test upgrading from each previous version
- Verify data integrity after migration

---

## 🐛 Troubleshooting

### Error: "Table not found"

**Problem:** Table not registered in `@DriftDatabase`

**Solution:**
1. Check table is imported
2. Check table is in `tables: [Products]` list
3. Run `build_runner` again

### Error: "Column not found"

**Problem:** Column added but migration not run

**Solution:**
1. Increment `schemaVersion`
2. Add migration in `onUpgrade`
3. Run app to trigger migration

### Error: "DAO not found"

**Problem:** DAO not registered

**Solution:**
1. Check DAO is imported
2. Check DAO is in `daos: [ProductsDao]` list
3. Run `build_runner` again

### Error: "Migration failed"

**Problem:** Migration logic error

**Solution:**
1. Check migration version numbers
2. Verify table/column names match
3. Test migration step by step

### Build Runner Issues

**Problem:** Code not generating

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📋 Quick Reference

### Complete Example: Adding Products Table

1. **Create Table**: `lib/features/products/data/database/products_table.dart`
2. **Import in Database**: `app_database.dart`
3. **Add to @DriftDatabase**: `tables: [Products]`
4. **Run build_runner**: Generate code
5. **Create DAO**: `lib/features/products/data/database/products_dao.dart`
6. **Register DAO**: `daos: [ProductsDao]`
7. **Run build_runner**: Generate again
8. **Use**: `database.productsDao.getAll()`

### Migration Checklist

- [ ] Update table definition
- [ ] Increment `schemaVersion`
- [ ] Add migration in `onUpgrade`
- [ ] Test migration on sample data
- [ ] Run `build_runner`
- [ ] Test app with migration

---

## 🎯 Summary

1. ✅ **Create Table** in feature folder
2. ✅ **Register Table** in `@DriftDatabase(tables: [...])`
3. ✅ **Generate Code** with `build_runner`
4. ✅ **Create DAO** with CRUD methods
5. ✅ **Register DAO** in `@DriftDatabase(daos: [...])`
6. ✅ **Generate Code** again
7. ✅ **Use DAO** in repositories/Cubits
8. ✅ **Handle Migrations** when schema changes

---

**Need Help?** Check the [Drift Documentation](https://drift.simonbinder.eu/)
