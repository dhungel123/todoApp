class Todo{
  final String id;
  final String title;
  final String description;
  Todo({required this.id,required this.title,required this.description});
  Todo copyWith({String? id, String? title, String? description}){
    return Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
    );
  }
  factory Todo.fromMap(Map<String,dynamic> map ){
    return Todo(
        id: map['_id'],
        title: map['title'],
        description: map['description'],
    );
  }
  factory Todo.fromDbMap(Map<String,dynamic> map ){
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }


}