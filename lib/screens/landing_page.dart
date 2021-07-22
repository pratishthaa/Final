import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_store/constants.dart';
import 'package:your_store/screens/home_page.dart';
import 'package:your_store/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //If snapshot has error

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        //Connection Initialized - Firebase App is running

        if (snapshot.connectionState == ConnectionState.done) {
          //StreamBuilder can check the login state live

          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              //If Stream Snapshot has error

              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              //Connection state active - Do the user login check inside the if statement

              if (streamSnapshot.connectionState == ConnectionState.active) {
                //Get User

                Object? _user = streamSnapshot.data;

                //If the user is null, we're logged in
                if (_user == null) {
                  //The user is not logged in, head to login page

                  return LoginPage();
                } else {
                  //The user is logged in, head to homepage

                  return HomePage();
                }
              }

              //Checking the Auth State

              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        //Connecting to Firebase Project - Loading

        return Scaffold(
          body: Center(
            child: Text(
              "Initializing App..",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
