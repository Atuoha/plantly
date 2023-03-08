import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plantly/constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository}) : super(SignUpState.initial());

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(state.copyWith(status: ProcessStatus.loading));
    try {
      await authRepository.signup(
          fullName: fullName, email: email, password: password);
      emit(state.copyWith(status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error, error: e));
    }
  }
}
