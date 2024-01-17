import 'package:flutter/material.dart';
import 'package:slim/models/breakfast_model.dart';
import 'package:slim/models/db_model.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/add_breakfast.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/breakfast_card.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/breakfast_list.dart';
class Breakfastpage extends StatefulWidget {
  const Breakfastpage({Key? key}) : super(key: key);

  @override
  _BreakfastpageState createState() => _BreakfastpageState();
}
class _BreakfastpageState extends State<Breakfastpage> {
// we have to create our functions here, where the two widgets can communicate

// create a database object so we can access database functions
var db = DatabaseConnect();

// function to add todo
void addItem(BreakFast breakfast) async {
await db.insertbreakfast(breakfast);
setState(() {});
}
  void deleteItem(BreakFast breakfast) async {
    await db.deletebreakfast(breakfast);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breakfast Meals'),
        backgroundColor:Colors.green ,
      ),
      backgroundColor: const Color(0xFFF5EBFF),
      body: Column(
        children: [
          Breakfastlist(insertFunction: addItem, deleteFunction: deleteItem),
          // we will add our widgets here.
          AddBreakfast(insertFunction: addItem),
        ],
      ),
    );
  }
}


