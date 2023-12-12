import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ),
    );
  }
}