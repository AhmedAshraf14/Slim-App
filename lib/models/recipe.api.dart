import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:slim/models/recipe.dart';

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "24", "start": "0", "tag": "list.recipe.popular"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "d66dbc83dcmshcffb1f150f37f06p1657aajsn4be5b3b05144",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List<dynamic> ingredientLines = [];
    List temp = [];
    List wholeLine = [];

    for (var i in data['feed']) {
      temp.add(i['content']['details']);
      ingredientLines.add(i['content']['ingredientLines']);
    }

    var k=0;

    for (var i in temp){
      List details = [];
      List tempWholeLine = [];
      details.add(i['name']);
      details.add(i['totalTime']);
      details.add(i['images'][0]['hostedLargeUrl']);
      details.add(i['rating']);
      for(var j in ingredientLines[k]){
        tempWholeLine.add(j['wholeLine']);
      }
      details.add(tempWholeLine);

      k++;
      wholeLine.add(details);

    }

    return Recipe.recipesFromSnapshot(wholeLine);
  }
}
