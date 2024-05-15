import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/CartController.dart';
import '../Controller/LoginController.dart';

class LoginScreen extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: _controller.setUsername,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: _controller.setPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            Obx(() {
              return _controller.isLoading.value
                  ? CircularProgressIndicator() // Show loading indicator if isLoading is true
                  : ElevatedButton(
                onPressed: () {
                  if (_controller.username.isEmpty || _controller.password.isEmpty) {
                    // Show error message if any of the fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter username and password.'),
                      ),
                    );
                  } else {
                    // Perform login if both fields are not empty
                    _controller.login().catchError((error) {
                      // Display a Snackbar for errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('An error occurred: $error'),
                        ),
                      );
                    });
                  }

                },
                child: Text('Login'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
