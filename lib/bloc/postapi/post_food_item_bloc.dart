import 'package:bloc/bloc.dart';
import 'package:slim/bloc/postapi/post_food_item_event.dart';

import 'package:slim/bloc/postapi/post_food_item_state.dart';
import 'package:slim/repositories/foodRepositories/food_repo.dart';

class CalculateFoodBloc extends Bloc<calculateItemsEvent, FoodItemState> {
  final FoodRepository repository;
  CalculateFoodBloc(this.repository) : super(FoodItemInitial());
  late String food;
  @override
  Stream<FoodItemState> mapEventToState(
    calculateItemsEvent event,
  ) async* {
    if (event is FoodItemEvent) {
      yield FoodItemLoading();
      try {
        final items =
            await repository.getAllCalculatedFood(event.quantity, event.foodId);
        yield FoodItemLoaded(items);
      } catch (e) {
        yield FoodItemError(e.toString());
      }
    }
  }
}
