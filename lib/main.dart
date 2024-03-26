import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCYtuzLwt8BkIqlrbfVosEGJQaBaI31sDY",
            authDomain: "juhanform.firebaseapp.com",
            projectId: "juhanform",
            storageBucket: "juhanform.appspot.com",
            messagingSenderId: "948265785384",
            appId: "1:948265785384:web:408bb19825c340e37e7d1d",
            measurementId: "G-Y0Q4RJJPW2"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginForm(),
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  TextEditingController _errors = TextEditingController();

  //functions
  //login
  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      // Sign in success, mo balhin sa dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _errors.text = '$e';
    } catch (e) {
      _errors.text = '$e';
    }
  }

  //signup
  void _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      _errors.text = 'SignUp Succesfully!';
    } catch (e) {
      _errors.text = '$e';
    }
  }

//login and signup form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Title bar
      appBar: AppBar(
        title: Text(
          'FishBook',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 226, 15, 99),
      ),
      body: SafeArea(
        //form
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //logs errors
            SizedBox(
              width: 800,
              height: 30,
              child: TextField(
                controller: _errors,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //email textbox
            SizedBox(
              width: 200,
              height: 30,
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9.@]')),
                ],
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
              ),
            ),

            //password textbox
            SizedBox(
              width: 200,
              height: 30,
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //login
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.directions,
                    size: 50.0,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    _signIn();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Signup
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.upload,
                    size: 50.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _signUp();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Dashboard
class Dashboard extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.backwardStep,
              size: 40.10,
              color: Colors.red,
            ),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the FishBook!',
              style: TextStyle(fontSize: 60.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'User:',
              style: TextStyle(fontSize: 30.0),
            ),
            Text(
              user != null ? user.email ?? '' : '',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
