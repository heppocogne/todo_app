class Category{
  Category(this.name,this.description);
  String name;
  String description;

  categoryMap(){
    Map<String, dynamic> mapping = {
      "name":name,
      "description":description,
    };
    return mapping;
  }
}