import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng userPosition = LatLng(13.333630, 74.743909);
  var isCheck = false;
  Function updateLocation;

  @override
  Widget build(BuildContext context) {
    if (!isCheck) {
      isCheck = true;
      updateLocation = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onTap: (val) async {
              userPosition = LatLng(val.latitude, val.longitude);
              setState(() {});
            },
            markers: {
              Marker(
                markerId: MarkerId("marker"),
                position: userPosition,
                draggable: true,
              ),
            },
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: userPosition, zoom: 18),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: RaisedButton(
                onPressed: () {
                  updateLocation(userPosition.latitude.toString(),
                      userPosition.longitude.toString());
                  Navigator.pop(context);
                },
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                child: Text(
                  "Select Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                color: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
