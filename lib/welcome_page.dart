import 'package:flutter/material.dart';
import 'package:my_music_player/teb_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4c6f8d),
              Color(0xff3a5c78),
              Color(0xff2d4a68),
              Color(0xff1b3654),
              Color(0xff0e2746),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/mellow.png'),
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Getting Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Getting Started Getting',
                  style: TextStyle(color: Colors.white60, fontSize: 18),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  ShowTab(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff4c6f8d),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Let's Play",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                Text(
                  'MARSHMELLO',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'BEST MUSIC PLAYER',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
