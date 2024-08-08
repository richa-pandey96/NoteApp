import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String note;
  int color;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  Note({
    required this.id,
    required this.title,
    required this.note,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'color': color,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
    };
  }

  factory Note.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('Error parsing date string: $e');
          return DateTime.now();
        }
      } else {
        return DateTime.now();
      }
    }

    return Note(
      id: id,
      title: map['title'] ?? '',
      note: map['note'] ?? '',
      color: map['color'] ?? 0,
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
      userId: map['userId'] ?? '',
    );
  }

  static int generateRandomLightColor() {
    Random random = Random();
    int red = 200 + random.nextInt(56); // Values between 200 and 255
    int green = 200 + random.nextInt(56);
    int blue = 200 + random.nextInt(56);
    return Color.fromARGB(255, red, green, blue).value;
  }
}
