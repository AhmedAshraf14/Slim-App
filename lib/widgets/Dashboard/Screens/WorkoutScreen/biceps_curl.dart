import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slim/themes/theme_ui.dart';
import 'package:slim/services/workout_services.dart';
import 'package:slim/services/firestore_database.dart';
import 'package:slim/widgets/Dashboard/navigation_screen.dart';

class BicepCurls extends StatefulWidget {
  @override
  State<BicepCurls> createState() => _BicepCurlsState();
}

class _BicepCurlsState extends State<BicepCurls> {
  late String _responseMessage;
  late String _caloriesBurnt;
  late double _userWeight;
  WorkoutServices workoutServices = WorkoutServices();

  @override
  void initState() {
    super.initState();
    _responseMessage = "0";
    _caloriesBurnt = "0";
  }

  calculateReps() async {
    final _pickedFile = await workoutServices.getFile();
    setState(() {
      _responseMessage = "...";
      _caloriesBurnt = "...";
    });
    final _pickedFileCompressed = await workoutServices.compressFile(_pickedFile);
    final _response = await workoutServices.uploadFile(_pickedFileCompressed, "biceps");
    _userWeight = await DatabaseService().getWeight(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _responseMessage = _response;
      // MET formula
      _caloriesBurnt =
          ((6 * 3.5 * _userWeight / 200) * (double.parse(_responseMessage) * 2) / 60).toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Colors.green ,
        title: const Text("Slim"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                  'assets/workout_screen/bicep_icon_flipped.png',
                  scale: 3,
                ),
                Text(
                  " BICEP CURLS ",
                  style: FitnessAppTheme.workoutTitle,
                ),
                Image.asset(
                  'assets/workout_screen/bicep_icon.png',
                  scale: 3,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/workout_screen/counter.png',
                  scale: 1,
                ),

              ],
            ),



            Image.asset(
              'assets/workout_screen/bicep.gif',
              scale: 2,
            ),
          ],
        ),
      ),

    );
  }
}
