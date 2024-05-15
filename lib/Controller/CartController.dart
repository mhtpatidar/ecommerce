
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/CartItem.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  late SharedPreferences _prefs;
  late String _userToken;

  void setUserToken(String userToken) {
    _userToken = userToken;
  }

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void addToCart(int productId, String name, String image) {
    // Check if the product is already in the cart
    var index = cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      // Product already exists in the cart, update quantity
      cartItems[index].quantity++;
    } else {
      // Product doesn't exist in the cart, add it
      cartItems.add(CartItem(productId: productId, quantity: 1, name:name, image: image ));
    }
    // Save cart data to local storage
    saveCart();
  }

  Future<void> saveCart() async {
    List<String> cartData = cartItems.map((item) => '${item.productId}:${item.quantity}').toList();
    await _prefs.setStringList('cart_$_userToken', cartData);
  }

  Future<void> loadCart() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? cartData = _prefs.getStringList('cart_$_userToken');
    if (cartData != null) {
      cartItems.assignAll(cartData.map((item) {
        List<String> parts = item.split(':');
        return CartItem(productId: int.parse(parts[0]), quantity: int.parse(parts[1]), name: parts[2], image: parts[1]);
      }));
    }
  }
}
