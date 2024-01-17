import 'package:slim/models/food_data_model.dart';
import 'package:slim/services/foodServices/barcode_service.dart';

class BarCodeRepository {
  final BarCodeServices barCodeServices;

  BarCodeRepository(this.barCodeServices);

  Future<Items> searchFoods(String barcode) async {
    final fooditems = barCodeServices.retrieveUPCitem(barcode);
    // print(fooditems);
    return fooditems;
  }
}
