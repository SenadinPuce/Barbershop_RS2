import 'dart:typed_data';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

class BarbersReportScreen extends StatefulWidget {
  const BarbersReportScreen({super.key});

  @override
  State<BarbersReportScreen> createState() => _BarbersReportScreenState();
}

class _BarbersReportScreenState extends State<BarbersReportScreen> {
  late AppointmentProvider _appointmentProvider;
  late UserProvider _userProvider;
  List<User>? _barbersList;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  User? _selectedBarber;
  List<Appointment>? appointments;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _appointmentProvider = context.read<AppointmentProvider>();
    _userProvider = context.read<UserProvider>();

    _loadBarbers();
  }

  Future<void> _loadBarbers() async {
    if (_barbersList == null) {
      var barbers =
          await _userProvider.getUsers(filter: {'roleName': 'barber'});
      setState(() {
        _barbersList = List.from(barbers);
      });
    }
  }

  Future<void> _loadAppointments() async {
    var appointmentsData = await _appointmentProvider.get(filter: {
      'dateFrom': _selectedDateFrom,
      'dateTo': _selectedDateTo,
      'barberId': _selectedBarber?.id,
      'isCanceled': false,
    });

    setState(() {
      appointments = appointmentsData;
      isLoading = false;
    });
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Report',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 14,
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Period: ${getDate(_selectedDateFrom)} - ${getDate(_selectedDateTo)}',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.Text(
                  'Number of Booked Appointments: ${appointments?.length ?? 0}',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.Text(
                  'Minutes Worked: $getNumberOfMinutesWorked',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Total Revenue: $_totalIncome \$',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 10,
                  ),
                ),
              ],
            );
          }),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBarberFilters(),
        const SizedBox(
          height: 30,
        ),
        if (isLoading == true)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (appointments == null)
          Container()
        else
          Card(
            color: const Color.fromRGBO(84, 181, 166, 1),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Period : ${getDate(_selectedDateFrom)} - ${getDate(_selectedDateTo)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Number of Booked Appointments: ${appointments?.length ?? 0}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Duration of Work: $getNumberOfMinutesWorked minutes',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Total Income: $_totalIncome \$',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: PdfPreview(
                                initialPageFormat: PdfPageFormat.a4,
                                build: (format) => _generatePdf(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          'Preview PDF',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Row _buildBarberFilters() {
    return Row(
      children: [
        Expanded(
            child: DateTimeFormField(
          validator: FormBuilderValidators.required(),
          decoration: const InputDecoration(
            labelText: 'From date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          initialValue: _selectedDateFrom,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateFrom = value;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DateTimeFormField(
          decoration: const InputDecoration(
            labelText: 'To date',
            floatingLabelStyle:
                TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(213, 178, 99, 1)),
            ),
          ),
          initialValue: _selectedDateTo,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          dateFormat: DateFormat('dd MMM yyyy'),
          mode: DateTimeFieldPickerMode.date,
          onDateSelected: (value) {
            setState(() {
              _selectedDateTo = value;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: DropdownButtonFormField<User>(
          decoration: InputDecoration(
              labelText: "Barber",
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                  onPressed: () => {
                        setState(() {
                          _selectedBarber = null;
                        })
                      },
                  icon: const Icon(Icons.close)),
              hintText: 'Select barber'),
          value: _selectedBarber,
          items: _barbersList
              ?.map<DropdownMenuItem<User>>(
                  (User user) => DropdownMenuItem<User>(
                        alignment: AlignmentDirectional.center,
                        value: user,
                        child: Text(user.username ?? ''),
                      ))
              .toList(),
          onChanged: (User? newValue) {
            setState(() {
              _selectedBarber = newValue;
            });
          },
        )),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            _loadAppointments();
          },
          child: const Text("Generate"),
        ),
      ],
    );
  }

  int get getNumberOfMinutesWorked {
    if (appointments == null) {
      return 0;
    }
    return appointments!.map<int>((appointment) {
      final startTime = DateFormat.Hm().parse(appointment.startTime!);
      final endTime = DateFormat.Hm().parse(appointment.endTime!);
      return endTime.difference(startTime).inMinutes;
    }).fold(0, (previousValue, element) => previousValue + element);
  }

  double get _totalIncome {
    if (appointments == null) {
      return 0.0;
    }
    return appointments!
        .map<double>((appointment) => appointment.servicePrice ?? 0.0)
        .fold(0.0, (previousValue, element) => previousValue + element);
  }
}
