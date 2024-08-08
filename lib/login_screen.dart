// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/notes_home.dart';
import 'package:note_app/signuppage.dart';
//import 'package:note_app/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";
  Future<void> _handleLogin() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    User? user = userCredential.user;
    if (user != null) {

      SharedPreferences prefs=await SharedPreferences.getInstance();
      await prefs.setString('uid',user.uid);
      print("User Logged In: ${user.email}");

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful!")),
      );

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NotesHomesScreen(),
        ),
      );
    }
  } catch (e) {
    print("Error During Login: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error during login: $e")),
    );
  }
}
Future<bool> _checkExistingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    return uid != null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  child: Text("Login"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      child: Text("Signup"),
                      onPressed: () {
                        _auth.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                    ),
                  ],
                ),
              //  FutureBuilder<bool>(
              //     future: _checkExistingUser(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData && snapshot.data!) {
              //         // User exists - redirect to home screen
              //         Future.delayed(Duration(seconds: 0), () {
              //           Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => NotesHomesScreen(),
              //             ),
              //           );
              //         });
              //         return Text(
              //           "Welcome back! Redirecting to your notes...",
              //           style: TextStyle(color: Colors.green),
              //         );
              //       } else {
              //         // No user found - show login form
              //         return Container();
              //       }
              //     },
              //   ),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
