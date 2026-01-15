import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<SearchModel> places;
  SearchSuccess(this.places);
}

class SearchFailure extends SearchState {
  final String errMessage;
  SearchFailure(this.errMessage);
}
