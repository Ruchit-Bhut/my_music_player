import 'package:flutter/material.dart';

class BottomPlay extends StatefulWidget {
  const BottomPlay({Key? key}) : super(key: key);

  @override
  State<BottomPlay> createState() => _BottomPlayState();
}

class _BottomPlayState extends State<BottomPlay> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff75697b),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
            child: Column(
              children: [
                Text(
                  'Song Name',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.70), fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Artist Name',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.40), fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.skip_previous_outlined,color: Colors.white,size: 50,),
          const Icon(Icons.play_circle_outline_rounded,color: Colors.white,size: 70,),
          const Icon(Icons.skip_next_outlined,color: Colors.white,size: 50,),
        ],
      ),
    );
  }
}
