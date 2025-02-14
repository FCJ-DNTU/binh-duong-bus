import 'package:dio/dio.dart';
import 'package:binhduongbus/data/models/bus_route_model.dart';

class BusApi {
  final String baseUrl =
      'http://ec2-175-41-188-48.ap-southeast-1.compute.amazonaws.com:8080/api/routes';
  final Dio dio = Dio();

  // Hàm gọi API và trả về danh sách các tuyến xe
  Future<List<BusRoute>> getBusRoutes() async {
    try {
      final response = await dio.get(baseUrl);

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
}
