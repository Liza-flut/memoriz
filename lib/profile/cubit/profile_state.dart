class ProfileState {
  final String? email;
  final String? avatar;
  final dynamic minTurns;
  final dynamic minTime;
  final bool isLoading;

  ProfileState({
    required this.email,
    required this.avatar,
    required this.minTurns,
    required this.minTime,
    required this.isLoading,
  });

  factory ProfileState.initial() {
    return ProfileState(
      email: null,
      avatar: '',
      minTurns: 'Не установлено',
      minTime: 'Не установлено',
      isLoading: false,
    );
  }

  ProfileState copyWith({
    String? email,
    String? avatar,
    dynamic minTurns,
    dynamic minTime,
    bool? isLoading,
  }) {
    return ProfileState(
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      minTurns: minTurns ?? this.minTurns,
      minTime: minTime ?? this.minTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
