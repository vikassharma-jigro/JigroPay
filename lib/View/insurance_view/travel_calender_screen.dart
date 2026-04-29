import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_caterogery_screen.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/font_family.dart';
import 'package:jigrotech/app_utils/text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectTravelDatesScreen extends StatefulWidget {
  const SelectTravelDatesScreen({Key? key}) : super(key: key);

  @override
  State<SelectTravelDatesScreen> createState() =>
      _SelectTravelDatesScreenState();
}

class _SelectTravelDatesScreenState extends State<SelectTravelDatesScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Travelling Dates",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateBox("Start Date", _startDate),
                Icon(Icons.arrow_forward, color: Colors.grey),
                _buildDateBox("End Date", _endDate),
              ],
            ),
            const SizedBox(height: 12),
            text(
              "Dates are in Indian Standard Time",
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansMedium,
              textColor: greyColor,
            ),
            const SizedBox(height: 12),

            // Calendar
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                rangeStartDay: _startDate,
                rangeEndDay: _endDate,
                calendarFormat: CalendarFormat.month,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _startDate = start;
                    _endDate = end;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  rangeHighlightColor: Colors.deepPurple.withOpacity(0.3),
                  rangeStartDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (_startDate != null && _endDate != null)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TravelCategoryScreen(),
                            ),
                          );
                          // Handle next action
                          print("Start: $_startDate, End: $_endDate");
                        }
                      : null,
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(String label, DateTime? date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(
              label,
              fontSize: 13,
              fontFamily: FontFamily.plusJakartaSansMedium,
              textColor: greyColor,
            ),
            SizedBox(height: 4),
            text(
              date != null
                  ? "${date.day} ${_monthName(date.month)} ${date.year}"
                  : "--",
              fontSize: 14,
              fontFamily: FontFamily.plusJakartaSansBold,
              textColor: blackColor,
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
