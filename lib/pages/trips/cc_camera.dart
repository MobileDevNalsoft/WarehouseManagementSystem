import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CCTVScreen extends StatefulWidget {
  @override
  _CCTVScreenState createState() => _CCTVScreenState();
}

class _CCTVScreenState extends State<CCTVScreen> {
  String apiUrl = "http://localhost:3000/api/snapshot"; // Change to your server IP
  Uint8List? imageBytes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImage(); // Start fetching the first image
  }

  Future<void> fetchImage() async {
    

    while (mounted) {
      try {
        setState(() {
          isLoading = true; // Start loading
        });

        final response = await http.get(Uri.parse("$apiUrl?t=${DateTime.now().millisecondsSinceEpoch}"));
        
        if (response.statusCode == 200) {
          setState(() {
            imageBytes = response.bodyBytes; // Store image as bytes
          });
        } else {
          print("Failed to load image: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching image: $e");
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Snapshot Feed")),
      body: Center(
        child: imageBytes != null
            ? Image.memory(
                imageBytes!,
                errorBuilder: (context, error, stackTrace) => Text("Error loading image", ),
                gaplessPlayback: true, 

              )
            : isLoading
                ? CircularProgressIndicator()
                : Text("No Image Available", style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
