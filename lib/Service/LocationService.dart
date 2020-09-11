import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:simply_weather/DataLayer/Location.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  //private constructor to ensure this class is only created here
  LocationService._internal();

  // ignore: close_sinks, as the subscribers will close when disposed this is always available
  final _locationChangeEventController = StreamController<Location>.broadcast();
  Stream<Location> get locationChangeEventStream => _locationChangeEventController.stream;

  Geolocator _geolocator = Geolocator();

  Future<Location> getCurrentLocation() async {
    _geolocator.forceAndroidLocationManager = true;

    try {
      Position position = await _geolocator
          .getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium, locationPermissionLevel: GeolocationPermission.locationWhenInUse)
          .timeout(Duration(seconds: 10))
          .catchError((error) => _geolocator.getLastKnownPosition());

      if (position != null) {
        final location = Location.fromGeoInfo(position.latitude, position.longitude);
        _locationChangeEventController.sink.add(location);
        return location;
      }
    } catch (PlatformException) {}

    return null;
  }
}
