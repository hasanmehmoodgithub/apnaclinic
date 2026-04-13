import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import feature-specific tables
// TODO: Uncomment after running build_runner
// import '../../features/app/data/database/daos/app_dao.dart';
// import '../../features/app/data/database/tables/app_table.dart';
// TODO: Uncomment when other feature tables are created
// import '../../features/products/data/database/tables/products_table.dart';

part 'app_database.g.dart';

// TODO: Uncomment after running build_runner: flutter pub run build_runner build
// @DriftDatabase(tables: [AppTable], daos: [AppDao])
@DriftDatabase(tables: [], daos: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
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
