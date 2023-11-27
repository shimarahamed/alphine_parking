class Booking {
  final String ParkingSpotID;
  final String VehicleNumber;
  final String VehicleType;
  double price;
  final DateTime bookingDateTime;
  final String status;
  final String userID;
  int duration;
  final String paymentMethod;
  final String name;
  final String ParkingSpot;

  Booking({
    required this.ParkingSpotID,
    required this.VehicleNumber,
    required this.VehicleType,
    required this.price,
    required this.bookingDateTime,
    required this.status,
    required this.userID,
    required this.duration,
    required this.paymentMethod,
    required this.name,
    required this.ParkingSpot,
  });
}
