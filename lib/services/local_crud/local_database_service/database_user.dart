import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseUser {
  final int id;
  final String email;
  late String _name;
  late DateTime _lastSynced;
  late DateTime _lastStreakBroken;
  late DateTime _lastStudied;
  late int _dailyGoalFlashcards;
  late int _dailyGoalTasks;
  late int _tasksCompletedToday;
  late int _flashcardsCompletedToday;
  late int _dayStreak;

  DatabaseUser({
    required this.id,
    required this.email,
    required String name,
    required DateTime lastSynced,
    required DateTime lastStreakBroken,
    required DateTime lastStudied,
    required int dailyGoalFlashcards,
    required int dailyGoalTasks,
    required int flashcardsCompletedToday,
    required int tasksCompletedToday,
    required int dayStreak,
  })  : _name = name,
        _lastSynced = lastSynced,
        _lastStreakBroken = lastStreakBroken,
        _dailyGoalFlashcards = dailyGoalFlashcards,
        _dailyGoalTasks = dailyGoalTasks,
        _flashcardsCompletedToday = flashcardsCompletedToday,
        _tasksCompletedToday = tasksCompletedToday,
        _lastStudied = lastStudied,
        _dayStreak = dayStreak;

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        _name = map[nameColumn] as String,
        _lastSynced = parseStringToDateTime(map[lastSyncedColumn] as String),
        _lastStreakBroken =
            parseStringToDateTime(map[lastStreakBrokenColumn] as String),
        _lastStudied = parseStringToDateTime(map[lastStudiedColumn] as String),
        _dailyGoalFlashcards = map[dailyGoalFlashcardsColumn] as int,
        _dailyGoalTasks = map[dailyGoalTasksColumn] as int,
        _flashcardsCompletedToday = map[flashcardsCompletedTodayColumn] as int,
        _tasksCompletedToday = map[tasksCompletedTodayColumn] as int,
        _dayStreak = map[dayStreakColumn] as int;

  String get name => _name;
  DateTime get lastSynced => _lastSynced;
  DateTime get lastStreakBroken => _lastStreakBroken;
  DateTime get lastStudied => _lastStudied;
  int get dailyGoalFlashcards => _dailyGoalFlashcards;
  int get dailyGoalTasks => _dailyGoalTasks;
  int get flashcardsCompletedToday => _flashcardsCompletedToday;
  int get tasksCompletedToday => _tasksCompletedToday;
  int get dayStreak => _dayStreak;

  void setLastSynced(DateTime date) => _lastSynced = date;
  void setLastStreakBroken(DateTime date) => _lastStreakBroken = date;
  void setLastStudied(DateTime date) => _lastStudied = date;
  void setName(String name) => _name = name;
  void setDailyFlashcardsGoal(int goal) => _dailyGoalFlashcards = goal;
  void setDailyTaskGoal(int goal) => _dailyGoalTasks = goal;
  void setDayStreak(int streak) => _dayStreak = streak;

  void setFcCompletedToday(int completed) =>
      _flashcardsCompletedToday = completed;

  void setTasksCompletedToday(int completed) =>
      _tasksCompletedToday = completed;

  @override
  String toString() =>
      'UserID = [$id],\n   email = [$email],\n   userName = [$_name]\n   lastSynced = [$lastSynced]\n   lastStreakBroken = [$lastStreakBroken]\n   dailyGoal: [tasks: $_tasksCompletedToday/$_dailyGoalTasks | flashcards: $_flashcardsCompletedToday/$_dailyGoalFlashcards]\n   LastStudied: $_lastStudied\n   dayStreak = [$dayStreak]\n';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
