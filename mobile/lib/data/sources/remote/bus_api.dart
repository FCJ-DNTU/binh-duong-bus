import 'package:dio/dio.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
    final String apiUrl = dotenv.env['API_URL'] ?? '';

    try {
      // Make a single API call to get complete route information
      final response = await http.get(Uri.parse('$apiUrl/api/routes/$routeId') );

      if (response.statusCode != 200) {
        throw Exception("Không thể lấy thông tin chi tiết tuyến xe");
      }

      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final data = jsonResponse['data'];

      // Create BusRoute object from the response
      BusRoute route = BusRoute.fromJson(data);

      // Extract route segments (ways)
      List<List<LatLng>> routeSegments = [];

      if (data['ways'] != null) {
        for (var way in data['ways']) {
          if (way['geometry'] != null &&
              way['geometry']['type'] == 'LineString' &&
              way['geometry']['coordinates'] != null) {
            final List coordinates = way['geometry']['coordinates'];
            List<LatLng> segmentPoints = [];

            for (int i = 0; i < coordinates.length; i++) {
              LatLng point = LatLng(coordinates[i][1], coordinates[i][0]);

              if (segmentPoints.isEmpty || segmentPoints.last != point) {
                segmentPoints.add(point);
              }
            }

            if (segmentPoints.isNotEmpty) {
              routeSegments.add(segmentPoints);
            }
          }
        }
      }

      // Extract stop points with coordinates
      final List<LatLng> stopPointCoordinates = [];

      if (data['stops'] != null) {
        for (var stop in data['stops']) {
          // Extract coordinates if available
          if (stop['location'] != null && stop['location']['coordinates'] != null) {
            final double lat = stop['location']['coordinates'][1];
            final double lng = stop['location']['coordinates'][0];
            stopPointCoordinates.add(LatLng(lat, lng));
          }
        }
      }

      // Update route with geometry data
      route.updateGeometryData(routeSegments, stopPointCoordinates);

      return route;
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
