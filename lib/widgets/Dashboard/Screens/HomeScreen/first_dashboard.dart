import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slim/services/auth.dart';
import 'package:slim/services/firestore_database.dart';
import 'package:slim/themes/theme_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/Grocery.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/breakfast.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/dinner.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/food_detection_model.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/lunch.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/workout_provider.dart';



class Dashboard extends StatelessWidget {
  List<String> dashboardHeaders = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Workout",
  ];
  DatabaseService dbService = DatabaseService();

  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String img =
        "https://icones.pro/wp-content/uploads/2021/04/icone-de-nourriture-noire-symbole-png.png";
    return Scaffold(
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, int index) {
            return Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: FitnessAppTheme.white,
                boxShadow: [
                  BoxShadow(
                    color: FitnessAppTheme.nearlyBlack.withOpacity(0.12),
                    blurRadius: 5.0,
                    spreadRadius: 1.1,
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Image.asset(
                            'assets/home_screen/icon' +
                                (index + 1).toString() +
                                '.png',
                            fit: BoxFit.fill,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(dashboardHeaders[index],
                              style: FitnessAppTheme.selectorBigTextAction),
                        ]),

                        ElevatedButton(
                          onPressed: () {
                            if (dashboardHeaders[index] == "Breakfast") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Breakfastpage()));
                            } else if (dashboardHeaders[index] == "Lunch") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Lunchpage()));
                            } else if (dashboardHeaders[index] == "Dinner") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Dinnerpage()));
                            } else if (dashboardHeaders[index] == "Workout") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const WorkoutProvider()));
                            }
                            

                          },
                          child: const Icon(Icons.add, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            primary: FitnessAppTheme.nearlyBlue,
                            onPrimary: Colors.black,
                          ),
                        ),
                        //CustomMealText(text: meals),
                      ],
                    ),
                    // map a list into a list of widgets
                    // make a stream builder for breakfast in firestore
                    StreamBuilder(
                        stream: DatabaseService().getUserDocStream(
                            id: FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data as DocumentSnapshot;
                            var meal =
                            data[dashboardHeaders[index].toLowerCase()];
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: meal.length,
                              itemBuilder: (context, curr) {
                                if (dashboardHeaders[index] == "Workout") {
                                  return Column(children: [
                                    Card(
                                      child: ListTile(
                                        title:
                                        Text(meal[curr]['name'].toString()),
                                        subtitle: Text(meal[curr]
                                        ['burnedCalories']
                                            .toString() +
                                            " kCal"),
                                        trailing: IconButton(
                                          icon:
                                          const Icon(Icons.delete_outline),
                                          onPressed: () {
                                            DatabaseService()
                                                .deleteWorkoutFromFirestoreUser(
                                                id: FirebaseAuth.instance
                                                    .currentUser!.uid,
                                                index: curr,
                                                calories: meal[curr]
                                                ['burnedCalories']);
                                          },
                                        ),
                                      ),
                                    ),
                                  ]);
                                } else {
                                  return Column(children: [
                                    Card(
                                      margin: const EdgeInsets.all(3),
                                      elevation: 1,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color:
                                              FitnessAppTheme.nearlyWhite,
                                              width: 1)),
                                      child: ListTile(
                                        title: Wrap(
                                          children: [
                                            Text(meal[curr]['name'].toString()),
                                          ],
                                        ),
                                        leading: Image.network(
                                          meal[curr]['photo'] ?? img,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.network(img);
                                          },
                                        ),
                                        subtitle: Text(
                                            meal[curr]['calories'].toString() +
                                                " kCal"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                dbService.addFoodToFavoriteList(
                                                  id: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  index: curr,
                                                  name: meal[curr]['name'],
                                                  calories: meal[curr]
                                                  ['calories'],
                                                  fats: meal[curr]['fat'],
                                                  carbs: meal[curr]['carbs'],
                                                  proteins: meal[curr]
                                                  ['protein'],
                                                  quantity: meal[curr]
                                                  ['quantity'],
                                                  photo: meal[curr]['photo'],
                                                );
                                                AuthenticationService.snackbar(
                                                    meal[curr]['name'] +
                                                        " is added to favourites",
                                                    Icons.add,
                                                    Colors.green,
                                                    context);
                                              },
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.pink,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete_outline),
                                              onPressed: () {
                                                dbService
                                                    .deleteMealFromFirestoreUser(
                                                    id: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    type: dashboardHeaders[
                                                    index],
                                                    index: curr);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]);
                                }
                              },
                            );
                          } else {
                            return const Text(" ");
                          }
                        }),
                  ]),
            );
          }),
    );
  }
}
