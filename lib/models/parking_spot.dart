class ParkingSpot {
  final String parkingSpotID;
  final String name;
  final String location;
  double price;
  bool available; // Changed to non-final for availability updates.
  final String imageURL;
  final String ownerName;
  final double rating;
  final List<String> facilities;

  ParkingSpot({
    required this.parkingSpotID,
    required this.name,
    required this.location,
    required this.price,
    required this.available,
    required this.imageURL,
    required this.ownerName,
    required this.rating,
    required this.facilities,
  });

  // Add a method to toggle availability.
  ParkingSpot toggleAvailability() {
    return ParkingSpot(
      parkingSpotID: parkingSpotID,
      name: name,
      location: location,
      price: price,
      available: !available, // Toggle availability.
      imageURL: imageURL,
      ownerName: ownerName,
      rating: rating,
      facilities: facilities,
    );
  }

  // Getter and setter for pricing
  double get getPricing => price;
  set setPricing(double newPrice) {
    if (newPrice >= 0) {
      price = newPrice;
    }
  }

  // Method to reserve the spot
  void reserve() {
    if (available) {
      available = false;
      // Add logic here to mark the spot as reserved in the database.
    }
  }

  // Method to release the spot
  void release() {
    if (!available) {
      available = true;
      // Add logic here to update the database to mark the spot as available.
    }
  }
}
