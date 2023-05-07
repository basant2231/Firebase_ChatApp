part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
/******************************************************************************/
class UserCreatedSuccessState extends AuthState {}
class UserCreatedLoadingState extends AuthState {}
class UserCreatedFailedState extends AuthState {
  String? message;
  UserCreatedFailedState({
   required this.message,
  });
}
/******************************************************************************/
class UserImageSelectedSuccessState extends AuthState {}
class UserImageSelectedFailedState extends AuthState {}
/******************************************************************************/
class FailedToSaveUserDataOnFireStoreState extends AuthState {}
class SuccessToSaveUserDataOnFireStoreState extends AuthState {}
/******************************************************************************/
class LoginSuccessState extends AuthState {}
class LoginFailedState extends AuthState {}
class LoginLoadingState extends AuthState {}

