import 'package:morphosis_flutter_demo/home/model/team.dart';
import 'package:morphosis_flutter_demo/home/services/api.dart';
import 'package:morphosis_flutter_demo/home/services/local.dart';

class TeamRepo {
  TeamRepo({ApiClient? apiClient, LocalDB? localDB})
      : _apiClient = apiClient ?? ApiClient(),
        _localDB = localDB ?? LocalDB();

  final ApiClient _apiClient;
  final LocalDB _localDB;

  Future<List<Team>> getTeam(String? text) async {
    if (text == null) {
      final team = await _apiClient.getTeams();
      await _localDB.saveLocal(team); // save to local storage
      return await _localDB.readLocal();
    }

    List<Team> _teamList = await _localDB.readLocal();
    List<Team> _searchList = [];

    _teamList.forEach((element) {
      if (element.name!.toLowerCase().contains(text.toLowerCase()) ||
          element.tag!.toLowerCase().contains(text.toLowerCase())) {
        _searchList.add(element);
      }
    });

    return _searchList;
  }
}
