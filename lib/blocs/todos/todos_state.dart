part of 'todos_bloc.dart';

enum TodoStatus { intial, loading, loaded, error }

class TodosState extends Equatable {
  final List<Todos> todos;
  final TodoStatus todoStatus;

  const TodosState({
    required this.todos,
    required this.todoStatus,
  });

  factory TodosState.initial() {
    return const TodosState(todos: <Todos>[],todoStatus: TodoStatus.intial);
  }
  @override
  List<Object> get props => [todos,todoStatus];

  TodosState copyWith({
    List<Todos>? todos,
    TodoStatus? todoStatus,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      todoStatus: todoStatus ?? this.todoStatus,
    );
  }

  @override
  String toString() => 'TodosState(todos: $todos, todoStatus: $todoStatus)';
}
