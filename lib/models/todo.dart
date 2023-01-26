class Todo{
  Todo(this.id,this.title,this.description,this.category,this.date,{this.finished=0});
  int id;
  String title;
  String description;
  int category;
  String date;
  int finished;

  todotMap(){
    Map<String, dynamic> mapping = {
      "id":id,
      "title":title,
      "description":description,
      "category":category,
      "date":date,
      "finished":finished,
    };
    return mapping;
  }
}