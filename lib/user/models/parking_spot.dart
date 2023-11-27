class ParkingSpot {
  final String ParkingSpotID;
  final String name;
  final String address;
  double price;
  bool available; // Changed to non-final for availability updates.
  final String ImageURL;
  final String ownerName;
  final double rating;
  final List<String> facilities;
  final double latitude;
  final double longitude;

  

  ParkingSpot({
    required this.ParkingSpotID,
    required this.name,
    required this.address,
    required this.price,
    required this.available,
    required this.ImageURL,
    required this.ownerName,
    required this.rating,
    required this.facilities,
    required this.latitude, 
    required this.longitude, 
    
  });

  get id => null;
  
Map<String, dynamic> toMap() {
    return {
      'ParkingSpotID': ParkingSpotID,
      'name': name,
      'address': address,
      'price': price,
      'available': available,
      'ImageURL': ImageURL,
      'ownerName': ownerName,
      'rating': rating,
      'facilities': facilities,
      'latitude':latitude,
      'longitude':longitude,
    };
  }


  ParkingSpot toggleAvailability() {
    return ParkingSpot(
      ParkingSpotID: ParkingSpotID,
      name: name,
      address: address,
      price: price,
      available: !available, 
      ImageURL: ImageURL,
      ownerName: ownerName,
      rating: rating,
      facilities: facilities,
      latitude: latitude,
      longitude: longitude,
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
