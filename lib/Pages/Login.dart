import 'package:flutter/material.dart';
import 'package:register/Functions/Functions.dart';


class Login extends StatelessWidget {
  //final ScreenWidht;
  //final ScreenHeight;

  //final void Function() switchPages;

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        print(getScreenSize(context).height);
        print(getScreenSize(context).width);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child:SingleChildScrollView(
                child: Column(
                    children:[
                      Icon(
                        Icons.person_outlined,
                        size: 100,
                        //color: Colors.lightGreen[900]
                          color: Colors.grey[300]
                      ),
                      const Text('Welcome, Back!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('sign in to continue',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 50),

                      const TextContainer(hintText: "UserName", obscureText: true, icon: Icon(Icons.mail)),
                      const SizedBox(height: 15),

                      const TextContainer(hintText: "Password", obscureText: true,icon: Icon(Icons.lock)),

                      GestureDetector(
                        onTap: () {
                          // Implement your forgot password logic here
                          // For example, you can navigate to a forgot password screen
                        },
                        child:
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 27.5),
                                    child:
                                      Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Color.fromRGBO(85, 139, 47, 1),
                                          fontSize: 16
                                        ),
                                      ),
                                  )
                              ],
                            )
                          ),
                      const SizedBox(height: 25),

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
                                  "Sign In",
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Logos(path: '../Imgs/Google.png'),
                          SizedBox(width: 25),
                          Logos(path: '../Imgs/Google.png'),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style:TextStyle(
                                  fontSize: 18,
                              ),
                          ),
                          GestureDetector(

                            child: Text("Register",
                              style: TextStyle(
                                  color: Colors.lightGreen[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      )
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
