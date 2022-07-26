import 'package:client/blocs/todos/todos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<TodosBloc>().add(GetAllTodos());
  // }
  @override
  void didChangeDependencies() {
    context.read<TodosBloc>().add(GetAllTodos());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModel();
          },
          label: const Text("Add Todo")),
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state.todoStatus == TodoStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.todoStatus == TodoStatus.loaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Text("No item found"),
              );
            }
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: state.todos[index].isUploaded == 1
                                ? Colors.green
                                : Colors.blue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            extentRatio: 0.2,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  context.read<TodosBloc>().add(
                                      RemoveTodo(todo: state.todos[index]));
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            extentRatio: 0.2,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: (BuildContext context) {
                                  context.read<TodosBloc>().add(
                                      RemoveTodo(todo: state.todos[index]));
                                },
                                backgroundColor: const Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        state.todos[index].title,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          state.todos[index].description,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                                if (state.todos[index].isUploaded == 0) ...[
                                  IconButton(
                                      onPressed: () {
                                        context.read<TodosBloc>().add(
                                            UploadTodo(
                                                todo: state.todos[index]));
                                      },
                                      icon: const Icon(Icons.upload))
                                ]
                              ],
                            ),
                          ),
                        )),
                  );
                });
          }
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }

  showModel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(5),
            content: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value!.isEmpty) return "Cannot be empty";
                        return null;
                      },
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                          labelText: "title",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) return "Cannot be empty";
                        return null;
                      },
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                          labelText: "description",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          context.read<TodosBloc>().add(AddTodo(
                              title: _titleController.text,
                              description: _descriptionController.text));
                          _titleController.clear();
                          _descriptionController.clear();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
