import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  LatLng _currentPosition = const LatLng(37.785834, -122.406417);
  List<Marker> markers = [];
  final mapController = MapController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';
  String _selectedFilter = "All";

  get http => null;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeSpeechRecognizer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myServicesProvider = Provider.of<MyServicesProvider>(context, listen: false);
      myServicesProvider.getCategories();
      _loadNearbyServices();
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeSpeechRecognizer() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (!available) {
      _showErrorDialog('Speech recognition not available');
    }
  }

  void _setMarkerToCurrentPosition() {
    Marker newMarker = Marker(
      point: _currentPosition,
      width: 80,
      height: 80,
      child: const Icon(Icons.location_on, color: Colors.blue),
    );
    if (mounted) {
      setState(() {
        markers.add(newMarker);
      });
    }
  }

  void _loadNearbyServices() async {
    final myServicesProvider = Provider.of<MyServicesProvider>(context, listen: false);
    await myServicesProvider.getNearbyServices();
    if (mounted) {
      _addServiceMarkers(myServicesProvider.services);
    }
  }

  void _addServiceMarkers(List<ServiceCreatedModel> services) {
    if (mounted) {
      setState(() {
        markers.clear();
        _setMarkerToCurrentPosition();
        for (var service in services) {
          markers.add(
            Marker(
              point: LatLng(service.latitude, service.longitude),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailPage(service: service),
                    ),
                  );
                },
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
            ),
          );
        }
      });
    }
  }

  void animatePosition() {
    mapController.move(_currentPosition, 16);
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _searchController.text = '';
          _setMarkerToCurrentPosition();
        });
        mapController.move(_currentPosition, 18);
        _loadNearbyServices();
      }
    } catch (e) {
      _showErrorDialog('Failed to get current location: $e');
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _recognizedText = val.recognizedWords;
            _searchController.text = _recognizedText;
            _performSearch();
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      _showErrorDialog('Please enter a location to search.');
      return;
    }

    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];
      if (features.isNotEmpty) {
        final firstResult = features[0];
        final center = firstResult['center'];
        final lng = center[0];
        final lat = center[1];

        if (mounted) {
          setState(() {
            _currentPosition = LatLng(lat, lng);
            markers.clear();
            _setMarkerToCurrentPosition();
            mapController.move(_currentPosition, 18);
          });
          _loadNearbyServices();
        }
      } else {
        _showErrorDialog('No results found for "$query".');
      }
    } else {
      _showErrorDialog('Failed to fetch search results.');
    }
  }

  void _filterServices(String filter) async {
    final myServicesProvider =
        Provider.of<MyServicesProvider>(context, listen: false);
    await myServicesProvider.filterServices(filter);
    if (mounted) {
      _addServiceMarkers(myServicesProvider.services);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8),
                          border: InputBorder.none,
                          hintText: 'Your location',
                          helperStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        onSubmitted: (value) {
                          _performSearch();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _performSearch();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        animatePosition();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: _isListening ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        _listen();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<MyServicesProvider>(
                  builder: (context, myServicesProvider, child) {
                    List<String> filters = ["All"];
                    filters.addAll(myServicesProvider.categories
                        .map((category) => category.name)
                        .toList());

                    return Row(
                      children: filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _selectedFilter == filter
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            selected: _selectedFilter == filter,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                              _filterServices(_selectedFilter);
                            },
                            selectedColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(
                                color: _selectedFilter == filter
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                            elevation: 4,
                            pressElevation: 6,
                            checkmarkColor: _selectedFilter == filter
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 16,
                  minZoom: 10,
                  maxZoom: 20,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
                  ),
                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onSelected: (bool value) {},
      backgroundColor: Colors.grey[300],
      selectedColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
