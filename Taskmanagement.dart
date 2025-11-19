import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'main.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  bool isDone;
  TaskModel({required this.id, required this.title, this.isDone = false});
}

class TaskRepository {
  static const boxName = "tasksBox";
  Future<Box<TaskModel>> _openBox() async => await Hive.openBox<TaskModel>(boxName);
  Future<List<TaskModel>> getTasks() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    final box = await _openBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await _openBox();
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, AsyncValue<List<TaskModel>>>(
        (ref) => TaskController(TaskRepository()));

class TaskController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final TaskRepository repo;
  TaskController(this.repo) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    final data = await repo.getTasks();
    state = AsyncValue.data(data);
  }

  Future<void> add(String title) async {
    final task = TaskModel(id: DateTime.now().toString(), title: title);
    await repo.addTask(task);
    loadTasks();
  }

  Future<void> toggle(TaskModel task) async {
    final updated = TaskModel(id: task.id, title: task.title, isDone: !task.isDone);
    await repo.updateTask(updated);
    loadTasks();
  }

  Future<void> remove(TaskModel task) async {
    await repo.deleteTask(task.id);
    loadTasks();
  }
}

class TasksPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage())),
        child: const Icon(Icons.add),
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Error")),
        data: (list) {
          if (list.isEmpty) return const Center(child: Text("No tasks yet"));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final task = list[i];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null),
                  ),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      ref.read(taskControllerProvider.notifier).toggle(task);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(taskControllerProvider.notifier).remove(task);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddTaskPage extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(taskControllerProvider.notifier).add(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complex Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TasksPage(),
    );
  }
}
