import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductDetailController extends GetxController {
  RxMap<String, dynamic> product = <String, dynamic>{}.obs;

  Future<void> fetchProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        product.value = decodedData;
      }
    } catch (e) {
      print('Exception while fetching product details: $e');
    }
  }
}
