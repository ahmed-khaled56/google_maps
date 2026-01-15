// // في حاله هتتدفع فلوس وتشتغل علي جوجل ماب في عمليه البحث
// import 'dart:convert';

// import 'package:google_maps/features/maps/data/services/auto_complete_prediction.dart';

// /// The Autocomplete response contains place predictions and status
// class PlaceAutocompleteResponse {
//   final String? status;
//   final List<AutocompletePrediction>? predictions;

//   PlaceAutocompleteResponse(this.status, this.predictions);

//   factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
//     return PlaceAutocompleteResponse(
//       json['status'] as String?,
//       json['predictions'] != null
//           ? json['predictions']
//                 .map<AutocompletePrediction>(
//                   (json) => AutocompletePrediction.fromJson(json),
//                 )
//                 .toList()
//           : null,
//     );
//   }

//   /// Parse response body directly from API response
//   static PlaceAutocompleteResponse parseAutocompleteResult(
//     String responseBody,
//   ) {
//     final parsed = json.decode(responseBody).cast<String, dynamic>();

//     return PlaceAutocompleteResponse.fromJson(parsed);
//   }
// }
