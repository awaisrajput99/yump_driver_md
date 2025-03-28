import 'package:flutter/material.dart';

class MapleLeafWidget extends StatelessWidget {
  const MapleLeafWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.35,
        ),
        Container(
          width: double.infinity,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ic_maple_leaf.png"),
              // Your image
              fit: BoxFit.contain, // Adjust to cover the entire container
            ),
          ),
          child: Container(
            color: Colors.white.withOpacity(0.95), // Semi-transparent overlay
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "100% canadian app 🍁",
          style: TextStyle(color: Colors.grey.withOpacity(0.4)),
        )
      ],
    );
  }
}
