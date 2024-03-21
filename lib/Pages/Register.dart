import 'package:flutter/material.dart';
import "package:register/Functions/Functions.dart";

class Register extends StatelessWidget {
  //final ScreenWidht;
  //final ScreenHeight;

  //final void Function() switchPages;
  final void Function() switchPages;
  const Register({Key? key, required this.switchPages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(getScreenSize(context).height);
    print(getScreenSize(context).width);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: switchPages,
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black, // Optionally, set the color of the icon
        ),
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
            child:SingleChildScrollView(
              child: Column(
                  children:[
                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.arrow_back_ios_new)
                        ),
                      ],
                    ),
                     */
                    Icon(
                        Icons.person_outlined,
                        size: 100,
                        //color: Colors.lightGreen[900]
                        color: Colors.grey[300]
                    ),
                    const Text('Create Account',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Create New Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 50),

                    const TextContainer(hintText: "E-mail", obscureText: false, icon: Icon(Icons.mail)),
                    const SizedBox(height: 15),

                    const TextContainer(hintText: "Password", obscureText: true,icon: Icon(Icons.key)),


                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap:(){

                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                  ]
              ),
            )
        ),
      ),
    );
  }
}
Size getScreenSize(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  return mediaQuery.size;
}



