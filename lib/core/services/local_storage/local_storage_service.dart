import 'package:flutter/services.dart';
import 'package:smarttime2/core/models/space.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String fileName = 'spaces_data.json';
  late Map<String, dynamic> data;

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    if (!await file.exists()) {
      final assetData = await rootBundle.loadString('assets/data/spaces_data.json');
      await file.writeAsString(assetData);
    }
    return file;
  }

  Future<List<Space>> loadSpaces() async {
    final file = await getFile();
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    return (data['spaces'] as List).map((e) => Space.fromJson(e)).toList();
  }

  Future<void> saveSpaces(List<Space> spaces) async {
    final file = await getFile();
    final data = {'spaces': spaces.map((e) => e.toJson()).toList()};

    await file.writeAsString(jsonEncode(data));
  }
}


