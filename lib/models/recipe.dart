class Recipe{
  final String name;
  final String images;
  final double rating;
  final String totalTime;
  final List<dynamic> ingredients;



  Recipe({required this.name, required this.images, required this.rating, required this.totalTime, required this.ingredients});

  factory Recipe.fromJson(dynamic json){

    return Recipe(
      name: json[0] as String,
      totalTime: json[1] as String,
      images: json[2] as String,
      rating: json[3] as double,
      ingredients: json[4],

    );
  }

  static List<Recipe> recipesFromSnapshot (List snapshot){
    return snapshot.map((data){
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime, ingredients: $ingredients}';
  }

}

