import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:productapp/data/models/product.dart';

class HttpHelper {
  final String urlBase =
      'https://dummyjson.com';

Future<List<Product>?> getRestaurants() async {
    const String endpoint = '/products';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if(response.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(response.body);
      final List<dynamic> productMap = jsonResponse['products'];
      final List<Product> products = productMap.map((map) => Product.fronJson(map)).toList();
      return products;
    } else {
      return null;
    }
}

} 