class Category{
  Category(this.id,this.name,this.description);
  int id;
  String name;
  String description;

  categoryMap(){
    Map<String, dynamic> mapping = {
      "id":id,
      "name":name,
      "description":description,
    };
    return mapping;
  }
}