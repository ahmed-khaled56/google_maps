// // في حاله هتتدفع فلوس وتشتغل علي جوجل ماب في عمليه البحث
// class AutocompletePrediction {
//   /// [description] contains the human-readable name for the returned result.
//   /// This is usually the full place description.
//   final String? description;

//   /// [structuredFormatting] provides pre-formatted text
//   /// that can be displayed in the UI.
//   final StructuredFormatting? structuredFormatting;

//   /// [placeId] is a textual identifier that uniquely identifies a place.
//   /// To retrieve information about the place, pass this identifier
//   /// in the placeId field of a Places API request.
//   final String? placeId;

//   /// [reference] contains a reference string.
//   final String? reference;

//   AutocompletePrediction({
//     this.description,
//     this.structuredFormatting,
//     this.placeId,
//     this.reference,
//   });

//   factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
//     return AutocompletePrediction(
//       description: json['description'] as String?,
//       placeId: json['place_id'] as String?,
//       reference: json['reference'] as String?,
//       structuredFormatting: json['structured_formatting'] != null
//           ? StructuredFormatting.fromJson(json['structured_formatting'])
//           : null,
//     );
//   }
// }

// class StructuredFormatting {
//   /// [mainText] contains the main text of a prediction,
//   /// usually the name of the place.
//   final String? mainText;

//   /// [secondaryText] contains the secondary text of a prediction,
//   /// usually the location details (city, country, etc).
//   final String? secondaryText;

//   StructuredFormatting({this.mainText, this.secondaryText});

//   factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
//     return StructuredFormatting(
//       mainText: json['main_text'] as String?,
//       secondaryText: json['secondary_text'] as String?,
//     );
//   }
// }
