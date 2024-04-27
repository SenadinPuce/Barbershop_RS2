import 'package:barbershop_mobile/providers/reservation_provider.dart';
import 'package:barbershop_mobile/providers/service_provider.dart';
import 'package:barbershop_mobile/screens/time_slots_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/back_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  late ServiceProvider _serviceProvider;
  late ReservationProvider _reservationProvider;
  List<Service> _services = [];
  List<Service> _selectedServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    _serviceProvider = context.read<ServiceProvider>();
    _reservationProvider = context.read<ReservationProvider>();

    var servicesData = await _serviceProvider.get();

    setState(() {
      _services = servicesData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [_buildHeader(), _buildCheckboxGroup()]),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildNextStepButton(),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
        child: Text(
          "Choose service",
          style: TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup() {
    if (_services.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _services.map((service) {
        bool isChecked = _selectedServices.contains(service);

        return CheckboxListTile(
          contentPadding: const EdgeInsets.all(5),
          title: Text(
            service.name ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.description ?? ''),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Price: ${formatNumber(service.price)} \$',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Duration: ${service.durationInMinutes} mins',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                _selectedServices.add(service);
              } else {
                _selectedServices.remove(service);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNextStepButton() {
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
          onPressed: _selectedServices.isEmpty
              ? null
              : () {
                  _reservationProvider.selectedServices = _selectedServices;

                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: TimeSlotsScreen(
                        barberId: _reservationProvider.barberId!,
                      ));
                },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Time Slot',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
