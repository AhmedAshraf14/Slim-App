import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slim/bloc/barcode/bar_item_bloc.dart';
import 'package:slim/bloc/postapi/post_food_item_bloc.dart';
import 'package:slim/bloc/search/search_bloc.dart';
import 'package:slim/repositories/foodRepositories/barcode_repo.dart';
import 'package:slim/repositories/foodRepositories/food_repo.dart';
import 'package:slim/repositories/foodRepositories/search_repo.dart';
import 'package:slim/services/foodServices/barcode_service.dart';
import 'package:slim/services/foodServices/post_food_service.dart';
import 'package:slim/services/foodServices/search_service.dart';
import 'package:slim/widgets/FoodAPI/foodscreen.dart';

class FoodMain extends StatelessWidget {
  // This widget is the root of your application.
  final int foodtype;
  const FoodMain({required this.foodtype});

  @override
  Widget build(BuildContext myAppContext) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (searchBloccontext) =>
                SearchBloc(SearchRepository(SearchWebServices())),
          ),
          BlocProvider(
            create: (barBloccontext) =>
                BarCodeBloc(BarCodeRepository(BarCodeServices())),
          ),
          BlocProvider(
            create: (calculateBlocContext) =>
                CalculateFoodBloc(FoodRepository(FoodWebServices())),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Foodie App',
          home: FoodScreen(
              foodtype: foodtype), //1 here means index of second enum lunch
        ));
  }
}
