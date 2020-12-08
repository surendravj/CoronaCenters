import 'package:dio/dio.dart';

class CovidStats {
  Dio dio = new Dio();
  Map<dynamic, dynamic> data;

  Future<Map<dynamic, dynamic>> fetchData() async {
    Response response =
        await dio.get('https://api.covidindiatracker.com/state_data.json');
    return response.data[9];
  }
}
