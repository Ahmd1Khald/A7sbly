import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _dateController = TextEditingController();
  String _daysLeftMessage = '';
  String _years = '';
  String _months = '';
  String _weeks = '';
  String _days = '';
  String _hours = '';
  String _minutes = '';
  String _seconds = '';
  Timer? _timer;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadSelectedDate();
  }

  Future<void> _loadSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDateString = prefs.getString('selectedDate');

    if (savedDateString != null) {
      final savedDate = DateTime.parse(savedDateString);
      _selectedDate = savedDate;
      _dateController.text =
          "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";
      _startCountdown();
    }
  }

  Future<void> _saveSelectedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDate', date.toIso8601String());
  }

  Duration durationUntil(DateTime futureDate) {
    final currentDate = DateTime.now();
    final difference = futureDate.difference(currentDate);
    return difference;
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final duration = durationUntil(_selectedDate!);

      if (duration.isNegative) {
        timer.cancel();
        setState(() {
          _daysLeftMessage = 'انتهى الوقت';
        });
      } else {
        setState(() {
          final years = duration.inDays ~/ 365;
          final months = (duration.inDays % 365) ~/ 30;
          final weeks = (duration.inDays % 365 % 30) ~/ 7;
          final days = (duration.inDays % 365 % 30) % 7;
          final hours = duration.inHours % 24;
          final minutes = duration.inMinutes % 60;
          final seconds = duration.inSeconds % 60;

          _daysLeftMessage =
              '$years سنة\n $months شهر\n $weeks أسبوع\n $days يوم\n $hours ساعة\n $minutes دقيق\n $seconds ثانية';
          _years = years.toString();
          _months = months.toString();
          _weeks = weeks.toString();
          _days = days.toString();
          _hours = hours.toString();
          _minutes = minutes.toString();
          _seconds = seconds.toString();
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2150),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _saveSelectedDate(pickedDate);
        _startCountdown();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/clock.png',
              width: 25,
            ),
            const Text(
              'احسبلي فاضل قد ايه',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Image.asset(
              'assets/images/clock.png',
              width: 25,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'اختار التاريخ',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _dateController,
                enableSuggestions: true,
                autocorrect: true,
                cursorColor: Colors.teal,
                cursorHeight: 20,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.date_range,
                    color: Colors.teal,
                    size: 26,
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              _daysLeftMessage.isEmpty
                  ? MaterialButton(
                      color: Colors.teal,
                      height: 55,
                      shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      onPressed: _startCountdown,
                      child: const Text(
                        'احسب',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        CustomContainer(
                          color: Colors.white,
                          text: _seconds,
                          title: 'ثانية',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              color: Colors.orange,
                              text: _days,
                              title: 'يوم',
                            ),
                            CustomContainer(
                              color: Colors.teal,
                              text: _hours,
                              title: 'ساعة',
                            ),
                            CustomContainer(
                              color: Colors.yellow,
                              text: _minutes,
                              title: 'دقيقة',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              color: Colors.green,
                              text: _years,
                              title: 'سنة',
                            ),
                            CustomContainer(
                              color: Colors.red,
                              text: _months,
                              title: 'شهر',
                            ),
                            CustomContainer(
                              color: Colors.blue,
                              text: _weeks,
                              title: 'أسبوع',
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
