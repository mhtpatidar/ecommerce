import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var productList = <Map<String, dynamic>>[].obs;
  var categoryList = <String>[].obs;
  RxList<String> likedCategories = <String>[].obs;
  int limit = 5;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts({int limit = 5 }) async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=$limit'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(decodedData);
        productList.value = products;
      }
    } catch (e) {
      print('Exception while fetching products: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        final List<String> categories = List<String>.from(decodedData);
        categoryList.value = categories;
      }
    } catch (e) {
      print('Exception while fetching categories: $e');
    }
  }



  // Method to fetch more products with a specified limit
  Future<void> fetchMoreProducts() async {
    limit += 5; // Increase the limit by 5
    await fetchProducts(limit: limit);
  }

  void filterProductsByCategory(String category) {
    if (likedCategories.contains(category)) {
      likedCategories.remove(category);
    } else {
      likedCategories.add(category);
    }
    if (likedCategories.isEmpty) {
      fetchProducts();
      return;
    }
    final filteredProducts = productList.where((product) => likedCategories.contains(product['category'])).toList();
    productList.value = filteredProducts;
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      fetchProducts();
      return;
    }
    fetchProducts(); // Reset product list to original
    final filteredProducts = productList.where((product) => product['title'].toLowerCase().contains(query.toLowerCase())).toList();
    productList.value = filteredProducts;
  }
}
