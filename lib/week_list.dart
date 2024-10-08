import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widgets/cubit/schedule_cubit.dart';

class WeekList extends StatelessWidget {
  final DateTime currentWeekStart;

  const WeekList({super.key, required this.currentWeekStart});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        DateTime selectedDay = context.read<ScheduleCubit>().selectedDay;

        List<Widget> days = List.generate(7, (index) {
          DateTime dateTime = currentWeekStart.add(Duration(days: index));
          int day = dateTime.day;
          List<String> weekdaysInRu = [
            "ПН",
            "ВТ",
            "СР",
            "ЧТ",
            "ПТ",
            "СБ",
            "ВС",
          ];

          return GestureDetector(
            onTap: () {
              !_isDateBefore(dateTime, DateTime.now())
                  ? context.read<ScheduleCubit>().updateSelectedDay(dateTime)
                  : null;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _determineBackgroundColor(dateTime, selectedDay),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: [
                  Text(
                    weekdaysInRu[index],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: _isDatesEqual(dateTime, selectedDay) &&
                              _isDatesEqual(dateTime, DateTime.now())
                          ? const Color(0xFFA03FFF)
                          : _isDatesEqual(dateTime, DateTime.now())
                              ? const Color(0xFFD6B5FF)
                              : const Color(0xFF817B89),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.toString(),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: _determineDayColor(dateTime, selectedDay)),
                  ),
                ],
              ),
            ),
          );
        });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days,
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isDatesEqual(DateTime first, DateTime second) {
    return first.day == second.day &&
        first.month == second.month &&
        first.year == second.year;
  }

  bool _isDateBefore(DateTime first, DateTime second) {
    return DateTime(first.year, first.month, first.day)
        .isBefore(DateTime(second.year, second.month, second.day));
  }

  Color _determineBackgroundColor(DateTime date, DateTime selectedDay) {
    if (_isDatesEqual(date, selectedDay) &&
        _isDatesEqual(date, DateTime.now())) {
      return Colors.white;
    } else if (_isDatesEqual(date, selectedDay) &&
        !_isDatesEqual(date, DateTime.now())) {
      return Colors.white;
    } else if (!_isDatesEqual(date, selectedDay) &&
        _isDatesEqual(date, DateTime.now())) {
      return const Color(0xFFA03FFF);
    } else {
      return Colors.transparent;
    }
  }

  Color _determineDayColor(DateTime date, DateTime selectedDay) {
    if (_isDateBefore(date, DateTime.now())) {
      return const Color(0xFF71727A);
    } else if (_isDatesEqual(date, selectedDay) &&
        _isDatesEqual(date, DateTime.now())) {
      return const Color(0xFFA03FFF);
    } else if (_isDatesEqual(date, DateTime.now())) {
      return Colors.white;
    } else {
      return const Color(0xFF494A50);
    }
  }
}
