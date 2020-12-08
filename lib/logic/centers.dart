import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:covidcenters/models/center.dart';
import 'package:geolocator/geolocator.dart';

class Centers extends ChangeNotifier {
  Dio _dio = new Dio();
  List<OneCenter> centers = [];
  List<OneCenter> filters = [];
  bool notLoading = false;
  Position currentLocation;
  String district = 'Hyderabad';
  bool districtSelected = false;

  List<OneCenter> jsonToCenter(List<dynamic> data) {
    return data
        .map(
          (e) => OneCenter(
            e['add'],
            e['area'],
            e['cen'],
            e['dist'],
            e['loc'],
            e['org'],
            e['test'],
            e['lat'],
            e['long'],
          ),
        )
        .toList();
  }

  Future<void> fetchCenters() async {
    currentLocation = await getUserPosition();
    centers = [];
    Response response = await _dio.get(
        'https://shielded-castle-15270.herokuapp.com/centers?district=$district');
    centers = filters = jsonToCenter(response.data);
    addCurrentLocationPoints(
      currentLocation.latitude,
      currentLocation.longitude,
    );
    notLoading = true;
    notifyListeners();
  }

  setDistrict(String selectedDistrict) {
    district = selectedDistrict;
    districtSelected = true;
    notLoading = false;
    notifyListeners();
  }

  toggleIntro() {
    districtSelected = !districtSelected;
    notifyListeners();
  }

  Future<Position> getUserPosition() async {
    return await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  addCurrentLocationPoints(double lat, double long) {
    centers.add(
      OneCenter(
        "Your Location",
        "Your area",
        "This is you",
        "Your District",
        "Your Location",
        "Your org",
        "",
        lat,
        long,
      ),
    );
    filters = centers;
  }
}
