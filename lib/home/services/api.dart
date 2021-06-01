import 'package:dio/dio.dart';
import 'package:morphosis_flutter_demo/home/model/team.dart';

class ApiClient {
  final _client = Dio();
  static const _teamUrl = 'https://api.opendota.com/api/teams';

  Future<List<Team>> getTeams() async {
    Response response = await _client.get(_teamUrl);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => Team.fromJson(e))
          .toSet()
          .toList();
    } else {
      throw Exception('Unable to perform request!');
    }
  }
}
