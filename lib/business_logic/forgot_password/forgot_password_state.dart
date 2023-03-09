part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final ProcessStatus status;
  final CustomError error;

  const ForgotPasswordState({required this.status, required this.error});

  factory ForgotPasswordState.initial() => ForgotPasswordState(
        status: ProcessStatus.initial,
        error: CustomError.initial(),
      );

  @override
  List<Object> get props => [status, error];

  @override
  String toString() {
    return 'ForgotPasswordState{status: $status, error: $error}';
  }

  ForgotPasswordState copyWith({
    ProcessStatus? status,
    CustomError? error,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
