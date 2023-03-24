import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState.initial());

  void searchKeyword(String keyword) {
    emit(state.copyWith(keyword: keyword));
  }
}


