import 'dart:convert';
import 'package:chittchat/models/user.dart';
import 'package:chittchat/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<List<User>> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.uri}/api/auth/users'));

      if (response.statusCode == 200) {
        List<dynamic> usersJson = jsonDecode(response.body);
        print('Fetched users: $usersJson'); // Log the fetched users
        return usersJson.map((json) => User.fromMap(json)).toList();
      } else {
        print('Failed to load users: ${response.statusCode}');
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error fetching users: $error');
      throw Exception('Failed to load users');
    }
  }

  Future<void> saveUserDetails(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('x-auth-token', user.token);
  }
}
