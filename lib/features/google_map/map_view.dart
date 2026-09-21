// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapView extends StatefulWidget {
//   const GoogleMapView({super.key});

//   @override
//   State<GoogleMapView> createState() => _GoogleMapViewState(); //
// }

// class _GoogleMapViewState extends State<GoogleMapView> {
//   bool _isLoading = true;

//   final Set<Marker> _markers = {};

//   CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(28.6139, 77.2090),
//     zoom: 14,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }

//   Future<void> _initializeMap() async {
//     await Future.wait([
//       _loadCurrentLocation(),
//       _loadMarkers(),
//     ]);

//     if (mounted) {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _loadCurrentLocation() async {
//     try {
//       var permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         return;
//       }

//       final position = await Geolocator.getCurrentPosition();

//       _initialPosition = CameraPosition(
//         target: LatLng(
//           position.latitude,
//           position.longitude,
//         ),
//         zoom: 14,
//       );

//       _markers.add(
//         Marker(
//           markerId: const MarkerId('current_location'),
//           position: LatLng(
//             position.latitude,
//             position.longitude,
//           ),
//           infoWindow: const InfoWindow(
//             title: 'My Location',
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Location Error: $e');
//     }
//   }

//   Future<void> _loadMarkers() async {
//     try {
//       final icon = await BitmapDescriptor.asset(
//         const ImageConfiguration(
//           size: Size(48, 48),
//         ),
//         'assets/images/pngs/custom.png',
//       );

//       final locations = [
//         ('dhillon_plaza', 'Dhillon Plaza', 30.651920, 76.821850),
//         ('elante', 'Elante Mall', 30.704648, 76.800157),
//         ('bus_stand', 'Zirakpur Bus Stand', 30.639580, 76.826350),
//         ('big_bazaar', 'Big Bazaar', 30.639500, 76.821900),
//         ('paras_mall', 'Paras Downtown Mall', 30.642900, 76.817000),
//         ('highway', 'Ambala Highway', 30.646800, 76.825600),
//         ('walmart', 'Best Price Walmart', 30.649800, 76.812200),
//         ('vip_road', 'VIP Road', 30.643300, 76.822000),
//         ('patiala_road', 'Patiala Road', 30.634500, 76.829700),
//       ];

//       _markers.addAll(
//         locations.map(
//           (location) => Marker(
//             markerId: MarkerId(location.$1),
//             position: LatLng(location.$3, location.$4),
//             infoWindow: InfoWindow(
//               title: location.$2,
//             ),
//             icon: icon,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Marker Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : GoogleMap(
//                 initialCameraPosition: _initialPosition,
//                 markers: _markers,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//               ),
//       ),
//     );
//   }
// }