import 'dart:convert';
import 'package:chittchat/chat_screen.dart';
import 'package:chittchat/providers/user_provider.dart';
import 'package:chittchat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:chittchat/models/user.dart';
import 'package:chittchat/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chittchat/websocket_service.dart';
import 'package:chittchat/home_screen.dart'; // Add this import

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      User user = User(
        id: '',
        username: username,
        password: password,
        email: email,
        token: '',
      );

      print('Sending signup request with data: ${user.toJson()}');

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/auth/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('res: ${res}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response: ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          final responseBody = jsonDecode(res.body);
          print('Response Body : ${responseBody['id']}');

          if (responseBody != null) {
            final userId = responseBody['id'].toString();

            var my_receipent_id = '';
            if (userId == '2') {
              my_receipent_id = '18';
            } else if (userId == '18') {
              my_receipent_id = '2';
            }

            //init login message to websocket
            var _xf_web_socket = WebSocketService();
            _xf_web_socket.connect('ws://localhost:3000');

            _xf_web_socket.sendMessage('', my_receipent_id, userId, 'login');

            // Assuming the response has user ID in this path
            final token = responseBody['token'];

            // Save login state
            await prefs.setString('x-auth-token', token);
            await prefs.setString('userId', userId);
            await prefs.setString('recipientId', my_receipent_id);

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  userId: userId,
                  recipientId: my_receipent_id, // Modify as needed
                ),
              ),
              (route) => false,
            );
          } else {
            showSnackBar(context, 'Invalid login response');
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');
    await prefs.remove('userId');
    await prefs.remove('recipientId');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => HomeScreen()), // Navigate to HomeScreen
      (route) => false,
    );
  }

  Future<Map<String, String>?> getLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    String? userId = prefs.getString('userId');
    String? recipientId = prefs.getString('recipientId');
    if (token != null && userId != null && recipientId != null) {
      return {'token': token, 'userId': userId, 'recipientId': recipientId};
    }
    return null;
  }
}
