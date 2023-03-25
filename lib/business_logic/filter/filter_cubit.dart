import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/enums/plant_filter.dart';
part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState.initial());

  void changeFilter(PlantFilter plantFilter) {
    emit(state.copyWith(plantFilter: plantFilter));
  }
}
