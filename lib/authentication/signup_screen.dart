import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nansu_driver/authentication/login_screen.dart';
import 'package:nansu_driver/methods/common_methods.dart';
import 'package:nansu_driver/pages/dashboard.dart';
import 'package:nansu_driver/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController carColorController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  String urlOfUploadedImage = "";

  CommonMethods cmethods = CommonMethods();
  XFile? imageFile;

  chooseImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  chooseImageFromGallery();
                },
                child: imageFile == null
                    ? const CircleAvatar(
                        radius: 86,
                        backgroundImage:
                            AssetImage("assets/images/avatarman.png"),
                      )
                    : Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          image: DecorationImage(
                            image: FileImage(
                              File(imageFile!.path),
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  chooseImageFromGallery();
                },
                child: Text(
                  "Choose Image",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Driver Name",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: numberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
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
                      height: 22,
                    ),
                    TextField(
                      controller: carNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Name",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: carColorController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Color",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: carNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Car Number",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      child: const Text(
                        "Register",
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
                        MaterialPageRoute(builder: (c) => LogInScreen()));
                  },
                  child: Text(
                    "Already have an Account? Login here",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  checkIfNetworkIsAvailable() {
    cmethods.checkConnectivity(context);

    if (imageFile != null) {
      signUpFormValidation();
    } else {
      cmethods.displaySnackBar("Please Select the image First !!", context);
    }
  }

  uploadImageToStorage() async {
    String imageIdName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("images").child(imageIdName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    urlOfUploadedImage = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      urlOfUploadedImage;
    });
    registerNewDriver();
  }

  signUpFormValidation() {
    if (usernameController.text.trim().length < 2 &&
        numberController.text.trim().length < 10 &&
        !emailController.text.contains("@") &&
        passwordController.text.trim().length < 5 &&
        carNumberController.text.isEmpty &&
        carColorController.text.isEmpty) {
      cmethods.displaySnackBar(
          "Please Enter Valid name or phone number or email or password",
          context);
    } else {
      uploadImageToStorage();
    }
  }

  registerNewDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering Account.."),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text)
            .catchError(
      (errorMessage) {
        Navigator.pop(context);
        cmethods.displaySnackBar(errorMessage.toString(), context);
      },
    ))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(userFirebase!.uid);

    Map driverCarInfo = {
      "carColor": carColorController.text.trim(),
      "carModel": carModelController.text.trim(),
      "carNumber": carNumberController.text.trim(),
      "carName": carNameController.text.trim()
    };
    Map driverDataMap = {
      "photo": urlOfUploadedImage,
      "car_details": driverCarInfo,
      "name": usernameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": numberController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    driverRef.set(driverDataMap);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }
}
