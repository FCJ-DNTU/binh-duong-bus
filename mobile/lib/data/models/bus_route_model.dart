import 'package:intl/intl.dart';

class BusRoute {
  final String id;
  final String routeNumber;
  final String routeName;
  final String startTime;
  final String endTime;
  final String routePrice;
  List<RouteStop> routeStops;
  List<TimeLine> timelines;

  BusRoute({
    required this.id,
    required this.routeNumber,
    required this.routeName,
    required this.startTime,
    required this.endTime,
    required this.routePrice,
    required this.routeStops,
    required this.timelines,
  });

  static String formatTime(String time) {
    if (time.isEmpty || time == 'null') {
      return "N/A";
    }

    List<String> timeList = time.split(',');
    return timeList.map((t) {
      try {
        final dateFormat = DateFormat('HH:mm');
        final formattedTime =
            dateFormat.format(DateFormat('HH:mm:ss').parse(t.trim()));
        return formattedTime;
      } catch (e) {
        return "N/A";
      }
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
      startTime: formatTime(json['startTime'] ?? '00:00'),
      endTime: formatTime(json['endTime'] ?? '00:00'),
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
      departureTime: BusRoute.formatTime(json['departureTime'] ?? '00:00'),
      routeId: json['routeId'] ?? 'N/A',
    );
  }
}
