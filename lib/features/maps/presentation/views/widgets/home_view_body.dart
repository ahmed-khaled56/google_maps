import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  GoogleMapController? _controller;
  //permission
  // bool _locationPermissionGranted = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkPermission();
  // }

  // Future<void> _checkPermission() async {
  //   var status = await Permission.location.request();
  //   if (status.isGranted) {
  //     setState(() {
  //       _locationPermissionGranted = true;
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('يرجى تفعيل إذن الموقع من الإعدادات')),
  //     );
  //   }
  // }
  void iniState() {
    super.initState();
    getCustomMarker();
  }

  var myMarkers = HashSet<Marker>();
  BitmapDescriptor? customMarker;
  Future<void> getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/alaaaaaa.jpg",
    );
    setState(() {});
  }

  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = [];
    polygonCoords.add(LatLng(30.0444, 31.2357)); // وسط القاهرة
    polygonCoords.add(LatLng(30.0500, 31.2500)); // شمال شرق
    polygonCoords.add(LatLng(30.0300, 31.2500)); // جنوب شرق
    polygonCoords.add(LatLng(30.0300, 31.2200)); // جنوب غرب
    polygonCoords.add(
      LatLng(30.0444, 31.2357),
    ); // نرجع لنقطة البداية لإغلاق المضلع

    Set<Polygon> polygonSet = new Set();
    polygonSet.add(
      Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeColor: Colors.red,
      ),
    );

    return polygonSet;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Stack(
          children: [
            GoogleMap(
              polygons: myPolygon(),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;

                setState(() {
                  myMarkers.add(
                    Marker(
                      markerId: MarkerId("1"),
                      position: LatLng(30.0444, 31.2357),
                      infoWindow: InfoWindow(
                        title: " cairo is here",
                        snippet: "hello eevery body in cairo",
                        onTap: () {
                          print("goooood");
                        },
                      ),
                      icon: customMarker ?? BitmapDescriptor.defaultMarker,
                    ),
                  );
                });
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(30.0444, 31.2357), // Cairo
                zoom: 12,
              ),

              myLocationEnabled: true, // بس بعد ما الإذن يتوافق
              myLocationButtonEnabled: true,
              markers: myMarkers,
            ),
            // Container(child: Image.asset(""), alignment: Alignment.topCenter),
          ],
        ),
      ),
    );
  }
}
