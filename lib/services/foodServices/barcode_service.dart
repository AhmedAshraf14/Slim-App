import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:slim/models/food_data_model.dart';

final baseApi =
    'https://api.edamam.com/api/food-database/v2/parser?app_id=923b5c56&app_key=8f43167e9a47f5f2e89b037655a08552';
//but without the food to search

class BarCodeServices {
  Future<Items> retrieveUPCitem(String barcode) async {
    String api = baseApi + '&upc=$barcode';
    http.Response itemResponse = await http.get(Uri.parse(api));
    if (itemResponse.statusCode == 200) {
      return Items.fromJson(json.decode(itemResponse.body));
    } else {
      throw Exception('Cant retrieve this item');
    }
  }
}
