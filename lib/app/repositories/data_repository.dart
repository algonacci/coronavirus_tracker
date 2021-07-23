import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({required this.apiService, required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String? _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointsData,
    );
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      // if unauthorized, get access token again
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndpointsData(
      values: {
        Endpoint.cases: values[0],
        Endpoint.deaths: values[1],
        Endpoint.recovered: values[2],
      },
    );
  }
}
