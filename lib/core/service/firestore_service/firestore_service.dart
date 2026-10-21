import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/service/location_service/location_model.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  /// Instances
  static final fireStore = FirebaseFirestore.instance;

  /// Method to add new user to firestore

  static Future<void> sendUserLocation({
    required LocationModel location,
  }) async {
    try {
      await fireStore.collection('locations').add(location.toJson());
      debugPrint(
        "location sent successfully to firestore:${location.toJson()}",
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
