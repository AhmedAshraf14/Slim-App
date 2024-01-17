import 'package:bloc/bloc.dart';
import 'package:slim/bloc/barcode/bar_item_event.dart';
import 'package:slim/bloc/barcode/bar_item_state.dart';
import 'package:slim/repositories/foodRepositories/barcode_repo.dart';

class BarCodeBloc extends Bloc<BarCodeEvent, BarCodeState> {
  final BarCodeRepository repository;

  BarCodeBloc(this.repository) : super(BarCodeInitial());
  late String foodToSearch;

  @override
  Stream<BarCodeState> mapEventToState(
    BarCodeEvent event,
  ) async* {
    if (event is FetchBarCodeItem) {
      yield BarCodeLoading();
      try {
        final items = await repository.searchFoods(event.barcode);
        yield BarCodeLoaded(items);
      } catch (e) {
        yield BarCodeLoadedError(e.toString());
      }
    }
  }
}
