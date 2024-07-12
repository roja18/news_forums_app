import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPasswordType;
  final TextEditingController controller;

  const ReusableTextField({
    required this.text,
    required this.icon,
    required this.isPasswordType,
    required this.controller,
  });

  @override
  _ReusableTextFieldState createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (widget.isPasswordType) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
        } else {
          if (widget.text == 'Enter Email Address') {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (!emailValid) {
              return 'Please enter a valid email';
            }
          } else if (widget.text == 'Enter FullName') {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            if (value.length < 10) {
              return 'Fullname must be at least 10 characters';
            }
          } else if (widget.text == 'Enter Registration Number') {
            if (value == null || value.isEmpty) {
              return 'Please enter your registration number';
            }
            if (value.length < 10) {
              return 'Registration number must be at least 10 characters';
            }
          }
        }
        return null;
      },
      controller: widget.controller,
      obscureText: widget.isPasswordType ? isObscure : false,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      cursorColor: Colors.black,
      style: TextStyle(color: Color.fromARGB(255, 4, 56, 145).withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.lightGreen,
        ),
        suffixIcon: widget.isPasswordType
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black45,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white38,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: widget.isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
Container signInSignoutbutton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'LOGIN' : 'REGSTER',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.lightGreen;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
    ),
  );
}

class ReusableTextareaFild extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPasswordType;

  ReusableTextareaFild({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPasswordType = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordType,
        maxLines: null, // Allow unlimited number of lines
        keyboardType: TextInputType.multiline, // Enable multiline input
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
