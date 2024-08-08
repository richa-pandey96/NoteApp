// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/login_screen.dart';
import 'package:note_app/notes_home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

  // void _handleSignUp() async {
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: _email,
  //       password: _password,
  //     );
  //     print("User Registered: ${userCredential.user!.email}");
  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Registration successful! Please log in."),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //     // Navigate to the login screen after a delay
  //     Future.delayed(Duration(seconds: 2), () {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //       );
  //     });
  //   } catch (e) {
  //     print("Error During Registration: $e");
  //     // Show error message to the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Registration failed: ${e.toString()}")),
  //     );
  //   }
  // }



  void _handleSignUp() async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    User? user = userCredential.user;
    if (user != null) {
      print("User Registered: ${user.email}");
      // Optionally, set initial user data in Firestore or elsewhere

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  } catch (e) {
    print("Error During Registration: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error during registration: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 2, 38, 66),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSignUp();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account? "),
                      TextButton(
                        child: Text(
                          "Login",
                          style: TextStyle(color: Color.fromARGB(255, 15, 130, 224)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
