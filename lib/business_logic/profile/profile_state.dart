part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ProcessStatus processStatus;
  final CustomError error;
  final User user;

  const ProfileState({
    required this.processStatus,
    required this.error,
    required this.user,
  });

  factory ProfileState.initial() => ProfileState(
        processStatus: ProcessStatus.initial,
        error: CustomError.initial(),
        user: User.initial(),
      );

  @override
  List<Object> get props => [processStatus, error, user];

  @override
  String toString() {
    return 'ProfileState{processStatus: $processStatus, error: $error, user: $user}';
  }

  ProfileState copyWith({
    ProcessStatus? processStatus,
    CustomError? error,
    User? user,
  }) {
    return ProfileState(
      processStatus: processStatus ?? this.processStatus,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
