import 'package:equatable/equatable.dart';

class Todos extends Equatable {
  final int id;
  final String title;
  final String description;
  final int isUploaded;
  const Todos({
    required this.id,
    required this.title,
    required this.description,
    required this.isUploaded
  });

  Todos.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        isUploaded = data['isUploaded'];

  @override
  List<Object?> get props => [id, title, description,isUploaded];
}
