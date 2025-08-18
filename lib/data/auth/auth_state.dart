import 'user.dart';
import 'local.dart';

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
  const Authenticated({
    required this.user,
    required this.expiresAt,
    this.locales = const [],
  });

  final User user;
  final DateTime expiresAt;
  final List<Local> locales;
}

class Expired extends AuthState {
  const Expired();
}
