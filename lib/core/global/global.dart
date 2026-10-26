import 'package:connectivity_plus/connectivity_plus.dart';

import '../common_widgets/app_toast.dart';

class Global {
  Global._();

  static final Connectivity connectivity = Connectivity();

  static Future<bool> checkInternet({
    bool showMsg = true,
  }) async {
    final results = await connectivity.checkConnectivity();

    final isConnected = results.any(
          (result) => result != ConnectivityResult.none,
    );

    if (isConnected) {
      return true;
    }

    if (showMsg) {
      AppToast.showToast(
        message:  'Check internet connection',
        isSuccess: false,
      );
    }

    return false;
  }
}