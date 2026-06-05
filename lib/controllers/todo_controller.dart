import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../models/pengajuan_seminar.dart';

enum FilterOption { all, active, completed }

class TodoController extends ChangeNotifier {
  final List<Todo> _todos = [];
  FilterOption _filter = FilterOption.all;

  // Tambahan untuk pengajuan seminar
  final List<PengajuanSeminar> _pengajuanList = [];
  List<PengajuanSeminar> get pengajuanList => List.unmodifiable(_pengajuanList);

  List<Todo> get todos {
    switch (_filter) {
      case FilterOption.active:
        return _todos.where((todo) => !todo.completed).toList();
      case FilterOption.completed:
        return _todos.where((todo) => todo.completed).toList();
      default:
        return _todos;
    }
  }

  int get totalCount => _todos.length;
  int get activeCount => _todos.where((todo) => !todo.completed).length;
  int get completedCount => _todos.where((todo) => todo.completed).length;

  void addTodo(String title, {bool isImportant = false}) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      isImportant: isImportant,
    );
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] =
          _todos[index].copyWith(completed: !_todos[index].completed);
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void setFilter(FilterOption filter) {
    _filter = filter;
    notifyListeners();
  }

  void addPengajuan(PengajuanSeminar pengajuan) {
    _pengajuanList.add(pengajuan);
    notifyListeners();
  }

  void removePengajuan(int index) {
    if (index >= 0 && index < _pengajuanList.length) {
      _pengajuanList.removeAt(index);
      notifyListeners();
    }
  }

  void updatePengajuan(int index, PengajuanSeminar pengajuan) {
    if (index >= 0 && index < _pengajuanList.length) {
      _pengajuanList[index] = pengajuan;
      notifyListeners();
    }
  }
}

