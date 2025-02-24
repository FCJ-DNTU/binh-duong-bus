import 'package:dio/dio.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'dart:convert';

class BusApi {
  final Dio dio = Dio();

  Future<List<BusRoute>> getBusRoutes() async {
    try {
      final response = await dio.get(
          'http://ec2-13-211-208-72.ap-southeast-2.compute.amazonaws.com:8080/api/routes');
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

  Future<BusRoute> getRouteDetails(String routeId) async {
    try {
      final response = await dio.get(
          'http://ec2-13-211-208-72.ap-southeast-2.compute.amazonaws.com:8080/api/routes/$routeId');
      if (response.statusCode == 200) {
        var route = BusRoute.fromJson(response.data['data']);

        final stopsResponse = await dio.get(
            'http://ec2-13-211-208-72.ap-southeast-2.compute.amazonaws.com:8080/api/routes/$routeId/stops');
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
      print("Lỗi khi gọi API: ${e.toString()}");
      throw Exception("Lỗi khi gọi API: ${e.toString()}");
    }
  }

  Future<List<TimeLine>> getTimelinesForRoute(String routeId) async {
    try {
      final response = await dio.get(
          'http://ec2-13-211-208-72.ap-southeast-2.compute.amazonaws.com:8080/api/routes/$routeId/timelines');
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

  static const String baseUrl =
      'http://ec2-13-211-208-72.ap-southeast-2.compute.amazonaws.com:8080';

  Future<List<BusRoute>> searchRoutes(String name) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/routes/search',
        queryParameters: {'name': name},
      );

      if (response.statusCode == 200) {
        final data = response.data["data"] as List;
        return data.map((json) => BusRoute.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }
}
