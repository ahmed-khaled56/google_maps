// // في حاله هتتدفع فلوس وتشتغل علي جوجل ماب في عمليه البحث
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class PlacesService {
//   static const String _baseUrl =
//       "https://maps.googleapis.com/maps/api/place/autocomplete/json";

//   final String apiKey;

//   PlacesService(this.apiKey);

//   Future<List<dynamic>> getPredictions(String input) async {
//     final uri = Uri.parse(
//       '$_baseUrl?input=$input&key=$apiKey&language=ar&components=country:eg',
//     );

//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['predictions'];
//     } else {
//       return [];
//     }
//   }
// }
