import 'package:flutter/material.dart';

class ReservationSuccessScreen extends StatelessWidget {
  const ReservationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Appointment Booked',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Check "Profile > My Appointments" to view details.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Close',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
