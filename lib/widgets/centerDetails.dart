import 'package:covidcenters/logic/centers.dart';
import 'package:covidcenters/models/center.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';

class CenterDetails extends StatefulWidget {
  final OneCenter center;
  CenterDetails(this.center);
  @override
  _CenterDetailsState createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Centers>(context).currentLocation;
    return ExpansionTile(
      title: Text(widget.center.center),
      children: [
        Center(
          child: Text(
            widget.center.address,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: distanceCalculatorWIdget(data.latitude, data.longitude,
              widget.center.lat, widget.center.long),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.navigation_sharp,
                        color: Color(0xFFa6acec),
                        size: 28,
                        semanticLabel: "Navigate",
                      ),
                      onPressed: () => _launchUrl(widget.center.locationLink),
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
                        size: 28,
                        semanticLabel: "Share",
                      ),
                      onPressed: () => share(
                          widget.center.center, widget.center.locationLink),
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
        ),
      ],
    );
  }
}

Future<void> share(String title, String link) async {
  await FlutterShare.share(
      title: "Covid Centers",
      text: title,
      linkUrl: link,
      chooserTitle: "Select app to share location");
}

Widget distanceCalculatorWIdget(startLat, startLong, endLat, endLong) {
  double meters = distanceBetween(startLat, startLong, endLat, endLong);
  double kiloMeters = meters / 1000;
  return Text('${kiloMeters.round().toString()} KM from your location');
}

_launchUrl(String url) async {
  String link = url;
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not navigate';
  }
}
