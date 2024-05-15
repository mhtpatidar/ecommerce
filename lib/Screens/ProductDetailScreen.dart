import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/CartController.dart';
import '../Controller/ProductDetailController.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductDetailController productDetailController =
  Get.put(ProductDetailController());
  final CartController cartController = Get.put(CartController());
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    productDetailController.fetchProductDetail(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final product = productDetailController.product;
                if (product.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(product['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Product Title
                      Text(
                        product['title'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Product Category
                      Text(
                        'Category: ${product['category']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      // Product Price
                      Text(
                        'Price: \$${product['price']}',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 20),
                      // Product Description
                      Text(
                        product['description'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          final product = productDetailController.product;

          cartController.addToCart(productId, product['title'], product['image'] ); // Add product to cart
        },
        child: Icon(Icons.add_shopping_cart),
      ),

    );
  }
}
