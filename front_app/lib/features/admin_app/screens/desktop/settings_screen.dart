import 'package:barassage_app/features/admin_app/services/dashboard_settings_service.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class DashboardSettings extends StatefulWidget {
  const DashboardSettings({super.key});

  @override
  State<DashboardSettings> createState() => _DashboardSettingsState();
}

class _DashboardSettingsState extends State<DashboardSettings> {
  bool isMaintenanceMode = false;
  final TextEditingController ipController = TextEditingController();
  List<String> ipList = [];
  final DashboardSettingsService _dashboardSettingsService =
      DashboardSettingsService();
  String? currentUserIpV4;
  String? currentUserIpV6;

  @override
  void initState() {
    super.initState();
    fetchMaintenanceMode();
    fetchWhitelistIps();
    fetchClientIps();
  }

  void fetchMaintenanceMode() async {
    try {
      bool status = await _dashboardSettingsService.getMaintenanceMode();
      setState(() {
        isMaintenanceMode = status;
      });
    } catch (e) {
      debugPrint('Error fetching maintenance mode status: $e');
    }
  }

  void fetchWhitelistIps() async {
    try {
      List<String> ips = await _dashboardSettingsService.getWhitelistIps();
      setState(() {
        ipList = ips;
      });
    } catch (e) {
      debugPrint('Error fetching IP whitelist: $e');
    }
  }

  Future<void> fetchClientIps() async {
    final ipV4Future = getClientIpV4();
    final ipV6Future = getClientIpV6();

    final ips = await Future.wait([ipV4Future, ipV6Future]);
    setState(() {
      currentUserIpV4 = ips[0];
      currentUserIpV6 = ips[1];
    });
  }

  Future<String?> getClientIpV4() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'];
      }
    } catch (e) {
      debugPrint('Error fetching IPv4: $e');
    }
    return null;
  }

  Future<String?> getClientIpV6() async {
    try {
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'];
      }
    } catch (e) {
      debugPrint('Error fetching IPv6: $e');
    }
    return null;
  }

  Future<void> toggleMaintenanceMode(bool value) async {
    if (value && (ipList.isEmpty || ipList.length == 1)) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Maintenance Mode'),
            content: const Text(
                'Are you sure you want to enable maintenance mode with an empty or single IP whitelist?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (confirm != true) {
        return;
      }
    }

    try {
      await _dashboardSettingsService.setMaintenanceMode(value);
      setState(() {
        isMaintenanceMode = value;
      });
    } catch (e) {
      debugPrint('Error setting maintenance mode status: $e');
    }
  }

  Future<void> addIpsToList() async {
    final ipV4Future = getClientIpV4();
    final ipV6Future = getClientIpV6();

    final ips = await Future.wait([ipV4Future, ipV6Future]);
    String? ipV4 = ips[0];
    String? ipV6 = ips[1];

    final updatedIpList = List<String>.from(ipList);
    if (ipV4 != null && ipV4.isNotEmpty && !updatedIpList.contains(ipV4)) {
      updatedIpList.add(ipV4);
    }
    if (ipV6 != null && ipV6.isNotEmpty && !updatedIpList.contains(ipV6)) {
      updatedIpList.add(ipV6);
    }

    try {
      await _dashboardSettingsService.setWhitelistIps(updatedIpList);
      setState(() {
        ipList = updatedIpList;
      });
    } catch (e) {
      debugPrint('Error adding IPs to whitelist: $e');
    }
  }

  void addIpFromController() async {
    String ip = ipController.text;
    if (ip.isNotEmpty && !ipList.contains(ip)) {
      final updatedIpList = List<String>.from(ipList)..add(ip);
      try {
        await _dashboardSettingsService.setWhitelistIps(updatedIpList);
        setState(() {
          ipList = updatedIpList;
          ipController.clear();
        });
      } catch (e) {
        debugPrint('Error adding IP to whitelist: $e');
      }
    }
  }

  void removeIpFromList(String ip) async {
    final updatedIpList = List<String>.from(ipList)..remove(ip);
    try {
      await _dashboardSettingsService.setWhitelistIps(updatedIpList);
      setState(() {
        ipList = updatedIpList;
      });
    } catch (e) {
      debugPrint('Error removing IP from whitelist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.9;
    if (maxWidth < 800) {
      maxWidth = 800;
    }

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Maintenance mode',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        color: Colors.transparent,
                        child: Switch(
                          value: isMaintenanceMode,
                          onChanged: toggleMaintenanceMode,
                          inactiveTrackColor: tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add your IP to whitelist',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ipController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText: 'User IP',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: addIpFromController,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: tertiary,
                            ),
                            child: Icon(Icons.add, color: primary),
                          ),
                          ElevatedButton(
                            onPressed: addIpsToList,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: tertiary,
                            ),
                            child: Icon(Icons.person_add, color: primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User IP List',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ipList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(ipList[index]),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: primary),
                                  onPressed: () =>
                                      removeIpFromList(ipList[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
