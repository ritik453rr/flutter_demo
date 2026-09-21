import 'package:demo/core/constants/app_date_time_format_service.dart';
import 'package:demo/core/service/notification/local_notification_service.dart';
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
  void initState() {
    super.initState();
    sortEvents();
    filterAllEventList();
  }

  // sort events based on time
  void sortEvents() {
    allEvents.sort(
      (a, b) =>
          DateTime.parse(a.eventDate).compareTo(DateTime.parse(b.eventDate)),
    );
  }

  // filter out events and add into today,week,month list
  void filterAllEventList() {
    todayEventList.clear();
    weekEventList.clear();
    monthEventList.clear();

    final today = DateTime.now().toLocal();
    final weekStart = DateTime(today.year, today.month, today.day);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 1);

    for (EventModel event in allEvents) {
      final eventDate = DateTime.parse(event.eventDate).toLocal();

      // Today filter (matches calendar day)
      if (eventDate.year == today.year &&
          eventDate.month == today.month &&
          eventDate.day == today.day) {
        todayEventList.add(event);
      }

      // Week filter (7 days starting from today)
      if (!eventDate.isBefore(weekStart) && eventDate.isBefore(weekEnd)) {
        weekEventList.add(event);
      }

      // Month filter (current calendar month)
      if (!eventDate.isBefore(monthStart) && eventDate.isBefore(monthEnd)) {
        monthEventList.add(event);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF22C55E);
      case 'completed':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  Widget _buildEventList(List<EventModel> events) {
    if (events.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: () async{
          await  LocalNotificationService.show(
              RemoteMessage(
                notification: RemoteNotification(
                  title: "test",
                  body: "this is test notification",
                ),
              ),
            );
          },
          child: Text("tap"),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final statusColor = _getStatusColor(event.eventStatus);
        final formattedDate = AppDateTimeFormatter.fomatToDayMonthYear(
          event.eventDate,
        );
        final formattedTime = AppDateTimeFormatter.formatToTime(
          event.eventDate,
        );

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            title: Text(
              event.eventName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$formattedDate  •  $formattedTime',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                event.eventStatus[0].toUpperCase() +
                    event.eventStatus.substring(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                tabAlignment: TabAlignment.fill,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color(0xFF242424),
                dividerColor: const Color(0xFFE6E6E6),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                labelColor: const Color(0xFF242424),
                unselectedLabelColor: const Color(0xFF757575),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.1,
                ),
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildEventList(todayEventList),
                    _buildEventList(weekEventList),
                    _buildEventList(monthEventList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
