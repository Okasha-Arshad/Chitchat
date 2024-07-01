import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String password;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ??
          '', // Ensure id is non-null and convert to string
      username: map['username'] ?? '', // Ensure username is non-null
      email: map['email'] ?? '', // Ensure email is non-null
      token: map['token'] ?? '', // Ensure token is non-null
      password: map['password'] ?? '', // Ensure password is non-null
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
