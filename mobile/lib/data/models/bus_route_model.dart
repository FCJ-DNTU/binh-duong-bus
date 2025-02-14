import 'dart:convert';
import 'package:intl/intl.dart';

class BusRoute {
  final String id;
  final String routeNumber;
  final String routeName;
  final String startTime;
  final String endTime;
  final double routePrice;

  BusRoute({
    required this.id,
    required this.routeNumber,
    required this.routeName,
    required this.startTime,
    required this.endTime,
    required this.routePrice,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'],
      routeNumber: json['routeNumber'],
      routeName: json['routeName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      routePrice: json['routePrice'].toDouble(),
    );
  }

  // Hàm giúp định dạng thời gian từ chuỗi "HH:mm:ss"
  static String formatTime(String time) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(dateTime); 
  }
}
