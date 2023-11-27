import 'package:alphine_parking/user/models/booking.dart';
import 'package:alphine_parking/user/models/parking_spot.dart';
import 'package:alphine_parking/user/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataRepository {
  final CollectionReference parkingSpotsCollection =
      FirebaseFirestore.instance.collection('ParkingSpots');
  final CollectionReference bookingsCollection =
      FirebaseFirestore.instance.collection('BookingID');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('UserID');


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
              latitude: (doc['latitude'] as num?)?.toDouble() ?? 0.0,
              longitude: (doc['longitude'] as num?)?.toDouble() ?? 0.0,
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
              // userName: doc['userName']?? 'N/A',
              // userPhone: doc['userName']?? 'N/A',
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
              userID: doc['userID'] ?? 'N/A',
            ))
        .toList();

    return users;
  }
}
