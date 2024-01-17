/*import 'dart:convert';
import 'package:http/http.dart';
import 'package:slim/models/food_data_model.dart';

const baseApi =
    'https://api.edamam.com/api/food-database/v2/parser?app_id=923b5c56&app_key=8f43167e9a47f5f2e89b037655a08552';
//but without the food to search

class SearchWebServices {
  Future<Items> searchItem(String query) async {
    String api = baseApi + '&ingr=$query';

    Response itemResponse = await get(Uri.parse(api));

    if (itemResponse.statusCode == 200) {
      return Items.fromJson(json.decode(itemResponse.body));
    } else {
      throw Exception('Cant retrieve this item');
    }
  }
}
*/
import 'dart:convert';
import 'package:http/http.dart';
import 'package:slim/models/food_data_model.dart';

const baseApi = 'https://api.calorieninjas.com/v1/nutrition?query=';
const apiKey = 'iv1p6EOiOvRC1BmaWMaD+A==ZbwvFOio5cArkcRD';

class SearchWebServices {
  Future<Items> searchItem(String query) async {
    String api = baseApi + query;
    Map<String, String> headers = {'X-Api-Key': apiKey};
    Response response = await get(Uri.parse(api), headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Items items = Items.fromJson(data['items']);
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  }
}