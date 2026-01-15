import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:google_maps/features/maps/data/repos/map_search_service.dart';
import 'package:google_maps/features/maps/presentation/manager/map_cubit/map_cubit_states.dart';

class MapCubit extends Cubit<SearchState> {
  MapCubit() : super(SearchInitial());

  Future<void> getPage(String placeName) async {
    emit(SearchLoading());
    try {
      final data = await MapSearchService().getMapService(placeName: placeName);
      final List<SearchModel> placesList = data
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) => SearchModel.fromJson(e))
          .toList();
      emit(SearchSuccess(placesList));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
