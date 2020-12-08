import 'dart:typed_data';
import 'package:covidcenters/logic/centers.dart';
import 'package:covidcenters/logic/covid_stats.dart';
import 'package:covidcenters/models/center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:flutter_share/flutter_share.dart';

class MapsMarkers extends StatefulWidget {
  @override
  _MapsMarkersState createState() => _MapsMarkersState();
}

class _MapsMarkersState extends State<MapsMarkers> {
  BitmapDescriptor customIcon;
  BitmapDescriptor customUserIcon;
  Completer<GoogleMapController> mapController = Completer();
  bool isMapHybrid = false;
  @override
  void initState() {
    super.initState();
    print(CovidStats().data);
    Provider.of<Centers>(context, listen: false).fetchCenters();
    createMarker(context);
    createUserMarker(context);
  }

  Future<Uint8List> getBytesFromAssets(String path, width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  createMarker(context) async {
    if (customIcon == null) {
      final Uint8List markerIcon =
          await getBytesFromAssets("assets/marker.png", 120);
      setState(() {
        customIcon = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
  }

  createUserMarker(context) async {
    if (customUserIcon == null) {
      final Uint8List markerIcon =
          await getBytesFromAssets("assets/human.png", 150);
      setState(() {
        customUserIcon = BitmapDescriptor.fromBytes(markerIcon);
      });
    }
  }

  void toggleMapType() {
    setState(() {
      isMapHybrid = !isMapHybrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMapContainer(context),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: toggleMapType,
              child: Icon(Icons.satellite),
              backgroundColor: Colors.red[300],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: () =>
                  Provider.of<Centers>(context, listen: false).toggleIntro(),
              child: Icon(
                Icons.filter_alt_sharp,
              ),
              backgroundColor: Colors.red[300],
            ),
          ),
        ),
      ],
    );
  }

  Container buildMapContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      width: double.infinity,
      child: Consumer<Centers>(
        builder: (_, center, child) => center.notLoading
            ? GoogleMap(
                zoomControlsEnabled: false,
                mapType: isMapHybrid ? MapType.hybrid : MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    center.currentLocation.latitude,
                    center.currentLocation.longitude,
                  ),
                  zoom: 11.5,
                ),
                markers: center.centers
                    .map(
                      (e) => Marker(
                        markerId: MarkerId(e.address),
                        position: LatLng(e.lat, e.long),
                        draggable: false,
                        icon: center.currentLocation.latitude == e.lat
                            ? customUserIcon
                            : customIcon,
                        infoWindow: InfoWindow(
                          title: e.center,
                          snippet: e.address,
                        ),
                        onTap: center.currentLocation.latitude == e.lat
                            ? null
                            : () => buildShowModalBottomSheet(context, e),
                      ),
                    )
                    .toSet(),
                circles: [
                  Circle(
                    circleId: CircleId("Radius"),
                    center: LatLng(center.currentLocation.latitude,
                        center.currentLocation.longitude),
                    radius: 10000,
                    strokeColor: Colors.red[500],
                    // ,
                    fillColor:
                        isMapHybrid ? Colors.transparent : Color(0xFFdee1ec),
                    strokeWidth: isMapHybrid ? 4 : 0,
                  )
                ].toSet(),
              )
            : Center(
                child: SpinKitDoubleBounce(
                  color: Colors.red[200],
                ),
              ),
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context, OneCenter e) {
    var data = Provider.of<Centers>(context, listen: false);
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.47,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  Center(
                    child: FittedBox(
                      child: Text(
                        e.center,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              SizedBox(
                height:5,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  e.address,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height:5,
              ),
              Center(
                child: Wrap(
                  spacing: 6,
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    FilterChip(
                      label: Text(
                        e.area,
                        style: TextStyle(color: Colors.black),
                      ),
                      onSelected: null,
                      disabledColor: Color(0xFFa6acec),
                    ),
                    FilterChip(
                      label: Text(
                        '${e.district[0].toUpperCase()}${e.district.substring(1).toLowerCase()}',
                        style: TextStyle(color: Colors.black),
                      ),
                      onSelected: null,
                      disabledColor: Color(0xFFa6acec),
                    ),
                    FilterChip(
                      label: Text(
                        e.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      onSelected: null,
                      disabledColor: Color(0xFFa6acec),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Type"),
                      Chip(
                        label: Text(e.org),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Test"),
                      Chip(
                        label: Text(e.testType),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Distance"),
                      Chip(
                        label: distanceCalculatorWIdget(
                          data.currentLocation.latitude,
                          data.currentLocation.longitude,
                          e.lat,
                          e.long,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.navigation_sharp,
                            color: Color(0xFFa6acec),
                            size: 35,
                            semanticLabel: "Navigate",
                          ),
                          onPressed: () => _launchUrl(e.locationLink),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Navigate",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.blue[400],
                            size: 35,
                            semanticLabel: "Share",
                          ),
                          onPressed: () => share(e.center, e.locationLink),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Share",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }
}

Widget distanceCalculatorWIdget(startLat, startLong, endLat, endLong) {
  double meters = distanceBetween(startLat, startLong, endLat, endLong);
  double kiloMeters = meters / 1000;
  return Text('${kiloMeters.round().toString()} KM');
}

_launchUrl(String url) async {
  String link = url;
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not navigate';
  }
}

Future<void> share(String title, String link) async {
  await FlutterShare.share(
      title: "Covid Centers",
      text: title,
      linkUrl: link,
      chooserTitle: "Select app to share location");
}
