import 'package:flutter/material.dart';

class OnlineSongs extends StatefulWidget {
  const OnlineSongs({super.key});

  @override
  State<OnlineSongs> createState() => _OnlineSongsState();
}

class _OnlineSongsState extends State<OnlineSongs> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Online Songs',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
