import 'package:flutter/material.dart';
import 'package:slim/models/lunch_model.dart';
import 'package:slim/models/db_modelLunch.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/add_lunch.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/lunch_card.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/lunch_list.dart';
class Lunchpage extends StatefulWidget {
  const Lunchpage({Key? key}) : super(key: key);

  @override
  _LunchpageState createState() => _LunchpageState();
}
class _LunchpageState extends State<Lunchpage> {
// we have to create our functions here, where the two widgets can communicate

// create a database object so we can access database functions
  var db = DatabaseConnect();

// function to add todo
  void addItem(Lunch lunch) async {
    await db.insertlunch(lunch);
    setState(() {});
  }
  void deleteItem(Lunch lunch) async {
    await db.deletelunch(lunch);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunch Meals'),
        backgroundColor:Colors.green ,
      ),
      backgroundColor: const Color(0xFFF5EBFF),
      body: Column(
        children: [
         Lunchlist(insertFunction: addItem, deleteFunction: deleteItem),
          // we will add our widgets here.
          AddLunch(insertFunction: addItem),
        ],
      ),
    );
  }
}


