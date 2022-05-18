import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthNull extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  Authenticated({required this.userId});
  @override
  List<Object> get props => [userId];
}

class UnAuth extends AuthState {
  final bool fromStart;
  UnAuth({this.fromStart = false});
}
