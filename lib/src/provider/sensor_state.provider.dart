import 'package:flutter/material.dart';

class SensorStateProvider with ChangeNotifier {
  bool _sensorState = true;

  bool get sensorView => _sensorState;

  void sensoFalse() {
    _sensorState = false;
    notifyListeners();
  }

  void sensoTrue() {
    _sensorState = true;
    notifyListeners();
  }
}
