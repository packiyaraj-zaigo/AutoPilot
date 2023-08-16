import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/search_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final apiRepo = ApiRepository();
  SearchBloc() : super(SearchInitial()) {
    on<GlobalSearchEvent>(globalSearch);
    on<SearchEmptyEvent>(emptyEvent);
  }

  Future<void> emptyEvent(
    SearchEmptyEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchEmptyState());
  }

  Future<void> globalSearch(
    GlobalSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(GlobalSearchLoadingState());
      final token = await AppUtils.getToken();
      final response = await apiRepo.globalSearch(token, event.query);
      if (response.statusCode == 200) {
        final List<SearchModel> results = [];
        final body = await jsonDecode(response.body);
        if (body['data'] != null && body['data'].isNotEmpty) {
          body['data'].forEach((model) {
            results.add(SearchModel.fromJson(model));
          });
        }
        final List<SearchModel> users = [];
        final List<SearchModel> vehicles = [];
        final List<SearchModel> estimates = [];
        for (var result in results) {
          if (result.searchResultType == "Customer") {
            users.add(result);
          } else if (result.searchResultType == "Vehicle") {
            vehicles.add(result);
          } else if (result.searchResultType == "Estimate") {
            estimates.add(result);
          }
        }
        emit(
          GlobalSearchSuccessState(
              users: users, vehicles: vehicles, estimates: estimates),
        );
        log(body.toString());
      }
    } catch (e) {
      log("$e Search bloc error");
      emit(const GlobalSearchErrorState(message: 'Something went wrong'));
    }
  }
}
