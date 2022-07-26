// ignore: depend_on_referenced_packages
import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:client/blocs/cubit/internet_cubit.dart';
import 'package:client/helper/firebase_repository.dart';
import 'package:client/helper/sql_helper.dart';
import 'package:client/models/todo_model.dart';
import 'package:equatable/equatable.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final InternetCubit internetCubit;
  final SQLHelper sqlHelper;
  final FireBaseRepository fireBaseRepository;
  late StreamSubscription internetSubscription;
  bool isConnected = false;
  TodosBloc(
      {required this.sqlHelper,
      required this.internetCubit,
      required this.fireBaseRepository})
      : super(TodosState.initial()) {
    internetSubscription = internetCubit.stream.listen((internetState) {
      if (internetState is InternetConnected) {
        isConnected = true;
        add(GetAllTodos());
      } else if (internetState is InternetDisconnected) {
        isConnected = false;
      }
    });
    on<AddTodo>((event, emit) async {
      try {
        if (isConnected) {
          final todo = await fireBaseRepository.addTodo(
              id: 10, title: event.title, description: event.description);
          emit(state.copyWith(todos: List.of(state.todos)..add(todo)));
        } else {
          final todo = await sqlHelper.addTodo(
              title: event.title, description: event.description);
          emit(state.copyWith(todos: List.of(state.todos)..add(todo)));
        }
      } catch (e) {
        state.copyWith(todoStatus: TodoStatus.error);
      }
    });
    on<UploadTodo>((event, emit) async {
      try {
        if (isConnected) {
          final todo = await fireBaseRepository.addTodo(
              id: 10,
              title: event.todo.title,
              description: event.todo.description);
          await sqlHelper.deleteTodo(id: event.todo.id);
          emit(state.copyWith(todos: List.of(state.todos)..add(todo)..remove(event.todo)));
        } else {
          emit(state.copyWith(todos: state.todos));
        }
      } catch (e) {
        state.copyWith(todoStatus: TodoStatus.error);
      }
    });

    on<GetAllTodos>((event, emit) async {
      emit(state.copyWith(todoStatus: TodoStatus.loading));
      try {
        if (isConnected) {
          final todosUploaded = await fireBaseRepository.getAllTodos();
          final todoLocal = await sqlHelper.getAllTodos();
          emit(state.copyWith(
              todoStatus: TodoStatus.loaded,
              todos: [...todoLocal, ...todosUploaded]));
        } else {
          final todos = await sqlHelper.getAllTodos();
          emit(state.copyWith(todoStatus: TodoStatus.loaded, todos: todos));
        }
      } catch (e) {
        state.copyWith(todoStatus: TodoStatus.error);
      }
    });
    on<RemoveTodo>((event, emit) async {
      try {
        await sqlHelper.deleteTodo(id: event.todo.id);
        emit(state.copyWith(todos: List.of(state.todos)..remove(event.todo)));
      } catch (e) {
        state.copyWith(todoStatus: TodoStatus.error);
      }
    });
  }

  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
}
