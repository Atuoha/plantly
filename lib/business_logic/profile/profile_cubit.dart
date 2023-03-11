import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plantly/constants/enums/process_status.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository}) : super(ProfileState.initial());

  Future<void> fetchProfile({required String userId})async{
    emit(state.copyWith(processStatus:ProcessStatus.loading));
    try{
      final user = await profileRepository.fetchUser(userId: userId);
      emit(state.copyWith(processStatus:ProcessStatus.success,user:user));
    }on CustomError catch(e){
      emit(state.copyWith(processStatus:ProcessStatus.error, error:e,user:null));
    }
  }
}
