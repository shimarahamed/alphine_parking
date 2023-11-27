import 'package:alphine_parking/admin/models/booking.dart';
import 'package:alphine_parking/admin/models/parking_spot.dart';
import 'package:alphine_parking/admin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataRepository {
  final CollectionReference parkingSpotsCollection =
      FirebaseFirestore.instance.collection('ParkingSpots');
  final CollectionReference bookingsCollection =
      FirebaseFirestore.instance.collection('BookingID');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('UserID');
  final CollectionReference ownersCollection =
      FirebaseFirestore.instance.collection('Owners');

  Future<List<ParkingSpot>> getParkingSpots() async {
    QuerySnapshot querySnapshot = await parkingSpotsCollection.get();
    List<ParkingSpot> ParkingSpots = querySnapshot.docs
        .map((doc) => ParkingSpot(
              ParkingSpotID: doc.id,
              name: doc['name'],
              address: doc['address'],
              price: doc['price'].toDouble(),
              available: doc['available'],
              ImageURL: doc['ImageURL'] ?? 'N/A',
              ownerName: doc['ownerName'],
              rating: doc['rating'].toDouble() ?? 'N/A',
              facilities: List<String>.from(doc['facilities']),
            ))
        .toList();

    return ParkingSpots;
  }

  Future<List<Booking>> getBookings() async {
    QuerySnapshot querySnapshot = await bookingsCollection.get();
    List<Booking> bookings = querySnapshot.docs
        .map((doc) => Booking(
              ParkingSpotID: doc['ParkingSpotID'] ?? 'N/A',
              VehicleNumber: doc['VehicleNumber'] ?? 'N/A',
              VehicleType: doc['VehicleType'] ?? 'N/A',
              price: doc['price'].toDouble(),
              bookingDateTime: doc['bookingDateTime'].toDate(),
              status: doc['status'] ?? 'N/A',
              userID: doc['userID'] ?? 'N/A',
              duration: doc['duration'],
              paymentMethod: doc['paymentMethod'],
              name: doc['name'],
              ParkingSpot: doc['ParkingSpot'] ?? 'N/A',
            ))
        .toList();

    return bookings;
  }

  Future<List<User>> getUsers() async {
    QuerySnapshot querySnapshot = await usersCollection.get();
    List<User> users = querySnapshot.docs
        .map((doc) => User(
              name: doc['name'],
              phone: doc['phone'],
              email: doc['email'],
              nic: doc['nic'],
              photoURL: doc['photoURL'] ?? 'N/A',
              uid: doc['uid'] ?? 'N/A',
            ))
        .toList();

    return users;
  }

  Future<List<User>> getOwners() async {
    QuerySnapshot querySnapshot = await ownersCollection.get();
    List<User> owners = querySnapshot.docs
        .map((doc) => User(
              name: doc['name'],
              phone: doc['phone'],
              email: doc['email'],
              nic: doc['nic'],
              photoURL: doc['photoURL'] ?? 'N/A',
              uid: doc['uid'] ?? 'N/A',
            ))
        .toList();

    return owners;
  }
  
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updatedUserData) {
    return usersCollection.doc(uid).update(updatedUserData);
  }

  Future<void> deleteUser(String uid) async {
  DocumentSnapshot document = await usersCollection.doc(uid).get();

  if (document.exists) {
    await usersCollection.doc(uid).delete();
  } 
  else {
    print('Document with UID $uid does not exist.');
  }
}

  Future<void> updateOwnerProfile(String uid, Map<String, dynamic> updatedOwnersData) {
    return ownersCollection.doc(uid).update(updatedOwnersData);
  }

  Future<void> deleteOwner(String uid) async {
  DocumentSnapshot document = await ownersCollection.doc(uid).get();

  if (document.exists) {
    await ownersCollection.doc(uid).delete();
  } 
  else {
    print('Document with UID $uid does not exist.');
  }
}

  Future<void> updateParkingSpot(String parkingSpotID, Map<String, dynamic> updatedData) {
    return parkingSpotsCollection.doc(parkingSpotID).update(updatedData);
  }

  getBookingsForParkingSpots(List<String> ownedParkingSpots) {}

  getParkingSpotsForOwner() {}

}


