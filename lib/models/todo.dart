class Todo{
  Todo(this.id,this.task,this.category,this.date,this.finished);
  int id;
  String task;
  int category;
  String date;
  int finished;

  todoMap(){
    Map<String, dynamic> mapping = {
      "id":id,
      "task":task,
      "category":category,
      "date":date,
      "finished":finished,
    };
    return mapping;
  }
}