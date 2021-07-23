import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';

class EndpointsData {
  EndpointsData({required this.values});
  final Map<Endpoint, EndpointData> values;
  EndpointData? get cases => values[Endpoint.cases];
  EndpointData? get deaths => values[Endpoint.deaths];
  EndpointData? get recovered => values[Endpoint.recovered];

  @override
  String toString() => 'cases: $cases, deaths: $deaths, recovered: $recovered';
}
