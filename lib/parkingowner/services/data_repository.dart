import 'package:alphine_parking/parkingowner/models/parking_spot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerDataRepository {
  final CollectionReference parkingSpotsCollection =
      FirebaseFirestore.instance.collection('ParkingSpots');

  Future<List<ParkingSpot>> getParkingSpotsForOwner(String ownerID) async {
    // Query parking spots for a specific owner.
    QuerySnapshot querySnapshot = await parkingSpotsCollection
        .where('ownerID', isEqualTo: ownerID)
        .get();

    List<ParkingSpot> ownerParkingSpots = querySnapshot.docs
        .map((doc) => ParkingSpot(
              ParkingSpotID: doc.id,
              name: doc['name'],
              address: doc['address'],
              price: doc['price'].toDouble(),
              available: doc['available'],
              ImageURL: doc['ImageURL'] ?? 'N/A',
              ownerName: doc['ownerName'],
              ownerID: doc['ownerID'] ?? 'N/A',
              rating: doc['rating'].toDouble() ?? 'N/A',
              facilities: List<String>.from(doc['facilities']),
            ))
        .toList();

    return ownerParkingSpots;
  }

  Future<void> toggleParkingSpotAvailability(String parkingSpotID) async {
    // Toggle the availability of a parking spot for the owner.
    final DocumentReference spotReference =
        parkingSpotsCollection.doc(parkingSpotID);

    final DocumentSnapshot spotSnapshot = await spotReference.get();
    if (spotSnapshot.exists) {
      final bool currentAvailability = spotSnapshot['available'];
      await spotReference.update({'available': !currentAvailability});
    } else {
      throw Exception('Parking spot not found');
    }
  }

  Future<void> updateParkingSpotPricing(
      String parkingSpotID, double newPrice) async {
    // Update the pricing of a parking spot for the owner.
    final DocumentReference spotReference =
        parkingSpotsCollection.doc(parkingSpotID);

    final DocumentSnapshot spotSnapshot = await spotReference.get();
    if (spotSnapshot.exists) {
      await spotReference.update({'price': newPrice});
    } else {
      throw Exception('Parking spot not found');
    }
  }
}
