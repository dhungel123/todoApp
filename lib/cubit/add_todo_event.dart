abstract class TodoEvent{}

class AddTodoEvent extends TodoEvent{
  final String  title;
  final String description;

  AddTodoEvent({required this.title, required this.description});

}