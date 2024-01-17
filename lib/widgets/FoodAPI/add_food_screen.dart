import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slim/bloc/postapi/post_food_item_bloc.dart';
import 'package:slim/bloc/postapi/post_food_item_event.dart';
import 'package:slim/bloc/postapi/post_food_item_state.dart';
import 'package:slim/widgets/Dashboard/navigation_screen.dart';
import 'package:slim/services/firestore_database.dart';
import 'package:slim/themes/theme_ui.dart';

class AddFoodScreen extends StatefulWidget {
  late String foodLabel;
  late String foodID;
  late String foodPicture;

  late int foodtype;
  CalculateFoodBloc calculateFoodBloc;

  List<String> nutrients = [
    "Calories",
    "Carbs",
    "Fibers",
    "Sugars",
    "Cholesterol",
    "Fats",
    "Sat Fats",
    "Trans Fats",
    "Mono Fats",
    "Poly Fats",
    "Protein",
    "Sodium",
    "Magnesium",
    "Potassium",
    "Iron",
    "Water",
  ];

  AddFoodScreen(
      {required this.calculateFoodBloc,
      required this.foodLabel,
      required this.foodID,
      required this.foodtype,
      required this.foodPicture});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  late num foodQuantity;
  late double totalCalories;
  late double carbs;
  late double protein;
  late double fats;
  late int foodtype;
  late String foodphotos;

  @override
  void initState() {
    super.initState();
    foodQuantity = 0;
    totalCalories = 0;
    carbs = 0;
    protein = 0;
    fats = 0;
    foodtype = widget.foodtype;
    foodphotos = widget.foodPicture;
    widget.calculateFoodBloc.add(
      calculateItemsEvent(
        quantity: 0,
        foodId: widget.foodID,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Add Food",
          style: FitnessAppTheme.AppBar1,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            pinned: true,
            title: Text(
              widget.foodLabel,
              style: FitnessAppTheme.silverAppBar1,
            ),
          ),
          // BlocBuilder<CalculateFoodBloc, FoodItemState>(
          //   builder: (context, state) {
          //     if (state is FoodItemLoading) {
          //       return const CircularProgressIndicator();
          //     } else if (state is FoodItemLoaded) {
          //     } else if (state is FoodItemError) {
          //       return Text(state.message);
          //     }
          //     return const CircularProgressIndicator();
          //   },
          // ),
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Total Calories",
                    style: FitnessAppTheme.totalCaloriesTitle,
                  ),
                  BlocBuilder<CalculateFoodBloc, FoodItemState>(
                    builder: (context, state) {
                      if (state is FoodItemLoading) {
                        return const Text(
                          "",
                          style: FitnessAppTheme.totalCaloriesNumber,
                        );
                      } else if (state is FoodItemLoaded) {
                        totalCalories =
                            double.parse(state.items.calories.toString());
                        return Text(
                          state.items.calories.toString(),
                          style: FitnessAppTheme.totalCaloriesNumber,
                        );
                      } else if (state is FoodItemError) {
                        return Text(state.message);
                      }
                      return const Text(
                        "",
                        style: FitnessAppTheme.totalCaloriesNumber,
                      );
                    },
                  ),
                  const Text(
                    "KCal",
                    style: FitnessAppTheme.totalCaloriesUnit,
                  ),
                ],
              ),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 0.5),
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Quantity",
                      style: FitnessAppTheme.quantityText,
                    ),
                  ),
                  Container(
                    //color: Colors.yellow,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                    child: TextField(
                      maxLines: 1,
                      showCursor: true,
                      keyboardType: TextInputType.number,
                      style: FitnessAppTheme.textFieldText,
                      decoration: InputDecoration(
                        icon: Image.asset(
                          "assets/add_food_screen/scale.png",
                          scale: 2.5,
                        ),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        hintText: "Enter quantity in grams",
                        hintStyle: FitnessAppTheme.textFieldHint,
                      ),
                      onChanged: (String value) {
                        if (value == "") {
                          value = "0";
                        }
                        //abdelnasser space input isnt handled
                        setState(() {
                          foodQuantity = num.parse(value);
                        });
                        widget.calculateFoodBloc.add(
                          calculateItemsEvent(
                            quantity: foodQuantity,
                            foodId: widget.foodID,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Nutrition Facts",
                      style: FitnessAppTheme.nutritionFactsText,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: [
                                Image.asset(
                                  "assets/add_food_screen/carbs.png",
                                  scale: 3,
                                ),
                                const Text(
                                  " Carbs",
                                  style: FitnessAppTheme.nutrientsText,
                                ),
                              ],
                            ),
                            BlocBuilder<CalculateFoodBloc, FoodItemState>(
                              builder: (context, state) {
                                if (state is FoodItemLoading) {
                                  return const Text(
                                    "",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemLoaded) {
                                  carbs = double.parse(state
                                      .items
                                      .totalNutrients!
                                      .nutrientsValuesMap["Carbs"]);
                                  return Text(
                                    "${state.items.totalNutrients!.nutrientsValuesMap["Carbs"]} gm",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemError) {
                                  return Text(state.message);
                                }
                                return const Text(
                                  "",
                                  style: FitnessAppTheme.nutrientsValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: [
                                Image.asset(
                                  "assets/add_food_screen/protein.png",
                                  scale: 3,
                                ),
                                const Text(
                                  " Protein",
                                  style: FitnessAppTheme.nutrientsText,
                                ),
                              ],
                            ),
                            BlocBuilder<CalculateFoodBloc, FoodItemState>(
                              builder: (context, state) {
                                if (state is FoodItemLoading) {
                                  return const Text(
                                    "",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemLoaded) {
                                  protein = double.parse(state
                                      .items
                                      .totalNutrients
                                      ?.nutrientsValuesMap["Protein"]);
                                  return Text(
                                    "${state.items.totalNutrients?.nutrientsValuesMap["Protein"]} gm",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemError) {
                                  return Text(state.message);
                                }
                                return const Text(
                                  "",
                                  style: FitnessAppTheme.nutrientsValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: [
                                Image.asset(
                                  "assets/add_food_screen/fats.png",
                                  scale: 3,
                                ),
                                const Text(
                                  " Fats",
                                  style: FitnessAppTheme.nutrientsText,
                                ),
                              ],
                            ),
                            BlocBuilder<CalculateFoodBloc, FoodItemState>(
                              builder: (context, state) {
                                if (state is FoodItemLoading) {
                                  return const Text(
                                    "",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemLoaded) {
                                  fats = double.parse(state.items.totalNutrients
                                      ?.nutrientsValuesMap["Fats"]);
                                  return Text(
                                    "${state.items.totalNutrients?.nutrientsValuesMap["Fats"]} gm",
                                    style: FitnessAppTheme.nutrientsValue,
                                  );
                                } else if (state is FoodItemError) {
                                  return Text(state.message);
                                }
                                return const Text(
                                  "",
                                  style: FitnessAppTheme.nutrientsValue,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.nutrients[index],
                        style: FitnessAppTheme.nutrientsList,
                      ),
                      BlocBuilder<CalculateFoodBloc, FoodItemState>(
                        builder: (context, state) {
                          if (state is FoodItemLoading) {
                            return const Text(
                              "",
                              style: FitnessAppTheme.nutrientsListValue,
                            );
                          } else if (state is FoodItemLoaded) {
                            return Text(
                              "${state.items.totalNutrients!.nutrientsValuesMap.values.toList()[index]}",
                              style: FitnessAppTheme.nutrientsListValue,
                            );
                          } else if (state is FoodItemError) {
                            return Text(state.message);
                          }
                          return const Text(
                            "",
                            style: FitnessAppTheme.nutrientsListValue,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              childCount: widget.nutrients.length,
            ),
          ),
        ],
      ),
      //////------>>>>>> Add food button
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.add_circle_outline, color: Colors.white,),
              Text(
                "  Add to daily macros",
                style: FitnessAppTheme.addFood,
              ),
            ],
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )),
            fixedSize: MaterialStateProperty.all(Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.06,
            )),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            // side: MaterialStateProperty.all(const BorderSide(color: Colors.blue, width: 2)),
            overlayColor: MaterialStateProperty.all(Colors.white),
          ),
          // Checked and working
          onPressed: () {
            if (foodQuantity.toDouble() == 0) {
              //widget called dialogue widget
            } else {
              if (foodtype == 1) {
                DatabaseService().addBreakfastToFirestoreUser(
                    photo: foodphotos,
                    calories: totalCalories,
                    name: widget.foodLabel,
                    carbs: carbs,
                    protein: protein,
                    fat: fats,
                    quantity: foodQuantity.toDouble(),
                    date: DateTime.now(),
                    id: FirebaseAuth.instance.currentUser!.uid);
                //         Navigator.of(context).popUntil(ModalRoute.withName('/sucess'));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TabBarPage()),
                    ModalRoute.withName('/success'));
              } else if (foodtype == 2) {
                DatabaseService().addLunchToFirestoreUser(
                    photo: foodphotos,
                    calories: totalCalories,
                    name: widget.foodLabel,
                    carbs: carbs,
                    protein: protein,
                    fat: fats,
                    quantity: foodQuantity.toDouble(),
                    date: DateTime.now(),
                    id: FirebaseAuth.instance.currentUser!.uid);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TabBarPage()),
                    ModalRoute.withName('/success'));
              } else {
                DatabaseService().addDinnerToFirestoreUser(
                    photo: foodphotos,
                    calories: totalCalories,
                    name: widget.foodLabel,
                    carbs: carbs,
                    protein: protein,
                    fat: fats,
                    quantity: foodQuantity.toDouble(),
                    date: DateTime.now(),
                    id: FirebaseAuth.instance.currentUser!.uid);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TabBarPage()),
                    ModalRoute.withName('/success'));
              }
            }
          },
        ),
      ),
    );
  }
}
