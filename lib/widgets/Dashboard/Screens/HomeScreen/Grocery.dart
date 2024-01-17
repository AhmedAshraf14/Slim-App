import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/add_grocery.dart';
class Grocery extends StatelessWidget {
  const Grocery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Slim"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width ,
      ),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add,color:Colors.white),
          backgroundColor: Theme.of(context).primaryColor ,
          onPressed:(){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>AddGrocery()));
          }),

    );
  }
}
