import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';


class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String result = "Scan a QR code";

  Future<void> scanQRCode() async {
    try {
      var result = await BarcodeScanner.scan();
      // Handle the scanned result, for example, navigate to the booking screen
      if (result.rawContent.isNotEmpty) {
        Navigator.pushNamed(context, '/booking_details', arguments: result.rawContent);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.result = 'Camera permission denied';
        });
      } else {
        setState(() {
          this.result = 'Unknown error: $e';
        });
      }
    } on FormatException {
      // User pressed back button or cancelled the scan
      setState(() {
        this.result = 'Scan cancelled';
      });
    } catch (e) {
      setState(() {
        this.result = 'Unknown error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              result,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                scanQRCode();
              },
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
