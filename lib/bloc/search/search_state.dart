part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class GlobalSearchLoadingState extends SearchState {}

class GlobalSearchErrorState extends SearchState {
  final String message;
  const GlobalSearchErrorState({required this.message});
}

class GlobalSearchSuccessState extends SearchState {
  final List<SearchModel> users;
  final List<SearchModel> vehicles;
  final List<SearchModel> estimates;
  const GlobalSearchSuccessState({
    required this.users,
    required this.vehicles,
    required this.estimates,
  });
}

class SearchEmptyState extends SearchState {}
