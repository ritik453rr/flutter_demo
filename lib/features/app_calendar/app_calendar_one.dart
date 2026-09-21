import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Event model representing schedule items.
class EventModel {
  String eventName;
  String eventDate;
  String eventStatus;
  String createdAt;

  EventModel({
    required this.eventName,
    required this.eventDate,
    required this.eventStatus,
    required this.createdAt,
  });
}

class AppCalendarOne extends StatefulWidget {
  final CalendarFormat initialCalendarFormat;

  const AppCalendarOne({
    super.key,
    this.initialCalendarFormat = CalendarFormat.month,
  });

  @override
  State<AppCalendarOne> createState() => _AppCalendarOneState();
}

class _AppCalendarOneState extends State<AppCalendarOne> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late CalendarFormat _calendarFormat;

  final eventList = <EventModel>[
    // 25 August - 3 events
    EventModel(
      eventName: 'Flutter Workshop',
      eventDate: '2026-08-25T10:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-20T09:30:00.000Z',
    ),
    EventModel(
      eventName: 'Team Standup',
      eventDate: '2026-08-25T13:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-20T09:45:00.000Z',
    ),
    EventModel(
      eventName: 'Client Discussion',
      eventDate: '2026-08-25T16:00:00.000Z',
      eventStatus: 'cancelled',
      createdAt: '2026-08-20T10:00:00.000Z',
    ),

    // 26 August - 2 events
    EventModel(
      eventName: 'Team Meeting',
      eventDate: '2026-08-26T09:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-21T10:15:00.000Z',
    ),
    EventModel(
      eventName: 'Project Planning',
      eventDate: '2026-08-26T14:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-21T11:00:00.000Z',
    ),

    // 27 August - 1 event
    EventModel(
      eventName: 'Backend Discussion',
      eventDate: '2026-08-27T13:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-21T11:30:00.000Z',
    ),

    // 28 August - 3 events
    EventModel(
      eventName: 'Client Meeting',
      eventDate: '2026-08-28T09:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-18T14:20:00.000Z',
    ),
    EventModel(
      eventName: 'UI Design Review',
      eventDate: '2026-08-28T12:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-22T09:45:00.000Z',
    ),
    EventModel(
      eventName: 'Code Review',
      eventDate: '2026-08-28T15:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-22T10:00:00.000Z',
    ),

    // 29 August - 2 events
    EventModel(
      eventName: 'Firebase Integration',
      eventDate: '2026-08-29T10:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-22T12:10:00.000Z',
    ),
    EventModel(
      eventName: 'API Integration',
      eventDate: '2026-08-29T15:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-22T13:00:00.000Z',
    ),

    // 30 August - 1 event
    EventModel(
      eventName: 'Product Demo',
      eventDate: '2026-08-30T12:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-22T14:00:00.000Z',
    ),

    // 31 August - 3 events
    EventModel(
      eventName: 'Sprint Review',
      eventDate: '2026-08-31T10:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-15T10:00:00.000Z',
    ),
    EventModel(
      eventName: 'Sprint Planning',
      eventDate: '2026-08-31T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-23T08:30:00.000Z',
    ),
    EventModel(
      eventName: 'Team Retrospective',
      eventDate: '2026-08-31T16:30:00.000Z',
      eventStatus: 'cancelled',
      createdAt: '2026-08-23T09:00:00.000Z',
    ),

    // 1 September - 3 events
    EventModel(
      eventName: 'Project Kickoff',
      eventDate: '2026-09-01T09:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-23T08:30:00.000Z',
    ),
    EventModel(
      eventName: 'Development Meeting',
      eventDate: '2026-09-01T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-23T09:30:00.000Z',
    ),
    EventModel(
      eventName: 'QA Discussion',
      eventDate: '2026-09-01T16:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-23T10:00:00.000Z',
    ),

    // 2 September - 1 event
    EventModel(
      eventName: 'Backend Discussion',
      eventDate: '2026-09-02T13:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-23T10:20:00.000Z',
    ),

    // 3 September - 2 events
    EventModel(
      eventName: 'Code Review',
      eventDate: '2026-09-03T11:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-23T11:45:00.000Z',
    ),
    EventModel(
      eventName: 'QA Review',
      eventDate: '2026-09-03T16:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-23T12:00:00.000Z',
    ),

    // 4 September - 3 events
    EventModel(
      eventName: 'Product Demo',
      eventDate: '2026-09-04T09:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-24T09:00:00.000Z',
    ),
    EventModel(
      eventName: 'Client Feedback',
      eventDate: '2026-09-04T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-24T10:00:00.000Z',
    ),
    EventModel(
      eventName: 'Release Planning',
      eventDate: '2026-09-04T17:00:00.000Z',
      eventStatus: 'cancelled',
      createdAt: '2026-08-24T11:00:00.000Z',
    ),

    // 5 September - 1 event
    EventModel(
      eventName: 'Maps Integration',
      eventDate: '2026-09-05T10:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-24T10:30:00.000Z',
    ),

    // 7 September - 2 events
    EventModel(
      eventName: 'Team Lunch',
      eventDate: '2026-09-07T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-24T11:15:00.000Z',
    ),
    EventModel(
      eventName: 'Product Discussion',
      eventDate: '2026-09-07T15:30:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-24T12:00:00.000Z',
    ),

    // 8 September - 3 events
    EventModel(
      eventName: 'Performance Testing',
      eventDate: '2026-09-08T10:30:00.000Z',
      eventStatus: 'cancelled',
      createdAt: '2026-08-20T13:40:00.000Z',
    ),
    EventModel(
      eventName: 'Bug Fixing Session',
      eventDate: '2026-09-08T14:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-20T14:00:00.000Z',
    ),
    EventModel(
      eventName: 'Performance Review',
      eventDate: '2026-09-08T17:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-20T14:30:00.000Z',
    ),

    // 10 September - 1 event
    EventModel(
      eventName: 'App Release Meeting',
      eventDate: '2026-09-10T10:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-25T09:15:00.000Z',
    ),

    // 12 September - 2 events
    EventModel(
      eventName: 'QA Testing',
      eventDate: '2026-09-12T11:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-26T10:00:00.000Z',
    ),
    EventModel(
      eventName: 'Testing Review',
      eventDate: '2026-09-12T15:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-26T11:00:00.000Z',
    ),

    // 15 September - 3 events
    EventModel(
      eventName: 'Client Presentation',
      eventDate: '2026-09-15T09:30:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-27T14:30:00.000Z',
    ),
    EventModel(
      eventName: 'Project Review',
      eventDate: '2026-09-15T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-27T15:00:00.000Z',
    ),
    EventModel(
      eventName: 'Team Discussion',
      eventDate: '2026-09-15T16:30:00.000Z',
      eventStatus: 'cancelled',
      createdAt: '2026-08-27T15:30:00.000Z',
    ),

    // 18 September - 2 events
    EventModel(
      eventName: 'Monthly Meeting',
      eventDate: '2026-09-18T10:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-28T09:45:00.000Z',
    ),
    EventModel(
      eventName: 'Monthly Review',
      eventDate: '2026-09-18T14:30:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-28T10:30:00.000Z',
    ),

    // 22 September - 3 events
    EventModel(
      eventName: 'Project Retrospective',
      eventDate: '2026-09-22T09:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-29T11:20:00.000Z',
    ),
    EventModel(
      eventName: 'Project Planning',
      eventDate: '2026-09-22T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-29T12:00:00.000Z',
    ),
    EventModel(
      eventName: 'Project Closure',
      eventDate: '2026-09-22T17:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-29T13:00:00.000Z',
    ),

    // 30 September - 3 events
    EventModel(
      eventName: 'Product Launch',
      eventDate: '2026-09-30T10:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-30T10:15:00.000Z',
    ),
    EventModel(
      eventName: 'Launch Presentation',
      eventDate: '2026-09-30T13:00:00.000Z',
      eventStatus: 'accepted',
      createdAt: '2026-08-30T11:00:00.000Z',
    ),
    EventModel(
      eventName: 'Launch Celebration',
      eventDate: '2026-09-30T16:00:00.000Z',
      eventStatus: 'completed',
      createdAt: '2026-08-30T11:30:00.000Z',
    ),
  ];
  
  late Map<DateTime, List<EventModel>> _eventsByDay;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
    _calendarFormat = widget.initialCalendarFormat;

    _eventsByDay = _groupEventsByDay();
  }

  /// Groups events by calendar day and sorts them by event time.
  Map<DateTime, List<EventModel>> _groupEventsByDay() {
  final groupedEvents = <DateTime, List<EventModel>>{};

  // Step 1: Go through every event
  for (final event in eventList) {
    final eventDate = DateTime.parse(event.eventDate).toLocal();

    // Step 2: Get only the date
    final day = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
    );

    // Create a list if this day doesn't exist
    if (!groupedEvents.containsKey(day)) {
      groupedEvents[day] = [];
    }

    // Add the event to that day's list
    groupedEvents[day]!.add(event);
  }

  // Step 3: Sort events of each day by time
  for (final events in groupedEvents.values) {
    events.sort(
      (a, b) {
        final timeA = DateTime.parse(a.eventDate);
        final timeB = DateTime.parse(b.eventDate);

        return timeA.compareTo(timeB);
      },
    );
  }

  return groupedEvents;
}

  /// Returns all events for the selected calendar day.
  List<EventModel> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    return _eventsByDay[normalizedDay] ?? [];
  }

  /// Returns the color associated with an event status.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _buildCalendarCard(),
          ),
        ),
      ),
    );
  }

  /// Builds the main calendar card.
  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar<EventModel>(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

          
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            calendarStyle: const CalendarStyle(outsideDaysVisible: false),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(day, textColor: const Color(0xFF374151));
              },

              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  day,
                  backgroundColor: const Color(0xFFE5E7EB),
                  textColor: const Color(0xFF111827),
                  isBold: true,
                );
              },

              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  day,
                  backgroundColor: const Color(0xFFF3F4F6),
                  textColor: const Color(0xFF111827),
                  isBold: true,
                );
              },

              markerBuilder: (context, day, events) {
                if (events.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  bottom: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events.take(4).map((event) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 4.5,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: _getStatusColor(event.eventStatus),
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the calendar day cell.
  Widget _buildDayCell(
    DateTime day, {
    Color? backgroundColor,
    Color? borderColor,
    required Color textColor,
    bool isBold = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
