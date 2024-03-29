import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.person, 'Profile'),
  Destination(Icons.settings, 'Endpoints'),
  Destination(Icons.logout, 'Logout'),
];
