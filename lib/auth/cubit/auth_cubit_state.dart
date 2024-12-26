class AuthState {
  final String? user;
  final String? error;
  final bool isLoading;

  AuthState({this.user, this.error, required this.isLoading});

  factory AuthState.initial() =>
      AuthState(user: null, error: null, isLoading: false);

  AuthState copyWith({String? user, String? error, bool? isLoading}) {
    return AuthState(
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
