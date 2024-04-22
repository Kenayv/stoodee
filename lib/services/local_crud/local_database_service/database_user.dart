import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseUser {
  final int id;
  final String email;
  late String? _cloudId;
  late String _name;
  late DateTime _lastSynced;
  late DateTime _lastStreakBroken;
  late int _totalFlashcardsCompleted;
  late int _totalTasksCompleted;
  late DateTime _lastStudied;
  late int _dailyGoalFlashcards;
  late int _dailyGoalTasks;
  late int _tasksCompletedToday;
  late int _flashcardsCompletedToday;
  late int _currentDayStreak;
  late int _streakHighScore;
  late int _flashcardRushHighscore;
  late int _totalIncompleteTasks;

  DatabaseUser({
    required this.id,
    required this.email,
    required String? cloudId,
    required String name,
    required DateTime lastSynced,
    required DateTime lastStreakBroken,
    required DateTime lastStudied,
    required int dailyGoalFlashcards,
    required int dailyGoalTasks,
    required int flashcardsCompletedToday,
    required int tasksCompletedToday,
    required int currentDayStreak,
    required int totalFlashcardsCompleted,
    required int totalTasksCompleted,
    required int streakHighscore,
    required int flashcardRushHighscore,
    required int totalIncompleteTasks,
  })  : _cloudId = cloudId,
        _name = name,
        _lastSynced = lastSynced,
        _lastStreakBroken = lastStreakBroken,
        _dailyGoalFlashcards = dailyGoalFlashcards,
        _dailyGoalTasks = dailyGoalTasks,
        _flashcardsCompletedToday = flashcardsCompletedToday,
        _tasksCompletedToday = tasksCompletedToday,
        _lastStudied = lastStudied,
        _currentDayStreak = currentDayStreak,
        _totalFlashcardsCompleted = totalFlashcardsCompleted,
        _totalTasksCompleted = totalTasksCompleted,
        _streakHighScore = streakHighscore,
        _flashcardRushHighscore = flashcardRushHighscore,
        _totalIncompleteTasks = totalIncompleteTasks;

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        _cloudId = map[cloudIdColumn] as String?,
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
        _currentDayStreak = map[currentDayStreakColumn] as int,
        _totalFlashcardsCompleted = map[totalFlashcardsCompletedColumn] as int,
        _totalTasksCompleted = map[totalTasksCompletedColumn] as int,
        _streakHighScore = map[streakHighscoreColumn] as int,
        _totalIncompleteTasks = map[totalIncompleteTasksColumn] as int,
        _flashcardRushHighscore = map[flashcardRushHighscoreColumn] as int;

  String get name => _name;
  DateTime get lastSynced => _lastSynced;
  DateTime get lastStreakBroken => _lastStreakBroken;
  DateTime get lastStudied => _lastStudied;
  int get dailyGoalFlashcards => _dailyGoalFlashcards;
  int get dailyGoalTasks => _dailyGoalTasks;
  int get flashcardsCompletedToday => _flashcardsCompletedToday;
  int get tasksCompletedToday => _tasksCompletedToday;
  int get currentDayStreak => _currentDayStreak;
  String? get cloudId => _cloudId;
  int get totalTasksCompleted => _totalTasksCompleted;
  int get totalFlashcardsCompleted => _totalFlashcardsCompleted;
  int get streakHighscore => _streakHighScore;
  int get flashcardRushHighscore => _flashcardRushHighscore;
  int get totalIncompleteTasks => _totalIncompleteTasks;

  void setLastSynced(DateTime date) => _lastSynced = date;

  void setLastStreakBroken(DateTime date) => _lastStreakBroken = date;
  void setLastStudied(DateTime date) => _lastStudied = date;
  void setName(String name) => _name = name;
  void setDailyFlashcardsGoal(int goal) => _dailyGoalFlashcards = goal;
  void setDailyTaskGoal(int goal) => _dailyGoalTasks = goal;
  void setCurrentDayStreak(int streak) => _currentDayStreak = streak;
  void setStreakHighscore(int streak) => _streakHighScore = streak;

  void setFcCompletedToday(int completed) =>
      _flashcardsCompletedToday = completed;

  void setTasksCompletedToday(int completed) =>
      _tasksCompletedToday = completed;

  @override
  String toString() =>
      'UserID = [$id],\n   cloudId = [$cloudId],\n   email = [$email],\n   userName = [$_name]\n   lastSynced = [$lastSynced]\n   lastStreakBroken = [$lastStreakBroken]\n   dailyGoal: [tasks: $_tasksCompletedToday/$_dailyGoalTasks | flashcards: $_flashcardsCompletedToday/$_dailyGoalFlashcards]\n   LastStudied: $_lastStudied\n   dayStreak = [$currentDayStreak]\n totalTasksCompleted = [$_totalTasksCompleted]\n   TotalFlashcardsCompleted = [$_totalFlashcardsCompleted]\n   streakHighScore = [$_streakHighScore]\n    incomplete tasks = [$_totalIncompleteTasks]\n   flashcardRush highscore = [$_flashcardRushHighscore]\n';

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        cloudIdColumn: cloudId,
        emailColumn: email,
        nameColumn: _name,
        lastSyncedColumn: getDateAsFormattedString(_lastSynced),
        lastStreakBrokenColumn: getDateAsFormattedString(_lastStreakBroken),
        lastStudiedColumn: getDateAsFormattedString(_lastStudied),
        dailyGoalTasksColumn: _dailyGoalTasks,
        dailyGoalFlashcardsColumn: _dailyGoalFlashcards,
        flashcardsCompletedTodayColumn: _flashcardsCompletedToday,
        tasksCompletedTodayColumn: _tasksCompletedToday,
        currentDayStreakColumn: _currentDayStreak,
        totalFlashcardsCompletedColumn: _totalFlashcardsCompleted,
        totalTasksCompletedColumn: _totalTasksCompleted,
        streakHighscoreColumn: _streakHighScore,
      };

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
