import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final bool showIcon;
  final bool showPsw;
  final TextInputType textInputType;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool? showLoginIcon;
  final Icon? loginIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.showIcon,
    required this.showPsw,
    required this.textInputType,
    required this.readOnly,
    required this.validator,
    this.maxLines,
    this.showLoginIcon,
    this.loginIcon,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    showPassword = widget.showPsw;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        // keyboardType: widget.textInputType,
        obscureText: showPassword,
        readOnly: widget.readOnly,
        validator: widget.validator,
        cursorColor: Colors.black,
        maxLines: widget.maxLines ?? 1,
        textInputAction: widget.showPsw ? TextInputAction.done : TextInputAction.newline,
        style: const TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 14,
        ),
        focusNode: _focusNode,
        onFieldSubmitted: (value) {
          _focusNode.requestFocus();
        },
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            color: const Color(0xFFfb6f92),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Color(0xFFfb6f92)),
          ),
          prefixIcon: widget.showLoginIcon! ? widget.loginIcon : null,
          suffixIcon: widget.showIcon
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
