import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordCubit({required this.authRepository})
      : super(ForgotPasswordState.initial());

  Future<void> forgotPassword({required String email}) async {
    emit(state.copyWith(status: ProcessStatus.loading));

    try {
      await authRepository.forgotPassword(email: email);
      emit(state.copyWith(status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error, error: e));
    }
  }
}
