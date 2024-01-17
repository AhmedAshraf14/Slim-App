import 'package:flutter/material.dart';
import 'package:slim/models/dinner_model.dart';
import 'package:slim/models/db_modelDinner.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/add_dinner.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/dinner_card.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/dinner_list.dart';
class Dinnerpage extends StatefulWidget {
  const Dinnerpage({Key? key}) : super(key: key);

  @override
  _DinnerpageeState createState() => _DinnerpageeState();
}
class _DinnerpageeState extends State<Dinnerpage> {
// we have to create our functions here, where the two widgets can communicate

// create a database object so we can access database functions
  var db = DatabaseConnect();

// function to add todo
  void addItem(Dinner dinner) async {
    await db.insertDinner(dinner);
    setState(() {});
  }
  void deleteItem(Dinner dinner) async {
    await db.deleteDinner(dinner);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinner Meals'),
        backgroundColor:Colors.green ,
      ),
      backgroundColor: const Color(0xFFF5EBFF),
      body: Column(
        children: [
          Dinnerlist(insertFunction: addItem, deleteFunction: deleteItem),
          // we will add our widgets here.
          AddDinner(insertFunction: addItem),
        ],
      ),
    );
  }
}


