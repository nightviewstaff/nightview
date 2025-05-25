// class MapboxSettings {
//     MapWidget(
//       styleUri: "mapbox://styles/nightview/cmb0q53y2008l01rk9wqb0jv3",
//       cameraOptions: initialCamera!,
// // gestureRecognizers: rotate: false,,
//       onMapCreated: _onMapCreated,
//       onStyleLoadedListener: _onStyleLoaded,
//     );

//   Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
//     annotationManager =
//         await mapController!.annotations.createPointAnnotationManager();
//     _addClubMarkers();

//     // Listen for club data updates
//     context.read<ClubDataHelper>().clubDataList.addListener(_addClubMarkers);

//     // 💡 Ornament customization
//     await mapController?.attribution.updateSettings(
//       AttributionSettings(
//         position: OrnamentPosition.TOP_LEFT,
//         marginLeft: 4.0,
//         marginTop: 4.0,
//         iconColor: 0x00000000, // Fully transparent
//       ),
//     );

    // print("Scale bar settings applied");
    // await mapController?.scaleBar.updateSettings(
    //   ScaleBarSettings(
    //     enabled: false,
    //   ),
    // );

//     await mapController?.logo.updateSettings(
//       LogoSettings(
//         enabled: false, // Optional: hides Mapbox logo if allowed
//       ),
//     );

//     await mapController?.setBounds(
//       CameraBoundsOptions(
//         minZoom: 1.0,
//       ),
//     );

//     await mapController?.attribution.updateSettings(
//       AttributionSettings(
//         enabled: false, // Attempt to disable it
//         position: OrnamentPosition.TOP_LEFT,
//         marginLeft: 4.0,
//         marginTop: 4.0,
//       ),
//     );

//     await mapController?.compass.updateSettings(
//       CompassSettings(
//         enabled: true,
//         position: OrnamentPosition.TOP_RIGHT,
//         marginRight: 8.0,
//         marginTop: 8.0,
//       ),
//     );
//     print("Attribution settings applied");
//   }

// }

// // class _MapboxScreenState extends State<MapboxScreen> {
// //   MapboxMap? mapController;
// //   CameraOptions? initialCamera;
// //   PointAnnotationManager? annotationManager;
// //   bool _initialized = false;

// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     if (!_initialized) {
// //       final helper = context.read<ClubDataHelper>();
// //       helper.loadInitialClubs();
// //       _initialized = true;
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeCamera();
// //   }



// //   void _onMapCreated(MapboxMap controller) {
// //     mapController = controller;
// //     _enableUserLocation();
// //   }





// // //TODO Download offline map and use as default unless .....

// //   void _addClubMarkers() {
// //     final clubs = context.read<ClubDataHelper>().clubDataList.value;
// //     annotationManager?.deleteAll();
// //     for (var club in clubs) {
// //       annotationManager?.create(PointAnnotationOptions(
// //         geometry: Point(coordinates: Position(club.lon, club.lat)),
// //         iconImage: 'club-icon',
// //         iconSize: 0.7,
// //         textField: club.name,
// //         textOffset: [0, 1.5],
// //       ));
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     context.read<ClubDataHelper>().clubDataList.removeListener(_addClubMarkers);
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (initialCamera == null) {
// //       return const Center(child: CircularProgressIndicator());
// //     }


// //   }

// // //TO center on a club
// //   // mapController?.camera.easeTo(
// // //   CameraOptions(
// // //     center: Position(club.lon, club.lat),
// // //     zoom: 15.0,
// // //   ),
// // //   MapAnimationOptions(duration: 1000),
// // // );


