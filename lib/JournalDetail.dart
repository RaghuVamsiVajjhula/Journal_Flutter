import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:untitled/journal_entry.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';

class JournalDetail extends StatefulWidget {
  final JournalEntry entry;

  const JournalDetail({super.key, required this.entry});

  @override
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetail> {
  String? _locationName;

  @override
  void initState() {
    super.initState();
    _resolveLocationName();
  }

  Future<void> _resolveLocationName() async {
    if (widget.entry.locationName != null &&
        widget.entry.locationName!.isNotEmpty) {
      setState(() {
        _locationName = widget.entry.locationName ?? 'No location set';
      });
      return;
    }

    if (widget.entry.latitude != null && widget.entry.longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.entry.latitude!,
          widget.entry.longitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _locationName =
                '${place.locality}, ${place.administrativeArea}, ${place.country}';
          });
        } else {
          setState(() {
            _locationName = 'Unknown location';
          });
        }
      } catch (e) {
        setState(() {
          _locationName = 'Unable to fetch location';
        });
      }
    } else {
      setState(() {
        _locationName = 'Location not available';
      });
    }
  }

  Widget _buildImageGallery(List<String> imagePaths) {
    if (imagePaths.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, imageIndex) {
          return InstaImageViewer(
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(
                  horizontal: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imagePaths[imageIndex])),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.circular(8.0),
                border:
                    Border.all(color: Colors.grey.shade300),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(widget.entry.title,
            style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.entry.imagePaths.isNotEmpty)
                _buildImageGallery(widget.entry.imagePaths),
              const SizedBox(height: 16),
              Text(
                widget.entry.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.entry.mood != null &&
                  widget.entry.mood!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.mood, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Mood: ${widget.entry.mood}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              if (widget.entry.locationName != null &&
                  widget.entry.locationName!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location: ${widget.entry.locationName!}',
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),

              const SizedBox(height: 16),
              Text(
                widget.entry.content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
