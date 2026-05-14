import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType keyboardType;

  // NEW
  final Widget? prefixIcon;
  final String? prefixText;

  const AuthTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,

    // NEW
    this.prefixIcon,
    this.prefixText,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,

      decoration: InputDecoration(
        fillColor: Colors.white,

        labelText: widget.label,

        // NEW
        prefixIcon: widget.prefixIcon,

        // NEW
        prefixText: widget.prefixText,

        prefixStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),

        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : (widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}