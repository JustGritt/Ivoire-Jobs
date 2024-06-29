import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoManager {
  //get device model
  Future<String> getDeviceModel() async {
    BaseDeviceInfo deviceInfo = await DeviceInfoPlugin().deviceInfo;
    
    return deviceInfo.data['model'];
  }
}
