import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:slim/bloc/postapi/post_food_item_bloc.dart';
import 'package:slim/bloc/search/search_bloc.dart';
import 'package:slim/bloc/search/search_event.dart';
import 'package:slim/bloc/search/search_state.dart';
import 'package:slim/models/food_data_model.dart';
import 'add_food_screen.dart';

class FoodSearch extends SearchDelegate<List?> {
  late Items items;
  List<Hints> allHintsItems = [];
  late String queryString;
  late String foodId = '';
  late String measureUri = '';

  SearchBloc searchBloc;
  int foodtype; //type of food from the enum

  FoodSearch({required this.searchBloc, required this.foodtype});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    String img =
        "https://icones.pro/wp-content/uploads/2021/04/icone-de-nourriture-noire-symbole-png.png";
    String errorImg =
        "https://www.edamam.com/food-img/963/9633e24decdc42ed674fdc787623b492.png";
    searchBloc.add(Search(query: query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is SearchLoaded) {
          items = (state).recipes;
          allHintsItems = items.hints;

          if (items.parsed.isEmpty) {
            return const Center(
              child: Text('There is no food item with this name'),
            );
          } else {
            foodId = items.parsed[0].food!.foodId;
            measureUri = items.hints[0].measures[0].uri;

            if (state.recipes.hints.isEmpty) {
              return const Center(
                child: Text('No Results'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blueGrey.shade100, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        child: ListTile(
                          leading: Image.network(
                            state.recipes.hints[index].food.image ?? img,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.network(img);
                            },
                          ),
                          title: Text(state.recipes.hints[index].food.label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "SourceSansPro",
                                  fontSize: 20.0,
                                  color: Colors.blue)),
                          subtitle: Text(state.recipes.hints[index].food
                                  .nutrients.enercKcal!
                                  .toStringAsFixed(1) +
                              " KCAL"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFoodScreen(
                                  calculateFoodBloc:
                                      BlocProvider.of<CalculateFoodBloc>(
                                          context),
                                  foodLabel: items.hints[index].food.label,
                                  foodID: items.hints[index].food.foodId,
                                  foodtype: foodtype,
                                  foodPicture: items.hints[index].food.image ??
                                      "https://icon-library.com/images/food-icon-png/food-icon-png-1.jpg",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                itemCount: allHintsItems.length,
              );
            }
          }
        } else if (state is SearchInitial) {
          return loadingindicator();
        } else {
          return loadingindicator();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  loadingindicator() {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
          colors: [Colors.blue],
        ),
      ),
    );
  }
}
