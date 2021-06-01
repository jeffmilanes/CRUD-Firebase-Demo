import 'dart:convert';
import 'dart:io';

import 'package:morphosis_flutter_demo/home/model/team.dart';
import 'package:path_provider/path_provider.dart';

class LocalDB {
  Future<void> saveLocal(List<Team> data) async {
    final file = await _fileDirectory();
    await file.writeAsString(json.encode(data));
  }

  Future<List<Team>> readLocal() async {
    final file = await _fileDirectory();
    final myJson = await json.decode(await file.readAsString());
    return (myJson as List).map((e) => Team.fromJson(e)).toSet().toList();
  }

  Future<File> _fileDirectory() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }
}
