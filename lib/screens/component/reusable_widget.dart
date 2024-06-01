import 'package:flutter/material.dart';

TextFormField reusableTextFild(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: isPasswordType
        ? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }

            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          }
        : (value) {
            // add email validation
            if (text == 'Enter Email Address') {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }

              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return 'Please enter a valid email';
              }

              return null;
            }
            if (text == 'Enter FullName') {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }

              if (value.length < 6) {
                return 'Fullname must be at least 10 characters';
              }
              return null;
            }
            if (text == 'Enter Regstration Number') {
              if (value == null || value.isEmpty) {
                return 'Please enter your regstration number';
              }

              if (value.length < 6) {
                return 'Phone number must be at least 10 characters';
              }
              return null;
            }
            
          },
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    
    // autovalidateMode: AutovalidateMode.onUserInteraction,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Color.fromARGB(255, 4, 56, 145).withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.lightGreen,
      ),

      labelText: text,
      // hintText: hint,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white38,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
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
