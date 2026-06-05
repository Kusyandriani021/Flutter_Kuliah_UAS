class Todo {
  final String id;
  final String title;
  final bool completed;
  final bool isImportant;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    this.isImportant = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
    bool? isImportant,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
