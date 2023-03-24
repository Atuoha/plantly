part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String keyword;

  const SearchState({required this.keyword});

  factory SearchState.initial() => const SearchState(keyword: '');

  @override
  List<Object> get props => [keyword];

  @override
  String toString() {
    return 'SearchState{keyword: $keyword}';
  }

  SearchState copyWith({
    String? keyword,
  }) {
    return SearchState(
      keyword: keyword ?? this.keyword,
    );
  }
}
