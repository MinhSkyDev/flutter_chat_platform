import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreadComponent extends StatelessWidget {
  final String name;
  final String firstMessage;
  final VoidCallback onClick;
  final int index;

  const ThreadComponent(
      {super.key,
      required this.name,
      required this.firstMessage,
      required this.onClick,
      required this.index});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: screenHeight * 0.1,
        width: screenWidth * 0.9,
        child: ElevatedButton(
          onPressed: onClick,
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(20, 205, 200, 95)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "#$index",
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                name.length <= 10 ? name : "${name.substring(0, 10)}....",
                style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
