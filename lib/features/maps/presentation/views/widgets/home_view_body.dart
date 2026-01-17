import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/cores/helper/API.dart';
import 'package:google_maps/cores/helper/show_message.dart';
import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:google_maps/features/maps/data/services/real_rout_service.dart';
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
  final routingService = RoutingService(API());

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
    _checkLocationStatus();
  }

  bool _locationAllowed = false;
  bool _checkingPermission = true;

  Future<void> _checkLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _locationAllowed = false;
        _checkingPermission = false;
      });
    } else {
      setState(() {
        _locationAllowed = true;
        _checkingPermission = false;
      });
      _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _locationAllowed = true;
      });
      _getCurrentLocation();
    } else if (permission == LocationPermission.deniedForever) {
      showSnackBar(context, 'من فضلك فعّل الموقع من الإعدادات');
      await openAppSettings();
    }
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
  // Future<void> _getDestenationLocation({required SearchModel placeName}) async {
  //   try {
  //     final lat = double.parse(placeName.lat!);
  //     final lon = double.parse(placeName.lon!);
  //     LatLng DestnationLtLng = LatLng(lat, lon);

  //     _controller?.animateCamera(
  //       CameraUpdate.newLatLngZoom(DestnationLtLng, 15),
  //     );

  //     setState(() {
  //       getCustomMarker();
  //       myMarkers.removeWhere((m) => m.markerId.value == "Dest_location");

  //       myMarkers.add(
  //         Marker(
  //           markerId: const MarkerId("Dest_location"),
  //           position: DestnationLtLng,
  //           infoWindow: const InfoWindow(title: "وجهتك"),
  //         ),
  //       );
  //       if (currentLatLng != null) {
  //         polylines.clear();
  //         polylines.add(
  //           Polyline(
  //             polylineId: const PolylineId("route"),
  //             color: Colors.blue,
  //             width: 5,
  //             points: [currentLatLng!, DestnationLtLng],
  //           ),
  //         );
  //       }
  //     });
  //   } catch (e) {
  //     _showMessage('تعذر الحصول على الموقع');
  //   }
  // }
  Future<void> _getDestenationLocation({required SearchModel placeName}) async {
    try {
      final lat = double.parse(placeName.lat!);
      final lon = double.parse(placeName.lon!);
      final dest = LatLng(lat, lon);

      final routePoints = await routingService.getRoute(currentLatLng!, dest);

      _controller?.animateCamera(CameraUpdate.newLatLngZoom(dest, 15));

      setState(() {
        myMarkers.removeWhere((m) => m.markerId.value == "Dest_location");

        myMarkers.add(
          Marker(
            markerId: const MarkerId("Dest_location"),
            position: dest,
            infoWindow: const InfoWindow(title: "وجهتك"),
          ),
        );

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: routePoints, // ✅ طريق حقيقي
            width: 5,
            color: Colors.blue,
          ),
        );
      });
    } catch (e) {
      _showMessage('تعذر الحصول على الطريق');
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
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_locationAllowed) {
      return _EnableLocationView(onEnable: _requestLocationPermission);
    }

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

class _EnableLocationView extends StatelessWidget {
  final VoidCallback onEnable;

  const _EnableLocationView({required this.onEnable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'نحتاج للوصول إلى موقعك',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'لتحديد موقعك ورسم الطريق بدقة',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onEnable,
              icon: const Icon(Icons.location_on),
              label: const Text('تفعيل الموقع'),
            ),
          ],
        ),
      ),
    );
  }
}
