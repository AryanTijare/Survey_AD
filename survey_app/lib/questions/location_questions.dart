import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'questions.dart';

Future<Map<String, String>> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled');
    return {'error': 'Location services are disabled'};
  }

  print('Location services are enabled');

  // Request location permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return {'error': 'Location permissions are denied'};
    }
  }

  print('Permission granted');

  if (permission == LocationPermission.deniedForever) {
    return {'error': 'Location permissions are permanently denied'};
  }

  // Get the current location
  final LocationSettings locationSettings =
      LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

  try {
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    print('Position: $position');

    // Reverse geocode the coordinates to get address information
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('Placemarks: $placemarks');

    // Extract relevant location details
    if (placemarks.isNotEmpty) {
      List<String> country = [];
      List<String> state = [];
      List<String> district = [];
      List<String> city = [];
      List<String> locality = [];

      for (Placemark place in placemarks) {
        country.add(place.country ?? '');
        state.add(place.administrativeArea ?? '');
        district.add(place.subAdministrativeArea ?? '');
        city.add(place.subAdministrativeArea ?? '');
        city.add(place.locality ?? '');
        city.add(place.subLocality ?? '');
        locality.add(place.locality ?? '');
        locality.add(place.subLocality ?? '');
        locality.add(place.thoroughfare ?? '');
        locality.add(place.name ?? '');
        locality.add(place.street ?? '');
      }

      return {
        'country': _concatenateFields(_removeDuplicates(country)),
        'state': _concatenateFields(_removeDuplicates(state)),
        'district': _concatenateFields(_removeDuplicates(district)),
        'city': _concatenateFields(_removeDuplicates(city)),
        'locality': _concatenateFields(_removeDuplicates(locality)),
      };
      /*Placemark place = placemarks.first;
      return {
        'country': [place.country ?? ''],
        'state': [place.administrativeArea ?? ''],
        'city': [
          place.locality ?? '',
          place.subAdministrativeArea ?? '',
          place.subLocality ?? '',
          place.name ?? ''
        ],
        'district': [
          place.subAdministrativeArea ?? '',
          place.locality ?? '',
          place.subLocality ?? '',
          place.thoroughfare ?? '',
          place.name ?? ''
        ],
        'locality': [
          place.subLocality ?? '',
          place.thoroughfare ?? '',
          place.name ?? '',
        ],
        //'country': place.country ?? '',
        //'state': place.administrativeArea ?? '',
        //'city': place.subAdministrativeArea ?? '',
        //'district': place.subAdministrativeArea ?? '',
        //'locality': place.name ?? '',
      };*/
    } else {
      return {'error': 'Unable to determine location'};
    }
  } catch (e) {
    print('Error retrieving location: $e');
    return {'error': 'Error retrieving location'};
  }
}

String _concatenateFields(List<String> fields) {
  return fields
      .where((field) => field != Null && field.isNotEmpty)
      .join(', ')
      .trim();
}

List<String> _removeDuplicates(List<String> fields) {
  return fields.toSet().toList();
}

Future<List<Question>> generateLocationQuestions() async {
  print('location function called');
  Map<String, String> userLocation = await getUserLocation();

  if (userLocation.containsKey('error')) {
    // Handle the error
    return [];
  }

  List<Question> locationQuestions = [
    Question('What country are you in?', userLocation['country']!,
        QuestionType.location, 4),
    Question('What state are you in?', userLocation['state']!,
        QuestionType.location, 5),
    Question('What city are you in?', userLocation['city']!,
        QuestionType.location, 6),
    Question('What district are you in?', userLocation['district']!,
        QuestionType.location, 7),
    Question('What locality are you in?', userLocation['locality']!,
        QuestionType.location, 8),
  ];

  return locationQuestions;
}
