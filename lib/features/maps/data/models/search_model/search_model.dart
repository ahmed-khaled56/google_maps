import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final int? placeId;
  final String? licence;
  final String? osmType;
  final int? osmId;
  final String? lat;
  final String? lon;
  final String? searchModelClass;
  final String? type;
  final int? placeRank;
  final double? importance;
  final String? addresstype;
  final String? name;
  final String? displayName;
  final List<String>? boundingbox;

  const SearchModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.searchModelClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.boundingbox,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    placeId: json['place_id'] as int?,
    licence: json['licence'] as String?,
    osmType: json['osm_type'] as String?,
    osmId: json['osm_id'] as int?,
    lat: json['lat'] as String?,
    lon: json['lon'] as String?,
    searchModelClass: json['class'] as String?,
    type: json['type'] as String?,
    placeRank: json['place_rank'] as int?,
    importance: (json['importance'] as num?)?.toDouble(),
    addresstype: json['addresstype'] as String?,
    name: json['name'] as String?,
    displayName: json['display_name'] as String?,
    boundingbox: (json['boundingbox'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'place_id': placeId,
    'licence': licence,
    'osm_type': osmType,
    'osm_id': osmId,
    'lat': lat,
    'lon': lon,
    'class': searchModelClass,
    'type': type,
    'place_rank': placeRank,
    'importance': importance,
    'addresstype': addresstype,
    'name': name,
    'display_name': displayName,
    'boundingbox': boundingbox,
  };

  @override
  List<Object?> get props {
    return [
      placeId,
      licence,
      osmType,
      osmId,
      lat,
      lon,
      searchModelClass,
      type,
      placeRank,
      importance,
      addresstype,
      name,
      displayName,
      boundingbox,
    ];
  }
}
