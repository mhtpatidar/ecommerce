import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../Controller/CartController.dart';
import 'package:get/get.dart';



class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text('Your cart is empty'),
          );
        } else {
          return ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartController.cartItems[index];
              return ListTile(
                leading: Image.network(cartItem.image),
                title: Text(cartItem.name),
                subtitle: Text('Quantity: ${cartItem.quantity}'),
              );
            },
          );
        }
      }),
    );
  }
}