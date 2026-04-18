
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool check;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon = Icons.abc,

    this.check = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            check == true
                ? Icon(icon, color: Colors.white, size: 30)
                : Text(""),
            SizedBox(width: 10),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
