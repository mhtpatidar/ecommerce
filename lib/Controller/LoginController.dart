import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CartController.dart';


class LoginController extends GetxController {

  final CartController cartController = Get.put(CartController());
  late SharedPreferences _prefs;

  var username = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadController();
  }

  Future<void> loadController() async {
    _prefs = await SharedPreferences.getInstance();

  }

  void setUsername(String value) => username.value = value;
  void setPassword(String value) => password.value = value;

  Future<void> login() async {
    isLoading.value = true; // Set isLoading to true when login starts
    try {

      String jsonData = json.encode({
        'username': username.value,
        'password': password.value,
      });
      final uri = Uri.parse('https://fakestoreapi.com/auth/login');

     /* var jsonData = json.encode({
        'username': 'mor_2314',
        'password': '83r5^_',
      });*/

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );


      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        _prefs.setString("token", responseData['token'].toString());
        cartController.setUserToken(responseData['token'].toString()); // Set user token

        Get.offAllNamed('/home');
      } else if (response.statusCode == 401) {
        // Unauthorized user
        throw 'Unauthorized user';
      } else {
        // Other errors
        throw 'An error occurred';
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      throw e; // Rethrow the error to be caught by the caller
    } finally {
      isLoading.value = false;
    }
  }
}
