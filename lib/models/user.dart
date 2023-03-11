import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String fullname;
  final String password;
  final String authType;
  final String profileImg;

  const User({
    required this.email,
    required this.fullname,
    required this.password,
    required this.authType,
    required this.profileImg,
  });

  factory User.initial() => const User(
        email: "",
        fullname: "",
        password: "",
        authType: "",
    profileImg: "",
      );

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>;

    return User(
      email: userData['email'],
      fullname: userData['fullname'],
      password: "",
      authType: userData['auth_type'],
      profileImg: userData['profileImg'],
    );
  }

  @override
  List<Object?> get props => [
        email,
        fullname,
        password,
        authType,
    profileImg,
      ];

  @override
  String toString() {
    return 'User{email: $email, fullname: $fullname, password: $password, authType: $authType, profileImg: $profileImg}';
  }

  User copyWith({
    String? email,
    String? fullname,
    String? password,
    String? authType,
    String? profileImg,
  }) {
    return User(
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      password: password ?? this.password,
      authType: authType ?? this.authType,
      profileImg: profileImg ?? this.profileImg,
    );
  }
}
