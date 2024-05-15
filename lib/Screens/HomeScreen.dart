import 'package:ecommerce/Screens/CartScreen.dart';
import 'package:ecommerce/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/ProductController.dart';
import 'ProductDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    load();
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      productController.fetchMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  productController.fetchProducts(); // Reset product list when search field is cleared
                },
              ),
            ),
            onChanged: (query) {
              productController.searchProducts(query);
            },
          ),
        ),
        actions: [
         /* IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch(context: context, delegate: ProductSearchDelegate(productController));
              if (query != null) {
                _searchController.text = query;
                productController.searchProducts(query);
              }
            },
          ),*/
         /* Container(
            width: 200,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
              ),
              onChanged: (query) {
                productController.searchProducts(query);
              },
            ),
          ),*/
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(CartScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 8.0,
                children: List.generate(
                  productController.categoryList.length,
                      (index) => GestureDetector(
                    onTap: () {
                      productController.filterProductsByCategory(productController.categoryList[index]);
                    },
                    child: Chip(
                      label: Text(productController.categoryList[index]),
                      backgroundColor: productController.likedCategories.contains(productController.categoryList[index]) ? Colors.blue : Colors.grey[200],
                      labelStyle: TextStyle(color: productController.likedCategories.contains(productController.categoryList[index]) ? Colors.white : Colors.black),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            (productController.productList.isEmpty)?
            Center(child: Text('No items found for the selected category.'))
            :Expanded(
              child: GridView.builder(
                controller: _scrollController,
                itemCount: productController.productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  final product = productController.productList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(ProductDetailScreen(productId: product['id']));
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ]);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Call the logout method when FloatingActionButton is pressed
          _prefs.setString("token", "");
          Get.off(LoginScreen());
        },
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      ),
    );
  }
}

// Search delegate class for product search
class ProductSearchDelegate extends SearchDelegate<String> {
  final ProductController productController;

  ProductSearchDelegate(this.productController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          productController.searchProducts('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Implement your search results UI here
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : productController.productList.where((product) => product['title'].toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index];
        return ListTile(
          title: Text(product['title']),
          onTap: () {
            close(context, product['title']);
          },
        );
      },
    );
  }
}


