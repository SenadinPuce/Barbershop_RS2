import 'package:flutter/material.dart';

import '../widgets/barbers_report_screen.dart';
import '../widgets/orders_report_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(84, 181, 166, 0.7),
          ),
          child: TabBar(
            controller: _tabController,
            indicator:
                const BoxDecoration(color: Color.fromRGBO(84, 181, 166, 1)),
            labelColor: Colors.white,
            tabs: const [
              Tab(
                text: 'Generate barbers report',
                icon: Icon(Icons.work_rounded),
              ),
              Tab(
                text: 'Generate orders report',
                icon: Icon(Icons.show_chart_rounded),
              )
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: TabBarView(
            controller: _tabController,
            children: const [
              BarbersReportScreen(),
              OrdersReportScreen(),
            ],
          ),
        ))
      ],
    );
  }
}
