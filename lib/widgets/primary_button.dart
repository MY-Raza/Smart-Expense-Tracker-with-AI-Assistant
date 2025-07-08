import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(40))
        ),
        child: Center(child: Text(label,style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black
        ),)),
      ),
      onTap: (){
        onPressed;
      },
    );
  }
}
