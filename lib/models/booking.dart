class Booking {
  final String parkingSpotId;
  final String vehicleNumber;
  final String vehicleType;
  final String amount;
  final DateTime bookingDateTime;
  final String status;
  final String userId;

  Booking({
    required this.parkingSpotId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.amount,
    required this.bookingDateTime,
    required this.status,
    required this.userId,
  });
}
