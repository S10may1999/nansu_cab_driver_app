import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nansu_driver/global/global_var.dart';
import 'package:nansu_driver/pushnotification/push_notification_system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  Color colorToShow = Colors.green;
  String titleToShow = "GO ONLINE NOW";
  bool isDriverAvailable = false;
  DatabaseReference? newTripRequestReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePushNotificationSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 200),
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlexInitialPosition,
          onMapCreated: (GoogleMapController mapController) {
            controllerGoogleMap = mapController;
            updateMapTheme(controllerGoogleMap!);
            googleMapCompleterController.complete(controllerGoogleMap);
            getCurrentLiveLocationOfUser();
          },
        ),
        Container(
          height: 136,
          width: double.infinity,
          color: Colors.black54,
        )

        // Go Online or Offline Button implementation

        ,
        Positioned(
          top: 61,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.7, 0.7))
                                ]),
                            height: 221,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  Text(
                                    (!isDriverAvailable)
                                        ? "GO ONLINE NOW"
                                        : "GO OFFLINE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 21,
                                  ),
                                  Text(
                                    (!isDriverAvailable)
                                        ? "You are about to go online, you will become available to receive trip request from user."
                                        : "You are about go offline, you will not receive the trip request from user.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white30,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Back"),
                                      )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          if (!isDriverAvailable) {
                                            //go online
                                            goOnlineNow();
                                            //get driver location update
                                            setAndGetLocationUpdate();

                                            Navigator.pop(context);
                                            setState(() {
                                              colorToShow = Colors.red;
                                              titleToShow = "GO OFFLINE";
                                              isDriverAvailable = true;
                                            });
                                          } else {
                                            //go offline
                                            goOfflineNow();
                                            //stop driver location update
                                            Navigator.pop(context);
                                            setState(() {
                                              colorToShow = Colors.green;
                                              titleToShow = "GO ONLINE NOW";
                                              isDriverAvailable = false;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                (titleToShow == "GO ONLINE NOW")
                                                    ? Colors.green
                                                    : Colors.red),
                                        child: Text("Confirm"),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: colorToShow),
                  child: Text(
                    titleToShow,
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        )
      ],
    ));
  }

  initializePushNotificationSystem() {
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.generateDeviceRegisterationToken();
    pushNotificationSystem.startListeningForNewNotification();
  }

  goOfflineNow() {
    // stop sharing live location
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);

    // stop listening to the new trip status
    newTripRequestReference!.onDisconnect();
    newTripRequestReference!.remove();
    newTripRequestReference = null;
  }

  setAndGetLocationUpdate() {
    positionStreamHomePage =
        Geolocator.getPositionStream().listen((Position position) {
      currentPositionOfUser = position;
      if (isDriverAvailable) {
        Geofire.setLocation(
          FirebaseAuth.instance.currentUser!.uid,
          currentPositionOfUser!.latitude,
          currentPositionOfUser!.longitude,
        );
      }
      LatLng positionLatlng = LatLng(position.latitude, position.longitude);
      controllerGoogleMap!
          .animateCamera(CameraUpdate.newLatLng(positionLatlng));
    });
  }

  goOnlineNow() {
    // drivers available
    Geofire.initialize("onlineDrivers");
    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      currentPositionOfUser!.latitude,
      currentPositionOfUser!.longitude,
    );

    newTripRequestReference = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("newTripStatus");

    newTripRequestReference!.set("waiting");
    newTripRequestReference!.onValue.listen((event) {});
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromTheme("themes/dark_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromTheme(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
    print(positionOfUser);
    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
