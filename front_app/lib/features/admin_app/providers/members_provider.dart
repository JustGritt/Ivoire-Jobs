import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/models/member.dart';
import 'package:flutter/material.dart';

class MembersProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Member> _members = [];
  List<Member> _memberRequests = [];
  bool _isLoading = false;

  List<Member> get members => _members;
  List<Member> get memberRequests => _memberRequests;
  bool get isLoading => _isLoading;

  Future<List<Member>> getMemberRequests() async {
    _isLoading = true;
    notifyListeners();
    try {
      _memberRequests = await _adminService.getMemberRequests();
      return _memberRequests;
    } catch (e) {
      _memberRequests = [];
      return _memberRequests;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Member>> getMembers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _members = await _adminService.getMembers();
      return _members;
    } catch (e) {
      _members = [];
      return _members;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveMemberRequest(String id, String action) async {
    try {
      await _adminService.approveMemberRequest(id, action);
      await getMembers();
      await getMemberRequests();
    } catch (e) {
      debugPrint('Error approving member request: $e');
    }
  }
}
