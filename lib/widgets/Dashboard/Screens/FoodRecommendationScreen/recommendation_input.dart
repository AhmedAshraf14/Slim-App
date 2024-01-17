import 'package:flutter/material.dart';
import 'package:slim/widgets/Dashboard/Screens/FoodRecommendationScreen/recipe_card.dart';

import '../../../../models/recipe.api.dart';
import '../../../../models/recipe.dart';


class Recipes extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<Recipe>? _recipes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text('Food Recipe')
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _recipes!.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              title: _recipes![index].name,
              cookTime: _recipes![index].totalTime,
              rating: _recipes![index].rating.toString(),
              thumbnailUrl: _recipes![index].images,
              ingredients: _recipes![index].ingredients.toList(),
            );
          },
        ));
  }
}