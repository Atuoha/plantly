import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plantly/constants/enums/process_status.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository})
      : super(ProfileState.initial());

  Future<void> fetchProfile({required String userId}) async {
    emit(state.copyWith(processStatus: ProcessStatus.loading));
    try {
      final user = await profileRepository.fetchUser(userId: userId);
      emit(state.copyWith(processStatus: ProcessStatus.success, user: user));
    } on CustomError catch (e) {
      emit(state.copyWith(
          processStatus: ProcessStatus.error, error: e, user: null));
    }
  }

  Future<void> editProfile({
    required String userId,
    required String email,
    String password = '',
    required String fullName,
  }) async {
    emit(state.copyWith(processStatus: ProcessStatus.loading));
    try {
      await profileRepository.editUser(
        userId: userId,
        email: email,
        fullName: fullName,
        password: password,
      );
      emit(state.copyWith(processStatus: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(
          processStatus: ProcessStatus.error, error: e, user: null));
    }
  }
}
