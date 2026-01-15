import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkUtilize {
  static Future<String?> fetchUri(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
// String baseurl =
//     "https://maps.googleapis.com/maps/api/place/autocomplete/json";
// String request =
//     '$baseurl?input=$input&key=$apiKey&sessiontoken=${widget.token}';

// var data = json.decode(response.body);
// if (kDebugMode) {
//   print(data);
// }
