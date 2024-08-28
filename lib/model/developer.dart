import 'package:flutter/material.dart';
class Developer {
  final String name;
  final String group;
  String? serie;
  final String image;

  Developer({
    required this.name,
    required this.group,
    this.serie,
    required this.image,
  });
}