import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nansu_driver/authentication/signup_screen.dart';
import 'package:nansu_driver/global/global_var.dart';
import 'package:nansu_driver/methods/common_methods.dart';
import 'package:nansu_driver/pages/dashboard.dart';
import 'package:nansu_driver/widgets/loading_dialog.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CommonMethods cMethod = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/images/uberexec.png",
                width: 220,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Login As Driver",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 10),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SignUpScreen()));
                  },
                  child: Text(
                    "Don't you have Account ? Register Here",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  checkIfNetworkIsAvailable() {
    cMethod.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailController.text.contains("@") &&
        passwordController.text.trim().length < 5) {
      cMethod.displaySnackBar(
          "Please Enter Valid name or phone number or email or password",
          context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "getting Login..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text)
            .catchError(
      (errorMessage) {
        Navigator.pop(context);
        cMethod.displaySnackBar(errorMessage.toString(), context);
      },
    ))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("driver")
          .child(userFirebase.uid);
      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethod.displaySnackBar(
                "Your are blocked, contact Customer Service @+91-8291660633",
                context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethod.displaySnackBar("Your Record do not Exist as User", context);
        }
      });
    }
  }
}
