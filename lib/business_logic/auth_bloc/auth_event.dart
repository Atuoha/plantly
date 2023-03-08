part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStateChangeEvent extends AuthEvent {
  final fbauth.User? user;

  const AuthStateChangeEvent({required this.user});

  @override
  List<Object?> get props => [user];
}


class SignOutEvent extends AuthEvent{

}