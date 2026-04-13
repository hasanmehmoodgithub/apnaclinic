import 'package:drift/drift.dart';

class AppTable extends Table {
  // Integer column (primary key)
  IntColumn get id => integer().autoIncrement()();

  // Real (double) column
  RealColumn get realValue => real().nullable()();

  // Text (string) column
  TextColumn get textValue => text().nullable()();

  // Boolean column
  BoolColumn get boolValue => boolean().withDefault(const Constant(false))();

  // DateTime column
  DateTimeColumn get dateValue => dateTime().nullable()();

  // Blob (binary data) column
  BlobColumn get blobValue => blob().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
