import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:quest_server/core/service/database.service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DatabaseNotifier extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  Future fetchData() async {
    await _databaseService.fetchId();
  }

  Future<PostgrestResponse?> addInfo(
      {required String id,
      required String email,
      required String phone}) async {
    await _databaseService.addInfo(
      id: id,
      email: email,
      phone: phone,
    );
  }
}
