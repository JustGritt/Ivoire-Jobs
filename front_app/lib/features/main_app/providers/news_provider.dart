import 'package:barassage_app/features/main_app/models/model.dart';
import 'package:flutter/foundation.dart';

class NewsProvider extends ChangeNotifier {
  NewsResponseModel? _nrm;
  bool isLoading = false;

  NewsResponseModel get newsResponse => _nrm!;

  void search(String searchTerm, {bool input = true}) async {
    if (isLoading == true) {
      isLoading = false;
    }

    //   Response res = await _http
    //       .get(ApiEndpoint.news, params: {'q': searchTerm, 'lang': 'en'});
    //   if (res.statusCode == 200 && res.statusCode != 429) {
    //     // print(res);
    //     _nrm = NewsResponseModel.fromJson(res.toString());
    //     isLoading = true;
    //     input = false;
    //     notifyListeners();
    //   }
    // }
  }
}
