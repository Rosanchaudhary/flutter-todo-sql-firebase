import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:client/models/custom_error.dart';
import 'package:client/models/todo_model.dart';

class FireBaseRepository {
  final FirebaseFirestore firebaseFirestore;
  FireBaseRepository({
    required this.firebaseFirestore,
  });

  Future<Todos> addTodo(
      {required int id,
      required String title,
      required String description}) async {
    try {
      await firebaseFirestore.collection("todos").doc().set({
        'id': id,
        'title': title,
        'description': description,
        'isUploaded': 1
      });
      return Todos(
          id: id, title: title, description: description, isUploaded: 1);
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }

  Future<List<Todos>> getAllTodos() async {
    try {
      final response = await firebaseFirestore.collection('todos').get();

      List<Todos> allTodos =
          response.docs.map((doc) => Todos.fromJson(doc.data())).toList();

      return allTodos;
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }
}
