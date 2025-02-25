import 'package:dio/dio.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusApi {
  final Dio dio = Dio();
  final String apiUrl = dotenv.env['API_URL'] ?? '';

  Future<List<BusRoute>> getBusRoutes() async {
    try {
      final response = await dio.get('${apiUrl}/api/routes');
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
      final response = await dio.get('${apiUrl}/api/routes/$routeId');
      if (response.statusCode == 200) {
        var route = BusRoute.fromJson(response.data['data']);

        final stopsResponse =
            await dio.get('${apiUrl}/api/routes/$routeId/stops');
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
      final response = await dio.get('${apiUrl}/api/routes/$routeId/timelines');
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

  Future<List<BusRoute>> searchRoutes(String name) async {
    try {
      final response = await dio.get(
        '${apiUrl}/api/routes/search',
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
