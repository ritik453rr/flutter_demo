import 'package:demo/core/constants/app_date_time_format_service.dart';
import 'package:demo/core/service/notification/local_notification_service.dart';
import 'package:demo/core/service/phone_service/phone_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../app_calendar/app_calendar_one.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final allEvents = <EventModel>[];
  final todayEventList = <EventModel>[];
  final weekEventList = <EventModel>[];
  final monthEventList = <EventModel>[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextButton(onPressed: (){
        PhoneService.getFormattedMobileNo();
      }, child: Text("Tap"))),
    );
  }
}
