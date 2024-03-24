class TodoService {
  late final List<String> _tasks;

  //FIXME:
  init() {
    _tasks = [
      "Incomplete Task 1",
      "debug Task 2",
      "Incomplete Task 3",
      "debug Task 4",
      "Incomplete Task 5",
    ];
  }

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  void addTask(String task) => _tasks.add(task);

  void removeTaskAt(int index) => _tasks.removeAt(index);

  void editTaskAt(int index, String newText) => _tasks[index] = newText;

  String taskAt(index) => _tasks[index];

  List<String> get tasks => _tasks;
}
