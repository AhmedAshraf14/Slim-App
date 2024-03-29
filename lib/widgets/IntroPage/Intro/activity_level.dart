import 'package:flutter/material.dart';
import 'package:slim/themes/theme_ui.dart';
import 'custom_radio_activity.dart';

class ActivityLevelForm extends StatefulWidget {
  const ActivityLevelForm({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final Function(double workModel) onComplete;

  @override
  _ActivityLevelFormState createState() => _ActivityLevelFormState();
}

class _ActivityLevelFormState extends State<ActivityLevelForm> {
  double _activityLevel = 1.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text("Slim"),
        backgroundColor:Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: const [
                Text(
                  'Activity Level',
                  style: FitnessAppTheme.headlineBlue,
                ),
                Text(
                  'Choose your Activity Level',
                  style: FitnessAppTheme.subtitle,
                ),
              ],
            ),
            CustomRadioActivity(
              onSelect: (activityLevel) {
                setState(() {
                  _activityLevel = activityLevel;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: 200,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(FitnessAppTheme.nearlyBlue),
                      foregroundColor:
                          MaterialStateProperty.all(FitnessAppTheme.white)),
                  child: const Text(
                    'Continue',
                  ),
                  onPressed: () {
                    widget.onComplete(_activityLevel);
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
