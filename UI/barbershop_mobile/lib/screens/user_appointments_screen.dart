import 'package:barbershop_mobile/models/appointment.dart';
import 'package:barbershop_mobile/providers/appointment_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
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

    var appointmentsData = await _appointmentProvider.get(filter: {
      'clientId': Authorization.id,
      'isCanceled': 'false',
      'dateFrom': DateTime.now()
    });

    setState(() {
      _appointments = appointmentsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your appointemnts'),
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
      if (_appointments != null && _appointments!.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You don't have any booked appointments.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
          child: (Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    formatDate(a?.date) ?? '',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${a?.startTime} - ${a?.endTime}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    a?.barberName ?? '',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.cut,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    a?.serviceName ?? '',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1.5,
              ),
              TextButton(
                  onPressed: () async {
                    bool confirmCancel = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Cancellation"),
                        content: const Text(
                            "Are you sure you want to cancel this appointment?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  color: Color.fromRGBO(213, 178, 99, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                  color: Color.fromRGBO(213, 178, 99, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );

                    if (confirmCancel == true) {
                      Map request = {
                        "isCanceled": true,
                      };

                      await _appointmentProvider.update(a!.id!,
                          request: request);

                      setState(() {
                        _appointments?.removeWhere(
                            (appointment) => appointment.id == a.id);
                      });

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                            duration: Duration(seconds: 2),
                            content:
                                Text("You have canceled your reservation")),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cancel appointment",
                        style: TextStyle(
                            fontSize: 17,
                            color: Color(0xfff71133),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ],
          )),
        ),
      ),
    );
  }
}
