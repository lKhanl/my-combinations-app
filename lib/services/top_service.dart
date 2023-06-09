import 'dart:convert';

import 'package:MyCombinationsApp/pages/top/top_page.dart';
import 'package:MyCombinationsApp/utils/router_utils.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../model/top_model.dart';
import '../utils/snackbar_utils.dart';

class TopService {
  static final String? base = dotenv.env["API_URL"];

  void createTop(String name) async {
    final response = await http.post(
      Uri.parse("$base/api/v1/tops"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": GetStorage().read('token')
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      SnackbarUtils.showSuccess('Success', 'Top created');
      RouterUtils.goStateless(TopPage());
    } else {
      SnackbarUtils.showError(response.body);
    }
  }

  void updateTop(int id, String name) async {
    final response = await http.put(
      Uri.parse("$base/api/v1/tops/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": GetStorage().read('token')
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      SnackbarUtils.showSuccess('Success', 'Top updated');
      RouterUtils.goStateless(TopPage());
    } else {
      SnackbarUtils.showError(response.body);
    }
  }

  Future<List<Top>> getTops() async {
    final response = await http.get(Uri.parse("$base/api/v1/tops"), headers: {
      "Content-Type": "application/json",
      "Authorization": GetStorage().read('token')
    });

    if (response.statusCode == 200) {
      var content = json.decode(response.body);
      content = content.map<Top>((json) => Top.fromJson(json)).toList();
      return content;
    } else {
      SnackbarUtils.showError(response.body);
      throw Exception('Failed to load tops');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse("$base/api/v1/tops/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": GetStorage().read('token')
        });

    if (response.statusCode == 200) {
      SnackbarUtils.showSuccess(
        "Success",
        "Top deleted",
      );
      RouterUtils.goStateless(TopPage());
    } else {
      SnackbarUtils.showError(response.body);
      throw Exception('Failed to load tops');
    }
  }

  Future<void> uploadImage(int id, XFile image) async {
    final response =
        await http.post(Uri.parse("$base/api/v1/tops/$id/image"), headers: {
      "Content-Type": "multipart/form-data",
      "Authorization": GetStorage().read('token')
    }, body: <String, dynamic>{
      'file': image,
    });

    if (response.statusCode == 200) {
      SnackbarUtils.showSuccess(
        "Success",
        "Top image uploaded",
      );
      RouterUtils.goStateless(TopPage());
    } else {
      SnackbarUtils.showError(response.body);
      throw Exception('Failed to load tops');
    }
  }
}
