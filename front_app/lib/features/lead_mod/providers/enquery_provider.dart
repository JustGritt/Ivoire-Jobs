import 'package:barassage_app/features/lead_mod/services/services.dart';
import 'package:barassage_app/features/lead_mod/models/models.dart';
import 'package:flutter/material.dart';

class EnqueryProvider extends ChangeNotifier {
  List<EnqueryData>? _enqueries;
  EnqueryData? _enquery;
  bool isLoaded = false;

  // EnqueryProvider() {
  //   setEnquery();
  // }

  void setEnquery() {
    // if (isLoaded == true) {
    //   isLoaded = false;
    //   _enqueries = null;
    //   notifyListeners();
    // }

    Future.microtask(() async {
      EnqueryService es = EnqueryService();
      Enquery? eq = await es.getAll();
      _enqueries = eq!.data!;
      isLoaded = true;
      notifyListeners();
    });
  }

  List<EnqueryData>? get enqueries {
    if (_enqueries != null && isLoaded == true) {
      return _enqueries!;
    }
    return null;
  }

  void findEnqeryData(int id) {
    Future.microtask(() async {
      isLoaded = false;
      EnqueryService es = EnqueryService();
      EnquerySingle? eq = await es.getOne(id);
      _enquery = eq!.data!;
      isLoaded = true;
      notifyListeners();
    });
  }

  EnqueryData? get enquery {
    if (_enquery != null) {
      return _enquery!;
    }
    return null;
  }

  Future<EnqueryData>? getEnqeryData(int id) async {
    isLoaded = false;
    EnqueryService es = EnqueryService();
    EnquerySingle? eq = await es.getOne(id);
    _enquery = eq!.data!;
    isLoaded = true;
    notifyListeners();
    return _enquery!;
  }
}
