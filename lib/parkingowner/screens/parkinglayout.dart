import 'package:flutter/material.dart';
import '../models/floor_model.dart';

class ParkingLayoutScreen extends StatefulWidget {
  final ParkingData parkingData;

  ParkingLayoutScreen(this.parkingData);

  @override
  _ParkingLayoutScreenState createState() => _ParkingLayoutScreenState();
}

class _ParkingLayoutScreenState extends State<ParkingLayoutScreen> {
  late List<List<bool>> selectedParkingSpots;

  @override
  void initState() {
    super.initState();
    selectedParkingSpots = List.generate(widget.parkingData.floorCount, (index) => List.filled(25, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Space Layout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          Text(
            'Select Number of floors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.parkingData.floorCount != 1
                  ? IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          widget.parkingData.floorCount--;
                          selectedParkingSpots = List.generate(
                              widget.parkingData.floorCount, (index) => List.filled(25, false));
                        });
                      },
                    )
                  : Container(),
              Text(widget.parkingData.floorCount.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.parkingData.floorCount++;
                    selectedParkingSpots = List.generate(
                        widget.parkingData.floorCount, (index) => List.filled(25, false));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int floor = 1; floor <= widget.parkingData.floorCount; floor++)
                    ParkingFloor(
                      floor: floor,
                      selectedParkingSpots: selectedParkingSpots[floor - 1],
                      onParkingSpotToggled: (int spotIndex) {
                        setState(() {
                          selectedParkingSpots[floor - 1][spotIndex] =
                              !selectedParkingSpots[floor - 1][spotIndex];
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Pass back the selected parking spots and floor count when saving changes.
              final updatedData = ParkingData(
                floorCount: widget.parkingData.floorCount,
                selectedParkingSpots: selectedParkingSpots,
              );
              Navigator.pop(context, updatedData);
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 116, 82, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(400, 50),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}


class ParkingFloor extends StatefulWidget {
  final int floor;
  final List<bool> selectedParkingSpots;
  final Function(int) onParkingSpotToggled;

  ParkingFloor({
    required this.floor,
    required this.selectedParkingSpots,
    required this.onParkingSpotToggled,
  });

  @override
  _ParkingFloorState createState() => _ParkingFloorState();
}

class _ParkingFloorState extends State<ParkingFloor> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      color: Color.fromARGB(255, 236, 236, 236),
      child: Column(
        children: <Widget>[
          Text(
            'Floor ${widget.floor}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 7,
              ),
              itemCount: 25, // Assuming 25 spots for each floor.
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index % 5 == 2) {
                  return EmptySpace();
                } else {
                  final parkingNumber = index + 1;
                  return GestureDetector(
                    onTap: () {
                      // Toggle the selected state of the parking space and notify the parent.
                      widget.onParkingSpotToggled(index);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4.0,
                      color: (index >= 0 && index < widget.selectedParkingSpots.length)
                          ? (widget.selectedParkingSpots[index] ? Colors.green : Colors.grey)
                          : Colors.grey, // Provide a default color when the index is out of range
                      child: Center(
                        child: Text(
                          'PS A$parkingNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmptySpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
    );
  }
}

class ParkingData {
  int floorCount;
  List<List<bool>> selectedParkingSpots;

  ParkingData({required this.floorCount, required this.selectedParkingSpots});

  // Convert to a flat list
  List<bool> flattenSelectedParkingSpots() {
    final flatList = <bool>[];
    for (var floor in selectedParkingSpots) {
      flatList.addAll(floor);
    }
    return flatList;
  }
}
