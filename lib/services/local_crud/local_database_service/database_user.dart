import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseUser {
  final int id;
  final String email;
  late DateTime _lastSynced;

  DatabaseUser({
    required this.id,
    required this.email,
    DateTime? lastSyncedDate,
  }) {
    lastSyncedDate != null
        ? setLastSynced(lastSyncedDate)
        : setLastSynced(parseStringToDateTime(defaultLastSyncedDate));
  }

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        _lastSynced = parseStringToDateTime(map[lastSyncedColumn] as String);

  @override
  String toString() =>
      'UserID = [$id],\n   email = [$email],\n   lastSynced = [$lastSynced]\n';

  void setLastSynced(DateTime syncDate) => _lastSynced = syncDate;

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  DateTime get lastSynced => _lastSynced;
}
