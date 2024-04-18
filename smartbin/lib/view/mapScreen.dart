import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Map<String, Marker> _markers = {};
  LatLng currentPostition = LatLng(31.46825, 76.2058);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(31.46825, 76.2058), zoom: 15),
                onMapCreated: ((controller) {
                  mapController = controller;
                  addMarker('smartbin', currentPostition);
                }),
                markers: _markers.values.toSet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addMarker(String id, LatLng Location) async {
    // var markerIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), "assets/images/dustbin.png");
    // var marker =
    //     Marker(markerId: MarkerId(id), position: Location, icon: markerIcon);
    // _markers[id] = marker;
    // setState(() {});
  }
}
