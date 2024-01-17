import 'package:slim/models/food_data_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final Items recipes;
  SearchLoaded(this.recipes);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
