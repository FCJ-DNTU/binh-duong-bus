import 'package:dio/dio.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart'; // Import các model

class BusApi {
  final Dio dio = Dio();

  Future<List<BusRoute>> getBusRoutes() async {
    try {
      final response = await dio.get(
          'http://ec2-175-41-188-48.ap-southeast-1.compute.amazonaws.com:8080/api/routes');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((route) => BusRoute.fromJson(route)).toList();
      } else {
        throw Exception("Không thể lấy dữ liệu tuyến xe từ API");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

  // Hàm lấy thông tin chi tiết tuyến xe (bao gồm trạm dừng)
  Future<BusRoute> getRouteDetails(String routeId) async {
    try {
      final response = await dio.get(
          'http://ec2-175-41-188-48.ap-southeast-1.compute.amazonaws.com:8080/api/routes/$routeId');
      if (response.statusCode == 200) {
        var route = BusRoute.fromJson(response.data['data']);

        final stopsResponse = await dio.get(
            'http://ec2-175-41-188-48.ap-southeast-1.compute.amazonaws.com:8080/api/routes/$routeId/stops');
        if (stopsResponse.statusCode == 200) {
          var stops = stopsResponse.data['data']
              .map<RouteStop>((stop) => RouteStop.fromJson(stop))
              .toList();
          route.routeStops = stops;
        }
        return route;
      } else {
        throw Exception("Không thể lấy thông tin chi tiết tuyến xe");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }

  // Hàm lấy danh sách timelines cho một tuyến xe
  Future<List<TimeLine>> getTimelinesForRoute(String routeId) async {
    try {
      final response = await dio.get(
          'http://ec2-175-41-188-48.ap-southeast-1.compute.amazonaws.com:8080/api/routes/$routeId/timelines');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((timeline) => TimeLine.fromJson(timeline)).toList();
      } else {
        throw Exception("Không thể lấy dữ liệu timelines từ API");
      }
    } catch (e) {
      throw Exception("Lỗi khi gọi API: $e");
    }
  }
}


