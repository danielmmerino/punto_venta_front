import '../data/models/user.dart';

class UsersState {
  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  final List<User> users;
  final bool isLoading;
  final String? error;

  UsersState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
  }) => UsersState(
        users: users ?? this.users,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
