import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/cores/helper/show_message.dart';
import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:google_maps/features/maps/data/repos/sharedpref_service.dart';
import 'package:google_maps/features/maps/presentation/manager/map_cubit/map_cubit.dart';
import 'package:google_maps/features/maps/presentation/manager/map_cubit/map_cubit_states.dart';
import 'package:google_maps/features/maps/presentation/views/widgets/CUSTOM_textField.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key, required this.onHistoryChanged});
  final token = "1234567890";
  final Function(SearchModel) onHistoryChanged;

  @override
  State<HomeViewBody> createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> {
  GoogleMapController? _controller;
  final TextEditingController _searchController = TextEditingController();
  void goToPlaceFromHistory(SearchModel place) {
    _getDestenationLocation(placeName: place);
  }

  LatLng? currentLocation;
  LatLng? destinationLocation;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {});
    getCustomMarker();
    _getCurrentLocation();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Set<Polyline> polylines = {};
  LatLng? currentLatLng;
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatLng = LatLng(position.latitude, position.longitude);

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 15),
      );

      setState(() {
        myMarkers.removeWhere((m) => m.markerId.value == "home");

        myMarkers.add(
          Marker(
            markerId: const MarkerId("home"),
            position: currentLatLng!,
            infoWindow: const InfoWindow(title: "موقعك الحالي"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      });
    } catch (e) {
      _showMessage('تعذر الحصول على الموقع${e.toString()}');
    }
  }

  LatLng? DestnationLtLng;
  Future<void> _getDestenationLocation({required SearchModel placeName}) async {
    try {
      final lat = double.parse(placeName.lat!);
      final lon = double.parse(placeName.lon!);
      LatLng DestnationLtLng = LatLng(lat, lon);

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(DestnationLtLng, 15),
      );

      setState(() {
        getCustomMarker();
        myMarkers.removeWhere((m) => m.markerId.value == "Dest_location");

        myMarkers.add(
          Marker(
            markerId: const MarkerId("Dest_location"),
            position: DestnationLtLng,
            infoWindow: const InfoWindow(title: "وجهتك"),
          ),
        );
        if (currentLatLng != null) {
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              color: Colors.blue,
              width: 5,
              points: [currentLatLng!, DestnationLtLng],
            ),
          );
        }
      });
    } catch (e) {
      _showMessage('تعذر الحصول على الموقع');
    }
  }

  Future<void> _checkPermission() async {
    LocationPermission permission;

    // هل ال location service شغال؟
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('فعّل GPS الأول');
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showMessage('تم رفض إذن الموقع');
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage('يرجى تفعيل الإذن من الإعدادات');
      await openAppSettings();
      return;
    }

    // ✅ كل حاجة تمام
    _getCurrentLocation();
  }

  // Set<Polyline> polylines = {};

  var myMarkers = HashSet<Marker>();
  BitmapDescriptor? customMarker;
  Future<void> getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/home.png",
    );
    setState(() {});
  }

  // Set<Polygon> myPolygon() {
  //   List<LatLng> polygonCoords = [];
  //   polygonCoords.add(currentLatLng!); // وسط القاهرة
  //   polygonCoords.add(DestnationLtLng!); // شمال شرق
  //   polygonCoords.add(LatLng(30.0300, 31.2500)); // جنوب شرق
  //   polygonCoords.add(LatLng(30.0300, 31.2200)); // جنوب غرب
  //   polygonCoords.add(
  //     LatLng(30.0444, 31.2357),
  //   ); // نرجع لنقطة البداية لإغلاق المضلع

  //   Set<Polygon> polygonSet = {};
  //   polygonSet.add(
  //     Polygon(
  //       polygonId: PolygonId('1'),
  //       points: polygonCoords,
  //       strokeColor: Colors.red,
  //     ),
  //   );

  //   return polygonSet;
  // }

  bool? isPressed = false;
  String? UserInput;
  String? selectedPlace;
  List<SearchModel> historyList = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Stack(
          children: [
            GoogleMap(
              polylines: polylines,

              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: myMarkers,

              onMapCreated: (controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(30.0444, 31.2357),
                zoom: 12,
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.my_location),
                ),
              ),
            ),
            CustomTextfield(
              controller: _searchController,
              onChanged: (value) async {
                print(value);
                setState(() {
                  UserInput = value;
                });
              },
              onTap: () {
                UserInput != null
                    ? BlocProvider.of<MapCubit>(context).getPage(UserInput!)
                    : showSnackBar(
                        context,
                        "must enter destenation place name firist",
                      );
                isPressed = false;
              },
              hintText: selectedPlace,
            ),
            BlocConsumer<MapCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchSuccess) {
                  List<SearchModel> placesList = state.places;
                  return Visibility(
                    visible: isPressed! || UserInput == null ? false : true,
                    child: Positioned(
                      top: 100,
                      left: 20,
                      child: SizedBox(
                        height: 300,
                        width: 350,
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(8),
                          child: ListView.builder(
                            itemCount: placesList.length,
                            itemBuilder: (context, i) {
                              final prediction = placesList;

                              return ListTile(
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(prediction[i].displayName!),
                                subtitle: Text(
                                  "",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    historyList.add(prediction[i]);
                                    isPressed = true;
                                    selectedPlace = prediction[i].displayName!;
                                    _searchController.clear();
                                  });
                                  widget.onHistoryChanged(prediction[i]);
                                  _getDestenationLocation(
                                    placeName: prediction[i],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
              listener: (context, state) {
                if (state is SearchFailure) {
                  showSnackBar(context, state.errMessage);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
