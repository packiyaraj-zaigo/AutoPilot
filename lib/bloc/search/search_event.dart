part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GlobalSearchEvent extends SearchEvent {
  final String query;
  const GlobalSearchEvent({required this.query});
}

class SearchEmptyEvent extends SearchEvent {}
