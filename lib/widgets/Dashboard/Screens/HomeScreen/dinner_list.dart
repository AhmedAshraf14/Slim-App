import 'package:flutter/material.dart';
import 'package:slim/models/dinner_model.dart';
import 'package:slim/models/db_modelDinner.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/dinner_card.dart';
class Dinnerlist extends StatelessWidget {
  // create an object of database connect
  // to pass down to todocard, first our todolist have to receive the functions
  final Function insertFunction;
  final Function deleteFunction;
  final db = DatabaseConnect();
  Dinnerlist(
      {required this.insertFunction, required this.deleteFunction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: db.getDinner(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data =
              snapshot.data; // this is the data we have to show. (list of todo)
          var datalength = data!.length;

          return datalength == 0
              ? const Center(
            child: Text('no data found'),
          )
              : ListView.builder(
            itemCount: datalength,
            itemBuilder: (context, i) => DinnerCard(
              id: data[i].id,
              title: data[i].title,
              creationDate: data[i].creationDate,
              isChecked: data[i].isChecked,
              insertFunction: insertFunction,
              deleteFunction: deleteFunction,
            ),
          );
        },
      ),
    );
  }
}