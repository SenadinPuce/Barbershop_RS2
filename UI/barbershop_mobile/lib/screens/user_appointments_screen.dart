import 'package:barbershop_mobile/models/appointment.dart';
import 'package:barbershop_mobile/providers/appointment_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserAppointmentsScreen extends StatefulWidget {
  const UserAppointmentsScreen({super.key});
  static const String routeName = "/user-appointments";

  @override
  State<UserAppointmentsScreen> createState() => _UserAppointmentsScreenState();
}

class _UserAppointmentsScreenState extends State<UserAppointmentsScreen> {
  late AppointmentProvider _appointmentProvider;
  List<Appointment>? _appointments;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _appointmentProvider = context.read<AppointmentProvider>();

    var appointmentsData = await _appointmentProvider
        .get(filter: {'clientId': Authorization.id, 'status': 'Reserved'});

    setState(() {
      _appointments = appointmentsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your appointments",
            style: GoogleFonts.tiltNeon(fontSize: 25)),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [_buildView()],
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ])),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _appointments?.length ?? 0,
          itemBuilder: (BuildContext context, index) {
            return _buildAppointmentTile(_appointments?[index]);
          });
    }
  }

  Widget _buildAppointmentTile(Appointment? a) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.grey[200],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.all(10),
          title: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('Date: ${formatDate(a?.startTime) ?? ''}')
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      'Time: ${formatTime(a?.startTime)} - ${formatTime(a?.endTime)}')
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('Barber: ${a?.barberUsername ?? ''}')
                ],
              )
            ],
          )),
          textColor: Colors.black,
          iconColor: Colors.black,
          trailing: ElevatedButton(
            onPressed: () async {
              Map request = {
                "ClientId": Authorization.id,
                "ServiceId": a?.serviceId,
                "Status": "Canceled"
              };

              await _appointmentProvider.update(a!.id!, request: request);

              loadData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.blueGrey,
                content: Text("You have canceled your reservation"),
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 3),
            child: const Text("Cancel"),
          ),
        ),
      ),
    );
  }
}
