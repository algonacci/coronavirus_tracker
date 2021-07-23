import 'dart:io';

import 'package:coronavirus_rest_api_flutter_course/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/last_update_status_text.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _endpointsData;

  @override
  void initState() {
    super.initState();
    final dataRespository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRespository.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later',
        defaultActionText: 'Okay',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later',
        defaultActionText: 'Okay',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdateDateFormatter(
        lastUpdated: _endpointsData?.values[Endpoint.cases]?.date);
    return Scaffold(
      appBar: AppBar(
        title: Text('Coronavirus Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatusText(
              text: formatter.lastUpdatedStatusText(),
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData != null
                    ? _endpointsData!.values[endpoint]!.value
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
