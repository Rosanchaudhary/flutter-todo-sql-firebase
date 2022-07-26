part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class AddTodo extends TodosEvent {
  final String title;
  final String description;
  const AddTodo({
    required this.title,
    required this.description,
  });
}
class UploadTodo extends TodosEvent {
  final Todos todo;
  const UploadTodo({
    required this.todo,
  });
}

class GetAllTodos extends TodosEvent {}

class RemoveTodo extends TodosEvent {
  final Todos todo;
  const RemoveTodo({
    required this.todo
  });
}
