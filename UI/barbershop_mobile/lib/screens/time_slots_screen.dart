// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:barbershop_mobile/models/time_slot.dart';
import 'package:barbershop_mobile/providers/appointment_provider.dart';
import 'package:barbershop_mobile/providers/reservation_provider.dart';
import 'package:barbershop_mobile/providers/time_slot_provider.dart';
import 'package:barbershop_mobile/screens/reservation_success.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/back_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';
import '../widgets/time_range_display.dart';

class TimeSlotsScreen extends StatefulWidget {
  int barberId;

  TimeSlotsScreen({
    super.key,
    required this.barberId,
  });

  @override
  State<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  late TimeSlotProvider _timeSlotProvider;
  late ReservationProvider _reservationProvider;
  late AppointmentProvider _appointmentProvider;
  List<TimeSlot> _timeSlots = [];
  List<bool> _isSelectedList = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  String _startTime = '';
  String _endTime = '';

  @override
  void initState() {
    super.initState();
    _timeSlotProvider = context.read<TimeSlotProvider>();
    _appointmentProvider = context.read<AppointmentProvider>();
    loadTimeSlots();
  }

  loadTimeSlots() async {
    var timeSlotsData = await _timeSlotProvider
        .get(filter: {'barberId': widget.barberId, "date": _selectedDate});

    setState(() {
      _timeSlots = timeSlotsData;
      _isSelectedList = List.filled(_timeSlots.length, false);
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reservationProvider = context.watch<ReservationProvider>();
  }

  int calculateTotalServiceDuration() {
    int totalDuration = 0;
    if (_reservationProvider.selectedServices != null) {
      for (Service service in _reservationProvider.selectedServices!) {
        totalDuration += service.durationInMinutes ?? 0;
      }
    }
    return totalDuration;
  }

  void autoSelectTimeSlots(int selectedIndex) {
    if (_timeSlots.isEmpty) {
      return;
    }
    int startIndex = _isSelectedList.indexOf(true);

    _isSelectedList = List.filled(_timeSlots.length, false);

    if (startIndex == selectedIndex) return;

    int totalDuration = calculateTotalServiceDuration();
    int currentIndex = selectedIndex;

    while (currentIndex < _timeSlots.length &&
        totalDuration > 0 &&
        !_isSelectedList[currentIndex]) {
      _isSelectedList[currentIndex] = true;
      totalDuration -= 5;
      currentIndex++;
    }

    setState(() {});
  }

  void _updateSelectedTimeRange() {
    int startIndex = _isSelectedList.indexOf(true);
    int endIndex = _isSelectedList.lastIndexOf(true) + 1;

    if (startIndex != -1 && endIndex != -1) {
      _startTime = formatTime(_timeSlots[startIndex].dateTime)!;
      _endTime = formatTime(_timeSlots[endIndex].dateTime)!;
      _reservationProvider.startTime = _timeSlots[startIndex].dateTime;
    } else {
      _startTime = '';
      _endTime = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              _buildSearch(),
              const SizedBox(
                height: 20,
              ),
              _hasSelectedTime()
                  ? _buildTimeRangeDisplay()
                  : const SizedBox(
                      height: 20,
                    ),
              const SizedBox(
                height: 20,
              ),
              if (!_isLoading) _buildView(),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildBookNowButton(),
        )
      ]),
    );
  }

  Widget _buildTimeRangeDisplay() {
    return SizedBox(
      height: 20,
      child: TimeRangeDisplay(
        startTime: _startTime,
        endTime: _endTime,
      ),
    );
  }

  bool _hasSelectedTime() {
    return _isSelectedList.contains(true);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
        child: Text(
          "Time slots",
          style: TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _isLoading = true;
        _selectedDate = picked;
        loadTimeSlots();
      });
    }
  }

  Widget _buildSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(57, 131, 120, 1), width: 1)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Color.fromRGBO(213, 178, 99, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildView() {
    if (_timeSlots.isEmpty) {
      return const Text('No available time slots for selected date.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Time Slot:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: _timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = _timeSlots[index];

              return InkWell(
                onTap: () {
                  setState(() {
                    autoSelectTimeSlots(index);
                    _updateSelectedTimeRange();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isSelectedList[index] ? Colors.blue : Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      formatTime(timeSlot.dateTime)!,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _isSelectedList[index] ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
  }

  Widget _buildBookNowButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: const Color.fromRGBO(84, 181, 166, 0.6),
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(double.infinity, 45),
              elevation: 3),
          onPressed: _isSelectedList.contains(true)
              ? () async {
                  try {
                    List<int> selectedServiceIds = _reservationProvider
                        .selectedServices!
                        .map((service) => service.id ?? 0)
                        .toList();

                    int startIndex = _isSelectedList.indexOf(true);

                    String formattedStartTime =
                        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                            .format(_timeSlots[startIndex].dateTime!);

                    Map request = {
                      'startTime': formattedStartTime,
                      'barberId': _reservationProvider.barberId,
                      'clientId': Authorization.id,
                      'serviceIds': selectedServiceIds
                    };

                    await _appointmentProvider.insert(request: request);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const ReservationSuccessScreen());
                  } on Exception catch (e) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Something went wrong, please try again later.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Ok"))
                              ],
                            ));
                  }
                }
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Book Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.calendar_today)
            ],
          ),
        ),
      ),
    );
  }
}
