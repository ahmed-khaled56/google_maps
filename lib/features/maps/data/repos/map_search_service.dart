import 'package:google_maps/cores/helper/API.dart';

class MapSearchService {
  Future<List<dynamic>> getMapService({required String placeName}) async {
    List<dynamic> data = await API().get(
      url:
          'https://nominatim.openstreetmap.org/search?q=$placeName&format=json',
    );
    List dataList = data;

    return dataList;
  }
}
