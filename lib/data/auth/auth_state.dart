import 'user.dart';

abstract class AuthState {
  const AuthState();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticating extends AuthState {
  const Authenticating();
}

class Authenticated extends AuthState {
  const Authenticated({required this.user, required this.expiresAt});
  final User user;
  final DateTime expiresAt;
}

class Expired extends AuthState {
  const Expired();
}
