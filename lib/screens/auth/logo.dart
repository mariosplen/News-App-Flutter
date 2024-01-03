import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("The News App",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, fontFamily: GoogleFonts.texturina().fontFamily)),
        Image.asset(
          'assets/images/logo.png',
          height: 300,
        )
      ],
    );
  }
}
