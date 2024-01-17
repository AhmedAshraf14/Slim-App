import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:slim/services/firestore_database.dart';
import 'package:slim/themes/theme_ui.dart';

class CaloriesIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder(
            stream: DatabaseService()
                .getUserDocStream(id: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as DocumentSnapshot;
                var remainingCalories =
                    double.parse(data['remainingCalories'].toString()).toInt();
                var recoCalories =
                    double.parse(data['calories'].toString()).toInt();
                double caloriesPercent =
                    (recoCalories - remainingCalories) / recoCalories;
                if (caloriesPercent < 0) {
                  caloriesPercent = 0;
                } else if (caloriesPercent > 1) {
                  caloriesPercent = 1;
                }
return
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CircularPercentIndicator(
                      radius: constraints.maxHeight * 0.4,
                      percent: caloriesPercent,
                      backgroundWidth: 6,
                      lineWidth: 16,
                      animation: true,
                      animationDuration: 2000,
                      backgroundColor: Colors.black26,
                      linearGradient: LinearGradient(colors: <Color>[
                        Colors.red.withOpacity(0.1),
                        Colors.red.withOpacity(0.2),
                        Colors.red.withOpacity(0.3),
                        Colors.red.withOpacity(0.4),
                        Colors.red.withOpacity(0.5),
                        Colors.blue.withOpacity(0.6),
                        Colors.blue.withOpacity(0.7),
                        Colors.blue.withOpacity(0.8),
                        Colors.blue.withOpacity(0.9),
                        Colors.blue.withOpacity(1),
                      ]),
                      rotateLinearGradient: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      widgetIndicator: Image.asset(
                        "assets/home_screen/Plate.png",
                        scale: 4,
                      ),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            remainingCalories.toString(),
                            style: FitnessAppTheme.caloriesIndicatorValue,
                          ),
                          Text(
                            " kCal left",
                            style: FitnessAppTheme.caloriesIndicatorUnit,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Text(
                  "",
                  style: FitnessAppTheme.caloriesIndicatorValue,
                );
              }
            });
      },
    );
  }
}
