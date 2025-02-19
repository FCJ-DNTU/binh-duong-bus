import 'package:intl/intl.dart'; // Để định dạng thời gian

class BusRoute {
  final String id;
  final String routeNumber; // Định nghĩa routeNumber
  final String routeName;
  final String startTime;
  final String endTime;
  final String routePrice;
  List<RouteStop> routeStops;
  List<TimeLine> timelines;

  BusRoute({
    required this.id,
    required this.routeNumber, // Khai báo routeNumber
    required this.routeName,
    required this.startTime,
    required this.endTime,
    required this.routePrice,
    required this.routeStops,
    required this.timelines,
  });

  // Phương thức formatTime để chuyển đổi thời gian thành dạng HH:mm
  static String formatTime(String time) {
    if (time.isEmpty || time == 'null') {
      return "N/A"; // Trường hợp không có dữ liệu
    }
    List<String> timeList = time.split(',');

    return timeList.map((t) {
      final parts = t.trim().split(':');
      if (parts.length == 2) {
        try {
          final dateFormat = DateFormat('HH:mm'); // Định dạng giờ:phút
          final formattedTime = DateFormat('HH:mm')
              .format(DateFormat('HH:mm').parse(parts.join(':')));
          return formattedTime;
        } catch (e) {
          return "N/A"; // Nếu không thể parse được thời gian
        }
      }
      return "N/A"; // Trường hợp lỗi
    }).join(', ');
  }

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    var stops = (json['stops'] as List<dynamic>?)
            ?.map((stop) => RouteStop.fromJson(stop))
            .toList() ??
        [];

    var timelines = (json['timelines'] as List<dynamic>?)
            ?.map((timeline) => TimeLine.fromJson(timeline))
            .toList() ??
        [];

    return BusRoute(
      id: json['id'] ?? 'N/A',
      routeNumber: json['routeNumber'] ?? 'N/A',
      routeName: json['routeName'] ?? 'N/A',
      routePrice: json['routePrice']?.toString() ?? '0',
      startTime: json['startTime'] ?? '00:00',
      endTime: json['endTime'] ?? '00:00',
      routeStops: stops,
      timelines: timelines,
    );
  }
}

class RouteStop {
  final String stopName;

  RouteStop({required this.stopName});

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      stopName: json['stopName'] ?? 'N/A',
    );
  }
}

class TimeLine {
  final String id;
  final String direction;
  final String departureTime;
  final String routeId;

  TimeLine({
    required this.id,
    required this.direction,
    required this.departureTime,
    required this.routeId,
  });

  factory TimeLine.fromJson(Map<String, dynamic> json) {
    return TimeLine(
      id: json['id'] ?? 'N/A',
      direction: json['direction'] ?? 'N/A',
      departureTime: json['departureTime'] ?? '00:00',
      routeId: json['routeId'] ?? 'N/A',
    );
  }
}
