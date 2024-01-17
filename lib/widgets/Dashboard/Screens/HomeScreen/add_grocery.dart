import 'package:flutter/material.dart';

class AddGrocery extends StatefulWidget {
  @override
  _AddGrocery createState() => _AddGrocery();
}

class _AddGrocery extends State<AddGrocery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(centerTitle: true, title: const Text("New Groceries")),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Enter the needed Groceries',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.purple.shade100;
                          return Theme.of(context).primaryColor;
                        })),
                    child: Text(
                      'Add Grocery',
                    ),
                    onPressed: () {},
                  ))
            ],
          )),
    );
  }
}
