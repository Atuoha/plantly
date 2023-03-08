import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String fullname;
  final String password;
  final String authType;
  final String profileUrl;

  const User({
    required this.email,
    required this.fullname,
    required this.password,
    required this.authType,
    required this.profileUrl,
  });

  factory User.initial() => const User(
        email: "",
        fullname: "",
        password: "",
        authType: "",
        profileUrl: "",
      );

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>;

    return User(
      email: userData['email'],
      fullname: userData['fullname'],
      password: userData['password'],
      authType: userData['authType'],
      profileUrl: userData['profileUrl'],
    );
  }

  @override
  List<Object?> get props => [
        email,
        fullname,
        password,
        authType,
        profileUrl,
      ];

  @override
  String toString() {
    return 'User{email: $email, fullname: $fullname, password: $password, authType: $authType, profileUrl: $profileUrl}';
  }

  User copyWith({
    String? email,
    String? fullname,
    String? password,
    String? authType,
    String? profileUrl,
  }) {
    return User(
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      password: password ?? this.password,
      authType: authType ?? this.authType,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
