import 'package:coronavirus_rest_api_flutter_course/app/services/api_keys.dart';

enum Endpoint {
  cases,
  deaths,
  recovered,
}

class API {
  API({required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);

  static final String host = 'ncov2019-admin.firebaseapp.com';

  Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        path: 'token',
      );

  Uri endpointUri(Endpoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoint],
      );

  static Map<Endpoint, String> _paths = {
    Endpoint.cases: 'cases',
    Endpoint.deaths: 'deaths',
    Endpoint.recovered: 'recovered',
  };
}
