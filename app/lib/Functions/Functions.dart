import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final TextEditingController textEditingController;

  const TextContainer({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.textEditingController
  });

  Size getScreenSize(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.5),
      child:
      TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: icon,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[550])),
      ),
    );
  }
}



class Logos extends StatelessWidget {
  final IconData icone;
  const Logos({
    super.key,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child:
      Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child:
          //Image.asset(
          //  path,
          //  fit:BoxFit.fill,
          //),
          Icon(icone),
      ),
    );
  }
}
void createPopUp(Future<String> alert, BuildContext context) async {
  String message =  await alert;

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        )
      ],
    ),
  );
}